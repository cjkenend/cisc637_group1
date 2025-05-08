-- Goal is to automake the trigger 02s for all the tables in the database


                    -- Starting the begin statement
BEGIN

                    -- Need to make a loop for all of the tables
    FOR rec IN (
        SELECT table_name,
               column_name
        FROM user_tab_columns
        WHERE column_name = table_name || '_ID'
          AND data_type = 'VARCHAR2'
    ) LOOP
        BEGIN
            DECLARE
                        -- Declaring variables
                v_trigger_name VARCHAR2(100);
                v_sql CLOB;
            BEGIN
                        -- Starting the trigger execution
                v_trigger_name := 'trg02_' || LOWER(rec.table_name);

                        -- Drop trigger if it already exists
                BEGIN
                    EXECUTE IMMEDIATE 'DROP TRIGGER ' || v_trigger_name;
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL; -- ignore if it doesn't exist
                END;

                        -- Building the SQL
                v_sql := '
CREATE OR REPLACE TRIGGER ' || v_trigger_name || '
BEFORE INSERT OR UPDATE ON ' || rec.table_name || '
FOR EACH ROW
    BEGIN
        IF inserting THEN
            :NEW.' || rec.column_name || ' := SYS_GUID();
        ELSIF updating THEN
            :NEW.' || rec.column_name || ' := :OLD.' || rec.column_name || ';
        END IF;
    END;';

                         -- Execute the trigger creation
                EXECUTE IMMEDIATE v_sql;
            END;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Failed for table ' || rec.table_name || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/
