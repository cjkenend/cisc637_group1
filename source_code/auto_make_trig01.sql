-- Goal is to automake the trigger 01s for the whole database

                -- Starting the begin
BEGIN

                -- Need a for loop of the database for every table
    FOR rec IN (
        SELECT table_name
        FROM user_tables
        WHERE EXISTS (
            SELECT 1 FROM user_tab_columns
            WHERE table_name = user_tables.table_name
              AND column_name = user_tables.table_name || '_UPDT_ID'
        )
    ) LOOP
        DECLARE
                    -- Declaring variables to be used
            v_trigger_name VARCHAR2(100);
            v_sql CLOB;
            has_crtd_id BOOLEAN := FALSE;
            has_crtd_dt BOOLEAN := FALSE;
            has_updt_id BOOLEAN := FALSE;
            has_updt_dt BOOLEAN := FALSE;
        BEGIN
                    -- Making the first line 
            v_trigger_name := 'trg01_' || LOWER(rec.table_name);

                    -- Check if the columns are needed 
            SELECT MAX(CASE WHEN column_name = rec.table_name || '_CRTD_ID' THEN 1 ELSE 0 END),
                   MAX(CASE WHEN column_name = rec.table_name || '_CRTD_DT' THEN 1 ELSE 0 END),
                   MAX(CASE WHEN column_name = rec.table_name || '_UPDT_ID' THEN 1 ELSE 0 END),
                   MAX(CASE WHEN column_name = rec.table_name || '_UPDT_DT' THEN 1 ELSE 0 END)
              INTO has_crtd_id, has_crtd_dt, has_updt_id, has_updt_dt
              FROM user_tab_columns
             WHERE table_name = rec.table_name;

                    -- Check if there is a trigger already and drop it
            BEGIN
                EXECUTE IMMEDIATE 'DROP TRIGGER ' || v_trigger_name;
            EXCEPTION
                WHEN OTHERS THEN NULL;
            END;

                    -- Building the statement
            v_sql := '
CREATE OR REPLACE TRIGGER ' || v_trigger_name || '
BEFORE INSERT OR UPDATE ON ' || rec.table_name || '
FOR EACH ROW
BEGIN
';

                    -- Making the insert fields
            IF has_crtd_id OR has_crtd_dt THEN
                v_sql := v_sql || '
                IF inserting THEN';
                IF has_crtd_id THEN
                    v_sql := v_sql || '
                    :NEW.' || rec.table_name || '_CRTD_ID := USER;';
                END IF;
                
                IF has_crtd_dt THEN
                    v_sql := v_sql || '
                    :NEW.' || rec.table_name || '_CRTD_DT := SYSDATE;';
                END IF;
                
                v_sql := v_sql || '
                END IF;';
            END IF;

                    -- Making it so that updt is always set
            IF has_updt_id THEN
                v_sql := v_sql || '
                :NEW.' || rec.table_name || '_UPDT_ID := USER;' || CHR(10);
            END IF;
            IF has_updt_dt THEN
                v_sql := v_sql || '
                :NEW.' || rec.table_name || '_UPDT_DT := SYSDATE;' || CHR(10);
            END IF;

            v_sql := v_sql || '
            END;';

                    -- Executing the statement
            EXECUTE IMMEDIATE v_sql;

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Failed on table ' || rec.table_name || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/
