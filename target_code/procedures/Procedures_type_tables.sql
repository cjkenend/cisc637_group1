CREATE OR REPLACE PROCEDURE normalize_table(
    p_original_table  IN VARCHAR2,
    p_original_column IN VARCHAR2,
    p_type_table      IN VARCHAR2,
    p_type_column     IN VARCHAR2
) IS
    v_type_table_pk   VARCHAR2(38);
    v_new_column_name VARCHAR2(38);
    v_constraint_name VARCHAR2(38);
    v_sql             VARCHAR2(2000);
BEGIN
    -- Step 1: Insert into type table
    v_sql := 'INSERT INTO ' || p_type_table || ' (' || p_type_column || ') 
              SELECT DISTINCT ' || p_original_column || ' FROM ' || p_original_table;
    EXECUTE IMMEDIATE v_sql;

    -- Step 2: Add new column to original table
    v_type_table_pk := p_type_table || '_ID';
    v_new_column_name := p_original_table || '_' || v_type_table_pk;
    v_sql := 'ALTER TABLE ' || p_original_table || ' ADD (' || v_new_column_name || ' VARCHAR2(38))';
    EXECUTE IMMEDIATE v_sql;

    -- Step 3: Update new column with type IDs
    v_sql := 'UPDATE ' || p_original_table || ' 
              SET ' || v_new_column_name || ' = (
                  SELECT ' || v_type_table_pk || ' 
                  FROM ' || p_type_table || ' 
                  WHERE ' || p_type_column || ' = ' || p_original_table || '.' || p_original_column || ')';
    EXECUTE IMMEDIATE v_sql;

    -- Step 4: Add foreign key constraint
    v_constraint_name := SUBSTR(p_original_table || '_FK_' || p_type_table, 1, 30);
    v_sql := 'ALTER TABLE ' || p_original_table || ' 
              ADD CONSTRAINT ' || v_constraint_name || ' 
              FOREIGN KEY (' || v_new_column_name || ') 
              REFERENCES ' || p_type_table || '(' || v_type_table_pk || ') ENABLE';
    EXECUTE IMMEDIATE v_sql;

    -- Step 5: Drop original column
    v_sql := 'ALTER TABLE ' || p_original_table || ' DROP COLUMN ' || p_original_column;
    EXECUTE IMMEDIATE v_sql;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END normalize_table;
/