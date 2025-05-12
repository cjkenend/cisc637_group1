Whenever oserror exit 9;
Whenever sqlerror exit sql.sqlcode;

set appinfo on
select 'Begin Executing ' || sys_context('USERENV', 'MODULE') MSG  from dual;


CREATE OR REPLACE PROCEDURE Zap_objects(
    object_type_in IN VARCHAR2)
AS
TYPE t_tab
IS
  TABLE OF user_tables%ROWTYPE;
  objects_tab t_tab := t_tab();
TYPE seq_tab
IS
  TABLE OF user_sequences%ROWTYPE;
  objects_seq seq_tab := seq_tab();
TYPE trg_tab
IS
  TABLE OF user_triggers%ROWTYPE;
  objects_trg trg_tab := trg_tab();
TYPE view_tab
IS
  TABLE OF user_views%ROWTYPE;
  objects_view view_tab := view_tab();
TYPE object_tab
IS
  TABLE OF all_objects%ROWTYPE;
  objects_obj object_tab := object_tab();
  v_sql VARCHAR2(2000);
  v_cnt NUMBER(9);
BEGIN
  IF object_type_in = 'TABLE' THEN
    SELECT COUNT(*) INTO v_cnt FROM user_tables;
    IF v_cnt > 0 THEN
      SELECT * BULK COLLECT INTO objects_tab FROM user_tables;
      FOR i IN objects_tab.first .. objects_tab.last
      LOOP
        v_sql := 'Drop table ' || '"' || objects_tab(i).table_name || '"' ||  ' cascade constraints';
        EXECUTE immediate v_sql;
      END LOOP;
    END IF;
    RETURN;
  END IF;
  IF object_type_in = 'TRIGGER' THEN
    SELECT COUNT(*) INTO v_cnt FROM user_triggers;
    IF v_cnt > 0 THEN
      SELECT * BULK COLLECT INTO objects_trg FROM user_triggers;
      FOR i IN objects_trg.first .. objects_trg.last
      LOOP
        v_sql := 'Drop trigger ' || objects_trg(i).trigger_name ;
        EXECUTE immediate v_sql;
      END LOOP;
    END IF;
    RETURN;
  END IF;
  IF object_type_in = 'SEQUENCE' THEN
    SELECT COUNT(*) INTO v_cnt FROM user_sequences;
    IF v_cnt > 0 THEN
      SELECT * BULK COLLECT INTO objects_seq FROM user_sequences;
      FOR i IN objects_seq.first .. objects_seq.last
      LOOP
        v_sql := 'Drop sequence ' || objects_seq(i).sequence_name ;
        EXECUTE immediate v_sql;
      END LOOP;
    END IF;
    RETURN;
  END IF;
  IF object_type_in = 'VIEW' THEN
    SELECT COUNT(*) INTO v_cnt FROM user_views;
    IF v_cnt > 0 THEN
      SELECT * BULK COLLECT INTO objects_view FROM user_views;
      FOR i IN objects_view.first .. objects_view.last
      LOOP
        v_sql := 'Drop view ' || objects_view(i).view_name ;
        EXECUTE immediate v_sql;
      END LOOP;
    END IF;
    RETURN;
  END IF;
  --
  SELECT COUNT(*)
  INTO v_cnt
  FROM ALL_OBJECTS
  WHERE upper(OBJECT_TYPE) = upper(OBJECT_TYPE_IN)
  AND owner                = USER;
  DBMS_OUTPUT.PUT_LINE('COUNT: ' || V_CNT);
  IF v_cnt > 0 THEN
    SELECT * BULK COLLECT
    INTO objects_obj
    FROM ALL_OBJECTS
    WHERE upper(OBJECT_TYPE) = upper(OBJECT_TYPE_IN)
    AND owner                = USER;
    FOR i IN objects_obj.first .. objects_obj.last
    LOOP
      IF objects_obj(i).object_name != 'ZAP_OBJECTS' THEN
        v_sql                       := 'Drop ' || OBJECT_TYPE_IN || ' ' || objects_obj(i).object_name ;
        EXECUTE immediate v_sql;
      END IF;
    END LOOP;
  END IF;
END;
/
BEGIN
  Zap_objects('VIEW');
  Zap_objects('TRIGGER');
  Zap_objects('TABLE');
  Zap_objects('SEQUENCE');
  Zap_objects('PROCEDURE');
  Zap_objects('FUNCTION');
  Zap_objects('PACKAGE');
END;
/
DROP PROCEDURE Zap_objects;

PURGE RECYCLEBIN;
/

select 'End Executing ' || sys_context('USERENV', 'MODULE') MSG  from dual;
/










------------------------   Contact Tables ---------------------------------------

-- Making contact_type id
    -- Use: Hold all of the different names for the departments
CREATE TABLE contact_type (
    contact_type_id      VARCHAR2(38) NOT NULL,          --Right value for varchar?
    contact_type_desc    VARCHAR(50) NOT NULL,
    contact_type_crtd_id VARCHAR2(40) NOT NULL,
    contact_type_crtd_dt DATE NOT NULL,
    contact_type_updt_id VARCHAR2(40) NOT NULL,
    contact_type_updt_dt DATE NOT NULL,
    CONSTRAINT contact_type_pk PRIMARY KEY ( contact_type_id ) ENABLE
);

--- Making Contact table
    -- Use: Hold all of the information neeed for each department (onr, dcaa, etc.)
CREATE TABLE contact (
    contact_id              VARCHAR2(38) NOT NULL,          -- Make sure not missing and columns????
    contact_contact_type_id            VARCHAR2(38) NOT NULL,
    contact_crtd_id         VARCHAR2(40) NOT NULL,
    contact_crtd_dt         DATE NOT NULL,
    contact_updt_id         VARCHAR2(40) NOT NULL,
    contact_updt_dt         DATE NOT NULL,
    CONSTRAINT contact_pk PRIMARY KEY ( contact_id ) ENABLE
);

ALTER TABLE contact
    ADD CONSTRAINT contact_fk1
        FOREIGN KEY ( contact_contact_type_id )
            REFERENCES contact_type ( contact_type_id )
        ENABLE;



------------------------   Address Tables ---------------------------------------


-- Making the Address_type table 
    -- Use: Hold all of the different types of address 
CREATE TABLE address_type (
    address_type_id      VARCHAR2(38) NOT NULL,
    address_type_desc    VARCHAR2(255) NOT NULL,
    address_type_crtd_id VARCHAR2(40) NOT NULL,
    address_type_crtd_dt DATE NOT NULL,
    address_type_updt_id VARCHAR2(40) NOT NULL,
    address_type_updt_dt DATE NOT NULL,
    CONSTRAINT address_table_pk PRIMARY KEY ( address_type_id ) ENABLE
);

-- Making the Address table 
    -- Use: Hold all of the addresses
CREATE TABLE address (
    address_id              VARCHAR2(38) NOT NULL,
    address_value           VARCHAR2(50) NOT NULL,
    address_city            VARCHAR2(50) NOT NULL,
    address_state           VARCHAR2(2) NOT NULL,
    address_zip             VARCHAR2(10) NOT NULL,
    address_region          VARCHAR(50),
    address_address_type_id VARCHAR2(38) NOT NULL,
    address_crtd_id         VARCHAR2(40) NOT NULL,
    address_crtd_dt         DATE NOT NULL,
    address_updt_id         VARCHAR2(40) NOT NULL,
    address_updt_dt         DATE NOT NULL,
    CONSTRAINT address_pk PRIMARY KEY ( address_id ) ENABLE
);

ALTER TABLE address
    ADD CONSTRAINT address_fk1
        FOREIGN KEY ( address_address_type_id )
            REFERENCES address_type ( address_type_id )
        ENABLE;






------------------------   Phone Tables ---------------------------------------
        

-- Making the Phone_type table 
    -- Use: Hold all of the different types of phones (fax, landline, work, personal, etc)
CREATE TABLE phone_type (
    phone_type_id      VARCHAR2(38) NOT NULL,
    phone_type_desc    VARCHAR2(50) NOT NULL,
    phone_type_crtd_id VARCHAR2(40) NOT NULL,
    phone_type_crtd_dt DATE NOT NULL,
    phone_type_updt_id VARCHAR2(40) NOT NULL,
    phone_type_updt_dt DATE NOT NULL,
    CONSTRAINT phone_type_pk PRIMARY KEY ( phone_type_id ) ENABLE
);


-- Making the Phone table 
    -- Use: Hold all of the different phones 
CREATE TABLE phone (
    phone_id            VARCHAR2(38) NOT NULL,
    phone_number        VARCHAR2(20) NOT NULL,          -- Longest Phone varchar was 20?
    phone_phone_type_id VARCHAR2(38) NOT NULL,          -- Do we need the code column here??
    phone_crtd_id       VARCHAR2(40) NOT NULL,
    phone_crtd_dt       DATE NOT NULL,
    phone_updt_id       VARCHAR2(40) NOT NULL,
    phone_updt_dt       DATE NOT NULL,
    CONSTRAINT phone_pk PRIMARY KEY ( phone_id ) ENABLE
);

ALTER TABLE phone
    ADD CONSTRAINT phone_fk1
        FOREIGN KEY ( phone_phone_type_id )
            REFERENCES phone_type ( phone_type_id )
        ENABLE;


   
   
   
        
------------------------   Email Tables ---------------------------------------
        
-- Making the Email_type table
    -- Use: Hold all the different email types
CREATE TABLE email_type (
    email_type_id      VARCHAR2(38) NOT NULL,
    email_type_desc    VARCHAR2(50) NOT NULL,       -- 50 is place holder. Personal/work???
    email_type_crtd_id VARCHAR2(40) NOT NULL,
    email_type_crtd_dt DATE NOT NULL,
    email_type_updt_id VARCHAR2(40) NOT NULL,
    email_type_updt_dt DATE NOT NULL,
    CONSTRAINT email_type_pk PRIMARY KEY ( email_type_id ) ENABLE
);


-- Making the Email table 
    -- Use: Hold all of the emails addresses
CREATE TABLE email (
    email_id            VARCHAR2(38) NOT NULL,
    email_name          VARCHAR2(20) NOT NULL,
    email_email_type_id VARCHAR2(38) NOT NULL,
    email_crtd_id       VARCHAR2(40) NOT NULL,
    email_crtd_dt       DATE NOT NULL,
    email_updt_id       VARCHAR2(40) NOT NULL,
    email_updt_dt       DATE NOT NULL,
    CONSTRAINT email_pk PRIMARY KEY ( email_id ) ENABLE
);

ALTER TABLE email
    ADD CONSTRAINT email_fk1
        FOREIGN KEY ( email_email_type_id )
            REFERENCES email_type ( email_type_id )
        ENABLE;


------------------------   office Tables ---------------------------------------
        
-- Making the office_type table
    -- Use: Hold all the different office types
CREATE TABLE office_type (
    office_type_id      VARCHAR2(38) NOT NULL,
    office_type_desc    VARCHAR2(50) NOT NULL,       -- 50 is place holder. Personal/work???
    office_type_crtd_id VARCHAR2(40) NOT NULL,
    office_type_crtd_dt DATE NOT NULL,
    office_type_updt_id VARCHAR2(40) NOT NULL,
    office_type_updt_dt DATE NOT NULL,
    CONSTRAINT office_type_pk PRIMARY KEY ( office_type_id ) ENABLE
);


-- Making the office table 
    -- Use: Hold all of the offices addresses
CREATE TABLE office (
    office_id            VARCHAR2(38) NOT NULL,
    office_name          VARCHAR2(20) NOT NULL,
    office_office_type_id VARCHAR2(38) NOT NULL,
    office_crtd_id       VARCHAR2(40) NOT NULL,
    office_crtd_dt       DATE NOT NULL,
    office_updt_id       VARCHAR2(40) NOT NULL,
    office_updt_dt       DATE NOT NULL,
    CONSTRAINT office_pk PRIMARY KEY ( office_id ) ENABLE
);

ALTER TABLE office
    ADD CONSTRAINT office_fk1
        FOREIGN KEY ( office_office_type_id )
            REFERENCES office_type ( office_type_id )
        ENABLE;
        
        
        
        
        
        
------------------------   Many to Many Tables ---------------------------------------


-- Making Contact_Address table
    -- Use: In between for the two tables 
CREATE TABLE contact_address (
    contact_address_id         VARCHAR2(38) NOT NULL,
    contact_address_contact_id VARCHAR2(38) NOT NULL,
    contact_address_address_id VARCHAR2(38) NOT NULL,
    contact_address_crtd_id    VARCHAR2(40) NOT NULL,
    contact_address_crtd_dt    DATE NOT NULL,
    contact_address_updt_id    VARCHAR2(40) NOT NULL,
    contact_address_updt_dt    DATE NOT NULL,
    CONSTRAINT contact_address_pk PRIMARY KEY ( contact_address_id ) ENABLE
);

ALTER TABLE contact_address
    ADD CONSTRAINT contact_address_fk1
        FOREIGN KEY ( contact_address_contact_id )
            REFERENCES contact ( contact_id )
        ENABLE;

ALTER TABLE contact_address
    ADD CONSTRAINT contact_address_fk2
        FOREIGN KEY ( contact_address_address_id )
            REFERENCES address ( address_id )
        ENABLE;
        



-- Making Contact_Phone table
    -- Use: In between for the two tables 
CREATE TABLE contact_phone (
    contact_phone_id         VARCHAR2(38) NOT NULL,
    contact_phone_contact_id VARCHAR2(38) NOT NULL,
    contact_phone_phone_id   VARCHAR2(38) NOT NULL,
    contact_phone_crtd_id    VARCHAR2(40) NOT NULL,
    contact_phone_crtd_dt    DATE NOT NULL,
    contact_phone_updt_id    VARCHAR2(40) NOT NULL,
    contact_phone_updt_dt    DATE NOT NULL,
    CONSTRAINT contact_phone_pk PRIMARY KEY ( contact_phone_id ) ENABLE
);

ALTER TABLE contact_phone
    ADD CONSTRAINT contact_phone_fk1
        FOREIGN KEY ( contact_phone_contact_id )
            REFERENCES contact ( contact_id )
        ENABLE;

ALTER TABLE contact_phone
    ADD CONSTRAINT contact_phone_fk2
        FOREIGN KEY ( contact_phone_phone_id )
            REFERENCES phone ( phone_id )
        ENABLE;
        
        
        

-- Making Contact_Email table
    -- Use: In between for the two tables 
CREATE TABLE contact_email (
    contact_email_id         VARCHAR2(38) NOT NULL,
    contact_email_contact_id VARCHAR2(38) NOT NULL,
    contact_email_email_id   VARCHAR2(38) NOT NULL,
    contact_email_crtd_id    VARCHAR2(40) NOT NULL,
    contact_email_crtd_dt    DATE NOT NULL,
    contact_email_updt_id    VARCHAR2(40) NOT NULL,
    contact_email_updt_dt    DATE NOT NULL,
    CONSTRAINT contact_email_pk PRIMARY KEY ( contact_email_id ) ENABLE
);

ALTER TABLE contact_email
    ADD CONSTRAINT contact_email_fk1
        FOREIGN KEY ( contact_email_contact_id )
            REFERENCES contact ( contact_id )
        ENABLE;

ALTER TABLE contact_email
    ADD CONSTRAINT contact_email_fk2
        FOREIGN KEY ( contact_email_email_id )
            REFERENCES email ( email_id )
        ENABLE;

-- Making Contact_office table
    -- Use: In between for the two tables 
CREATE TABLE contact_office (
    contact_office_id         VARCHAR2(38) NOT NULL,
    contact_office_contact_id VARCHAR2(38) NOT NULL,
    contact_office_office_id VARCHAR2(38) NOT NULL,
    contact_office_crtd_id    VARCHAR2(40) NOT NULL,
    contact_office_crtd_dt    DATE NOT NULL,
    contact_office_updt_id    VARCHAR2(40) NOT NULL,
    contact_office_updt_dt    DATE NOT NULL,
    CONSTRAINT contact_office_pk PRIMARY KEY ( contact_office_id ) ENABLE
);

ALTER TABLE contact_office
    ADD CONSTRAINT contact_office_fk1
        FOREIGN KEY ( contact_office_contact_id )
            REFERENCES contact ( contact_id )
        ENABLE;

ALTER TABLE contact_office
    ADD CONSTRAINT contact_office_fk2
        FOREIGN KEY ( contact_office_office_id )
            REFERENCES office ( office_id )
        ENABLE;








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


ALTER TRIGGER trg01_address DISABLE;

ALTER TRIGGER trg01_phone DISABLE;

ALTER TRIGGER trg01_email DISABLE;







-- Goal is to make a function that is called gets an address from the table 

/* 
    Call the function with all of the variables for an insert on the table
    along with the source_table, dest_table, 
    and in this case address_num
*/

CREATE OR REPLACE FUNCTION ud_cisc637_group1_target.insert_or_get_address(
    in_dest_table_name          IN VARCHAR2,

    in_address_region           IN VARCHAR2,
    in_address_value            IN VARCHAR2,
    in_address_city             IN VARCHAR2,
    in_address_state            IN VARCHAR2,
    in_address_zip              IN VARCHAR2,

    in_address_address_type_id  IN VARCHAR2,

    in_address_crtd_id          IN VARCHAR2,
    in_address_crtd_dt          IN DATE,
    
    in_address_updt_id          IN VARCHAR2,
    in_address_updt_dt          IN DATE
) RETURN VARCHAR2
IS
    v_sql           VARCHAR2(1000);
    out_address_id    VARCHAR2(38);

BEGIN

    --Set up check for address
    v_sql := '
        SELECT address_id 
        FROM ' || in_dest_table_name || '
        WHERE address_value = :address_value
        AND address_region = :address_region
        AND address_city = :address_city
        AND address_state = :address_state
        AND address_zip = :address_zip';

    --Now go through the execution process
    BEGIN
    
        --Execute
        EXECUTE IMMEDIATE v_sql
        INTO out_address_id
        USING in_address_value, in_address_region, in_address_city, in_address_state, in_address_zip;

        --Return 
        RETURN out_address_id;
    
    --Set an exception if data isn't found
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            
            --Handle the insert now 
            v_sql := '
                INSERT INTO ud_cisc637_group1_target.' || in_dest_table_name || '(
                    address_value, address_region, address_city, address_state, address_zip, 
                    address_address_type_id,
                    address_crtd_id, address_crtd_dt,
                    address_updt_id, address_updt_dt
                )
                VALUES (
                    :address_value, :address_region, :address_city, :address_state, :address_zip, 
                    :address_address_type_id,
                    :address_crtd_id, :address_crtd_dt,
                    :address_updt_id, :address_updt_dt
                )
                RETURNING address_id INTO :v_address_id';
            
            --Execute 
            EXECUTE IMMEDIATE v_sql
            USING in_address_value, in_address_region, in_address_city, in_address_state, in_address_zip,
                in_address_address_type_id,
                in_address_crtd_id, in_address_crtd_dt,
                in_address_updt_id, in_address_updt_dt,
                OUT out_address_id;

            --Return 
            RETURN out_address_id;
        
    END;
    
    --Raise if nothing is found or inserted
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;

            --Return null
            RETURN(NULL);
END;
/


-- Goal is to make a function that is called gets an email from the table 

/* 
    Call the function with all of the variables for an insert on the table
    along with the source_table, dest_table, 
    and in this case email_num
*/

CREATE OR REPLACE FUNCTION ud_cisc637_group1_target.insert_or_get_email(
    in_dest_table_name          IN VARCHAR2,

    in_email_name               IN VARCHAR2,

    in_email_email_type_id      IN VARCHAR2,

    in_email_crtd_id            IN VARCHAR2,
    in_email_crtd_dt            IN DATE,
    
    in_email_updt_id            IN VARCHAR2,
    in_email_updt_dt            IN DATE
) RETURN VARCHAR2
IS
    v_sql         VARCHAR2(1000);
    out_email_id    VARCHAR2(38);

BEGIN

    --Set up check for email
    v_sql := '
        SELECT email_id 
        FROM ' || in_dest_table_name || '
        WHERE email_name = :email_name';

    --Now go through the execution process
    BEGIN
    
        --Execute
        EXECUTE IMMEDIATE v_sql
        INTO out_email_id
        USING in_email_name;

        -- Return 
        RETURN out_email_id;
    
    --Set an exception if data isn't found
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            
            --Handle the insert now 
            v_sql := '
                INSERT INTO ud_cisc637_group1_target.' || in_dest_table_name || '(
                    email_name, 
                    email_email_type_id,
                    email_crtd_id, email_crtd_dt,
                    email_updt_id, email_updt_dt
                )
                VALUES (
                    :email_name, :email_email_type_id,
                    :email_crtd_id, :email_crtd_dt,
                    :email_updt_id, :email_updt_dt
                )
                RETURNING email_id INTO :new_email_id';
            
            --Execute 
            EXECUTE IMMEDIATE v_sql
            USING
                in_email_name,
                in_email_email_type_id,
                in_email_crtd_id, in_email_crtd_dt,
                in_email_updt_id, in_email_updt_dt,
                OUT out_email_id;

            --Return
            RETURN out_email_id;
        
    END;
    
    --Raise if nothing is found or inserted
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;

            --Return null
            RETURN(NULL);
END;
/









-- Goal is to make a function that is called gets an office from the table 

/* 
    Call the function with all of the variables for an insert on the table
    along with the source_table, dest_table, 
    and in this case office_num
*/

CREATE OR REPLACE FUNCTION ud_cisc637_group1_target.insert_or_get_office(
    in_dest_table_name          IN VARCHAR2,

    in_office_name              IN VARCHAR2,

    in_office_office_type_id    IN VARCHAR2,

    in_office_crtd_id            IN VARCHAR2,
    in_office_crtd_dt            IN DATE,
    
    in_office_updt_id            IN VARCHAR2,
    in_office_updt_dt            IN DATE
)
RETURN VARCHAR2
IS
    v_sql               VARCHAR2(1000);
    out_office_id    VARCHAR2(38);

BEGIN

    --Set up check for office
    v_sql := '
        SELECT office_id 
        FROM ' || in_dest_table_name || '
        WHERE office_name = :office_name';

    --Now go through the execution process
    BEGIN
    
        --Execute
        EXECUTE IMMEDIATE v_sql
        INTO out_office_id
        USING in_office_name;

        -- Return 
        RETURN out_office_id;
    
    --Set an exception if data isn't found
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            
            --Handle the insert now 
            v_sql := '
                INSERT INTO ud_cisc637_group1_target.' || in_dest_table_name || '(
                    office_name, 
                    office_office_type_id,
                    office_crtd_id, office_crtd_dt,
                    office_updt_id, office_updt_dt
                )
                VALUES (
                    :office_name, 
                    :office_office_type_id,
                    :office_crtd_id, :office_crtd_dt,
                    :office_updt_id, :office_updt_dt
                )
                RETURNING office_id INTO :new_office_id';
            
            --Execute 
            EXECUTE IMMEDIATE v_sql
            USING in_office_name,
                in_office_office_type_id,
                in_office_crtd_id, in_office_crtd_dt,
                in_office_updt_id, in_office_updt_dt,
                OUT out_office_id;

            --Return
            RETURN out_office_id;
        
    END;
    
    --Raise if nothing is found or inserted
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;

            --Return null
            RETURN(NULL);
END;
/


-- Goal is to make a function that is called gets an phone from the table 

/* 
    Call the function with all of the variables for an insert on the table
    along with the source_table, dest_table, 
    and in this case phone_num
*/

CREATE OR REPLACE FUNCTION ud_cisc637_group1_target.insert_or_get_phone(
    in_dest_table_name          IN VARCHAR2,

    in_phone_number             IN VARCHAR2,

    in_phone_phone_type_id      IN VARCHAR2,

    in_phone_crtd_id            IN VARCHAR2,
    in_phone_crtd_dt            IN DATE,
    
    in_phone_updt_id            IN VARCHAR2,
    in_phone_updt_dt            IN DATE
)
RETURN VARCHAR2
IS
    v_sql           VARCHAR2(1000);
    out_phone_id    VARCHAR2(38);

BEGIN

    --Set up check for phone
    v_sql := '
        SELECT phone_id 
        FROM ' || in_dest_table_name || '
        WHERE phone_number = :phone_number';

    --Now go through the execution process
    BEGIN
    
        --Execute
        EXECUTE IMMEDIATE v_sql
        INTO out_phone_id
        USING in_phone_number;

        -- Return 
        RETURN out_phone_id;
    
    --Set an exception if data isn't found
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            
            --Handle the insert now 
            v_sql := '
                INSERT INTO ud_cisc637_group1_target.' || in_dest_table_name || '(
                    phone_number, 
                    phone_phone_type_id,
                    phone_crtd_id, phone_crtd_dt,
                    phone_updt_id, phone_updt_dt
                )
                VALUES (
                    :phone_number, 
                    :phone_phone_type_id,
                    :phone_crtd_id, :phone_crtd_dt,
                    :phone_updt_id, :phone_updt_dt
                )
                RETURNING phone_id INTO :new_phone_id';
            
            --Execute 
            EXECUTE IMMEDIATE v_sql
            USING in_phone_number,
                in_phone_phone_type_id,
                in_phone_crtd_id, in_phone_crtd_dt,
                in_phone_updt_id, in_phone_updt_dt,
                OUT out_phone_id;
        
            --Return
            RETURN out_phone_id;
        
    END;
    
    --Raise if nothing is found or inserted
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;

            --Return null
            RETURN(NULL);
END;
/


-----------------------------INSERT TYPES INTO TABLES--------------------------
BEGIN
-------------------- ADDRESS_TYPE
INSERT INTO ADDRESS_TYPE (ADDRESS_TYPE_DESC) VALUES ('Mailing');
INSERT INTO ADDRESS_TYPE (ADDRESS_TYPE_DESC) VALUES ('Home');
INSERT INTO ADDRESS_TYPE (ADDRESS_TYPE_DESC) VALUES ('Work');

-------------------- CONTACT_TYPE
INSERT INTO CONTACT_TYPE (CONTACT_TYPE_DESC) VALUES ('ONR');
INSERT INTO CONTACT_TYPE (CONTACT_TYPE_DESC) VALUES ('DCAA');
INSERT INTO CONTACT_TYPE (CONTACT_TYPE_DESC) VALUES ('DFAS');

-- ------------------EMAIL_TYPE
INSERT INTO EMAIL_TYPE (EMAIL_TYPE_DESC) VALUES ('Work');
INSERT INTO EMAIL_TYPE (EMAIL_TYPE_DESC) VALUES ('Personal');

-- ------------------PHONE_TYPE
INSERT INTO PHONE_TYPE (PHONE_TYPE_DESC) VALUES ('Work');
INSERT INTO PHONE_TYPE (PHONE_TYPE_DESC) VALUES ('Personal');
INSERT INTO PHONE_TYPE (PHONE_TYPE_DESC) VALUES ('Fax');

------------------- OFFICE_TYPE
INSERT INTO OFFICE_TYPE (OFFICE_TYPE_DESC) VALUES ('HQ');
END;
/
-----------------------------------------------------------------------------
-------------------------PROCEDURES TO INPUT DATA----------------------------

CREATE OR REPLACE PROCEDURE MIGRATE_DCAA AS
    -- Cursor to read all rows from the DCAA table
    CURSOR c_cursor IS 
        SELECT * FROM UD_CISC637_GROUP1.TBL_DCAA;

    -- Variables that will retrieve the output from the procedures
    v_contact_id            UD_CISC637_GROUP1_TARGET.contact.contact_id%TYPE;
    v_office_id             UD_CISC637_GROUP1_TARGET.office.office_id%TYPE;
    v_address1_id           UD_CISC637_GROUP1_TARGET.address.address_id%TYPE;
    v_address2_id           UD_CISC637_GROUP1_TARGET.address.address_id%TYPE;
    v_address3_id           UD_CISC637_GROUP1_TARGET.address.address_id%TYPE;
    v_phone_id              UD_CISC637_GROUP1_TARGET.phone.phone_id%TYPE;

    -- Variables to hold each field from the cursor row  
    v_office    UD_CISC637_GROUP1.TBL_DCAA.office%TYPE;
    v_address1  UD_CISC637_GROUP1.TBL_DCAA.address1%TYPE;
    v_address2  UD_CISC637_GROUP1.TBL_DCAA.address2%TYPE;
    v_address3  UD_CISC637_GROUP1.TBL_DCAA.address3%TYPE;
    v_city      UD_CISC637_GROUP1.TBL_DCAA.city%TYPE;
    v_state     UD_CISC637_GROUP1.TBL_DCAA.state%TYPE;
    v_zipcode   UD_CISC637_GROUP1.TBL_DCAA.zipcode%TYPE;
    v_phone     UD_CISC637_GROUP1.TBL_DCAA.phone%TYPE;
    v_mdf_date  UD_CISC637_GROUP1.TBL_DCAA.modifydate%TYPE;
    v_mdf_user  UD_CISC637_GROUP1.TBL_DCAA.modifyuser%TYPE;
    v_crt_date  UD_CISC637_GROUP1.TBL_DCAA.createdate%TYPE;
    v_crt_user  UD_CISC637_GROUP1.TBL_DCAA.createuser%TYPE;

    -- Retrieved type IDs 
    v_contact_type_id       UD_CISC637_GROUP1_TARGET.contact_type.contact_type_id%TYPE;
    v_office_type_id_hq     UD_CISC637_GROUP1_TARGET.office_type.office_type_id%TYPE;
    v_address_type_id_home  UD_CISC637_GROUP1_TARGET.address_type.address_type_id%TYPE;
    v_phone_type_id_per     UD_CISC637_GROUP1_TARGET.phone_type.phone_type_id%TYPE;

-- Get needed type_ids
    -- Presumes existence of 
    --      office_type_desc: HQ
    --      address_type_desc: Home
    --      phone_type_desc: Fax, Personal
    --      email_type_desc: Work    

BEGIN
    SELECT OFFICE_TYPE_ID INTO v_office_type_id_hq FROM UD_CISC637_GROUP1_TARGET.office_type WHERE OFFICE_TYPE_DESC = 'HQ';
    SELECT ADDRESS_TYPE_ID INTO v_address_type_id_home FROM UD_CISC637_GROUP1_TARGET.address_type WHERE ADDRESS_TYPE_DESC = 'Home';
    SELECT PHONE_TYPE_ID INTO v_phone_type_id_per FROM UD_CISC637_GROUP1_TARGET.phone_type WHERE PHONE_TYPE_DESC = 'Personal';
    SELECT CONTACT_TYPE_ID INTO v_contact_type_id FROM UD_CISC637_GROUP1_TARGET.contact_type WHERE CONTACT_TYPE_DESC = 'DCAA';

    --Put values into variables
    FOR dc IN c_cursor LOOP
        v_office   := dc.office;
        v_address1 := dc.address1;
        v_address2 := dc.address2;
        v_address3 := dc.address3;
        v_city     := dc.city;
        v_state    := dc.state;
        v_zipcode  := dc.zipcode;
        v_phone    := dc.phone;
        v_mdf_date := dc.modifydate;
        v_mdf_user := dc.modifyuser;
        v_crt_date := dc.createdate;
        v_crt_user := dc.createuser;

        -- Creates a new contact with CONTACT_TYPE_ID for ONR and returns the
        -- CONTACT_ID that is generated by the trg01
        INSERT INTO ud_cisc637_group1_target.contact (contact_contact_type_id)
        VALUES(v_contact_type_id) RETURNING contact_id INTO v_contact_id;
        COMMIT;

        -- Office Handling 
        IF dc.office IS NOT NULL THEN
            v_office_id := insert_or_get_office(
                in_dest_table_name     => 'OFFICE',
                in_office_name         => v_office,
                in_office_office_type_id => v_office_type_id_hq,
                in_office_crtd_id      => v_crt_user,
                in_office_crtd_dt      => v_crt_date,
                in_office_updt_id      => v_mdf_user,
                in_office_updt_dt      => v_mdf_date
            );
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_office
            (contact_office_contact_id, contact_office_office_id)
            VALUES(v_contact_id, v_office_id);
        END IF;

        -- Address Handling
        -- Address1
        IF dc.address1 IS NOT NULL THEN
            v_address1_id := insert_or_get_address(
                in_dest_table_name => 'ADDRESS',
                in_address_region  => NULL,
                in_address_value   => v_address1,
                in_address_city    => v_city,
                in_address_state   => v_state,
                in_address_zip     => v_zipcode,
                in_address_address_type_id => v_address_type_id_home,
                in_address_crtd_id => v_crt_user,
                in_address_crtd_dt => v_crt_date,
                in_address_updt_id => v_mdf_user,
                in_address_updt_dt => v_mdf_date
            );
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_address
            (contact_address_contact_id, contact_address_address_id)
            VALUES(v_contact_id, v_address1_id);
        END IF;

        -- Address2
        IF dc.address2 IS NOT NULL THEN
            v_address2_id := insert_or_get_address(
                in_dest_table_name => 'ADDRESS',
                in_address_value   => v_address2,
                in_address_region  => NULL,                
                in_address_city    => v_city,
                in_address_state   => v_state,
                in_address_zip     => v_zipcode,
                in_address_address_type_id => v_address_type_id_home,
                in_address_crtd_id => v_crt_user,
                in_address_crtd_dt => v_crt_date,
                in_address_updt_id => v_mdf_user,
                in_address_updt_dt => v_mdf_date
            );
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_address
            (contact_address_contact_id, contact_address_address_id)
            VALUES(v_contact_id, v_address2_id);
        END IF;

        -- Address3
        IF dc.address3 IS NOT NULL THEN
            v_address3_id := insert_or_get_address(
                in_dest_table_name => 'ADDRESS',
                in_address_value   => v_address3,
                in_address_region  => NULL,
                in_address_city    => v_city,
                in_address_state   => v_state,
                in_address_zip     => v_zipcode,
                in_address_address_type_id => v_address_type_id_home,
                in_address_crtd_id => v_crt_user,
                in_address_crtd_dt => v_crt_date,
                in_address_updt_id => v_mdf_user,
                in_address_updt_dt => v_mdf_date
            );
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_address
            (contact_address_contact_id, contact_address_address_id)
            VALUES(v_contact_id, v_address3_id);
        END IF;

        -- Phone Handling
        IF dc.phone IS NOT NULL THEN
            v_phone_id := insert_or_get_phone(
                in_dest_table_name => 'PHONE',
                in_phone_number    => v_phone,
                in_phone_phone_type_id  => v_phone_type_id_per,
                in_phone_crtd_id  => v_crt_user,
                in_phone_crtd_dt  => v_crt_date,
                in_phone_updt_id  => v_mdf_user,
                in_phone_updt_dt  => v_mdf_date
            );
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_phone
            (contact_phone_contact_id, contact_phone_phone_id)
            VALUES(v_contact_id, v_phone_id);
        END IF;

    END LOOP;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END MIGRATE_DCAA;
/

CREATE OR REPLACE PROCEDURE MIGRATE_DFAS AS
    -- Cursor to read all rows from the DFAS table
    CURSOR c_cursor IS 
        SELECT * FROM UD_CISC637_GROUP1.TBL_DFAS;

    -- Variables that will retrieve the output from the procedures
    v_contact_id            UD_CISC637_GROUP1_TARGET.contact.contact_id%TYPE;
    v_office_id             UD_CISC637_GROUP1_TARGET.office.office_id%TYPE;
    v_address1_id           UD_CISC637_GROUP1_TARGET.address.address_id%TYPE;
    v_address2_id           UD_CISC637_GROUP1_TARGET.address.address_id%TYPE;
    v_phone1_id             UD_CISC637_GROUP1_TARGET.phone.phone_id%TYPE;
    v_phone2_id             UD_CISC637_GROUP1_TARGET.phone.phone_id%TYPE;
    v_fax_id                UD_CISC637_GROUP1_TARGET.phone.phone_id%TYPE;

    -- Variables to hold each field from the cursor row  
    v_office    UD_CISC637_GROUP1.TBL_DFAS.office%TYPE;
    v_address1  UD_CISC637_GROUP1.TBL_DFAS.address1%TYPE;
    v_address2  UD_CISC637_GROUP1.TBL_DFAS.address2%TYPE;
    v_city      UD_CISC637_GROUP1.TBL_DFAS.city%TYPE;
    v_state     UD_CISC637_GROUP1.TBL_DFAS.state%TYPE;
    v_zip       UD_CISC637_GROUP1.TBL_DFAS.zip%TYPE;
    v_phone1    UD_CISC637_GROUP1.TBL_DFAS.phone1%TYPE;
    v_phone2    UD_CISC637_GROUP1.TBL_DFAS.phone2%TYPE;
    v_fax       UD_CISC637_GROUP1.TBL_DFAS.fax%TYPE;
    v_mdf_date  UD_CISC637_GROUP1.TBL_DFAS.modifydate%TYPE;
    v_mdf_user  UD_CISC637_GROUP1.TBL_DFAS.modifyuser%TYPE;
    v_crt_date  UD_CISC637_GROUP1.TBL_DFAS.createdate%TYPE;
    v_crt_user  UD_CISC637_GROUP1.TBL_DFAS.createuser%TYPE;

    -- Retrieved type IDs 
    v_contact_type_id       UD_CISC637_GROUP1_TARGET.contact_type.contact_type_id%TYPE;
    v_office_type_id_hq     UD_CISC637_GROUP1_TARGET.office_type.office_type_id%TYPE;
    v_address_type_id_home  UD_CISC637_GROUP1_TARGET.address_type.address_type_id%TYPE;
    v_phone_type_id_per     UD_CISC637_GROUP1_TARGET.phone_type.phone_type_id%TYPE;
    v_phone_type_id_fax     UD_CISC637_GROUP1_TARGET.phone_type.phone_type_id%TYPE;

 -- Get needed type_ids
    -- Presumes existence of 
    --      office_type_desc: HQ
    --      address_type_desc: Home
    --      phone_type_desc: Fax, Personal
    --      email_type_desc: Work    

BEGIN
    SELECT OFFICE_TYPE_ID INTO v_office_type_id_hq FROM UD_CISC637_GROUP1_TARGET.office_type WHERE OFFICE_TYPE_DESC = 'HQ';
    SELECT ADDRESS_TYPE_ID INTO v_address_type_id_home FROM UD_CISC637_GROUP1_TARGET.address_type WHERE ADDRESS_TYPE_DESC = 'Home';
    SELECT PHONE_TYPE_ID INTO v_phone_type_id_per FROM UD_CISC637_GROUP1_TARGET.phone_type WHERE PHONE_TYPE_DESC = 'Personal';
    SELECT PHONE_TYPE_ID INTO v_phone_type_id_fax FROM UD_CISC637_GROUP1_TARGET.phone_type WHERE PHONE_TYPE_DESC = 'Fax';
    SELECT CONTACT_TYPE_ID INTO v_contact_type_id FROM UD_CISC637_GROUP1_TARGET.contact_type WHERE CONTACT_TYPE_DESC = 'DFAS';

    FOR df IN c_cursor LOOP
        v_office   := df.office;
        v_address1 := df.address1;
        v_address2 := df.address2;
        v_city     := df.city;
        v_state    := df.state;
        v_zip      := df.zip;
        v_phone1   := df.phone1;
        v_phone2   := df.phone2;
        v_fax      := df.fax;
        v_mdf_date := df.modifydate;
        v_mdf_user := df.modifyuser;
        v_crt_date := df.createdate;
        v_crt_user := df.createuser;

        -- Creates a new contact with CONTACT_TYPE_ID for DFAS and returns the
        -- CONTACT_ID that is generated by the trg01
        INSERT INTO ud_cisc637_group1_target.contact (contact_contact_type_id)
        VALUES(v_contact_type_id) RETURNING contact_id INTO v_contact_id;
        COMMIT;

        -- Office Handling 
        IF df.office IS NOT NULL THEN
            v_office_id := insert_or_get_office(
                in_dest_table_name     => 'OFFICE',
                in_office_name         => v_office,
                in_office_office_type_id => v_office_type_id_hq,
                in_office_crtd_id      => v_crt_user,
                in_office_crtd_dt      => v_crt_date,
                in_office_updt_id      => v_mdf_user,
                in_office_updt_dt      => v_mdf_date
            );
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_office
            (contact_office_contact_id, contact_office_office_id)
            VALUES(v_contact_id, v_office_id);
        END IF;

        -- Address Handling
        -- Address1
        IF df.address1 IS NOT NULL THEN
            v_address1_id := insert_or_get_address(
                in_dest_table_name => 'ADDRESS',
                in_address_value   => v_address1,
                in_address_region  => NULL,
                in_address_city    => v_city,
                in_address_state   => v_state,
                in_address_zip     => v_zip,
                in_address_address_type_id => v_address_type_id_home,
                in_address_crtd_id => v_crt_user,
                in_address_crtd_dt => v_crt_date,
                in_address_updt_id => v_mdf_user,
                in_address_updt_dt => v_mdf_date
            );
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_address
            (contact_address_contact_id, contact_address_address_id)
            VALUES(v_contact_id, v_address1_id);
        END IF;

        -- Address2
        IF df.address2 IS NOT NULL THEN
            v_address2_id := insert_or_get_address(
                in_dest_table_name => 'ADDRESS',
                in_address_region  => NULL,
                in_address_value   => v_address2,
                in_address_city    => v_city,
                in_address_state   => v_state,
                in_address_zip     => v_zip,
                in_address_address_type_id => v_address_type_id_home,
                in_address_crtd_id => v_crt_user,
                in_address_crtd_dt => v_crt_date,
                in_address_updt_id => v_mdf_user,
                in_address_updt_dt => v_mdf_date
            );
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_address
            (contact_address_contact_id, contact_address_address_id)
            VALUES(v_contact_id, v_address2_id);
        END IF;

        -- Phone Handling 
        -- Phone1
        IF df.phone1 IS NOT NULL THEN
            v_phone1_id := insert_or_get_phone(
                in_dest_table_name => 'PHONE',
                in_phone_number    => v_phone1,
                in_phone_phone_type_id  => v_phone_type_id_per,
                in_phone_crtd_id  => v_crt_user,
                in_phone_crtd_dt  => v_crt_date,
                in_phone_updt_id  => v_mdf_user,
                in_phone_updt_dt  => v_mdf_date
            );
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_phone
            (contact_phone_contact_id, contact_phone_phone_id)
            VALUES(v_contact_id, v_phone1_id);
        END IF;

        -- Phone2
        IF df.phone2 IS NOT NULL THEN
            v_phone2_id := insert_or_get_phone(
                in_dest_table_name => 'PHONE',
                in_phone_number    => v_phone2,
                in_phone_phone_type_id  => v_phone_type_id_per,
                in_phone_crtd_id  => v_crt_user,
                in_phone_crtd_dt  => v_crt_date,
                in_phone_updt_id  => v_mdf_user,
                in_phone_updt_dt  => v_mdf_date
            );
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_phone
            (contact_phone_contact_id, contact_phone_phone_id)
            VALUES(v_contact_id, v_phone2_id);
        END IF;

        -- Fax Handling
        IF df.fax IS NOT NULL THEN
            v_fax_id := insert_or_get_phone(
                in_dest_table_name => 'PHONE',
                in_phone_number    => v_fax,
                in_phone_phone_type_id  => v_phone_type_id_fax,
                in_phone_crtd_id  => v_crt_user,
                in_phone_crtd_dt  => v_crt_date,
                in_phone_updt_id  => v_mdf_user,
                in_phone_updt_dt  => v_mdf_date
            );
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_phone
            (contact_phone_contact_id, contact_phone_phone_id)
            VALUES(v_contact_id, v_fax_id);
        END IF;

    END LOOP;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END MIGRATE_DFAS;
/
---------------------------------------------------
-- Loop over rows in ONR table

       -- Save generated CONTACT_ID into variable v_contact_id

        --OFFICE PART
        --Check if og.office is null
            --Use 'insert_or_get_office' procedure
            --INSERT new record in CONTACT_OFFICE using v_contact_id

        --PHONE PART
        --Check if og.phone is null
            --Use 'insert_or_get_phone' procedure
            --INSERT new record in CONTACT_PHONE using v_contact_id
            --Repeat for fax
        
        --ADDRESS PART
        --Check if og.address1 is null
            --Use 'insert_or_get_address' procedure
            --INSERT new record in CONTACT_ADDRESS using v_contact_id 
            --Repeat for address2
        
        --EMAIL PART
        --Check if og.email is null
            --Use 'insert_or_get_email' procedure
            --INSERT a new record in CONTACT_EMAIL using v_contact_id
      
create or replace PROCEDURE MIGRATE_ONR IS
    
    -- Cursor to read all rows from the ONR table
    CURSOR c_cursor IS 
        SELECT * FROM UD_CISC637_GROUP1.TBL_ONR;

    -- Variables that will retrieve the output from the procedures
    v_contact_id            UD_CISC637_GROUP1_TARGET.contact.contact_id%TYPE;
    v_office_id             UD_CISC637_GROUP1_TARGET.office.office_id%TYPE;
    v_address1_id           UD_CISC637_GROUP1_TARGET.address.address_id%TYPE;
    v_address2_id           UD_CISC637_GROUP1_TARGET.address.address_id%TYPE;
    v_phone_per_id          UD_CISC637_GROUP1_TARGET.phone.phone_id%TYPE;
    v_phone_fax_id          UD_CISC637_GROUP1_TARGET.phone.phone_id%TYPE;
    v_email_id              UD_CISC637_GROUP1_TARGET.email.email_id%TYPE;


    -- Variables to hold each field from the cursor row  
    v_office    UD_CISC637_GROUP1.TBL_ONR.office%TYPE;
    v_region    UD_CISC637_GROUP1.TBL_ONR.region%TYPE;
    v_address1  UD_CISC637_GROUP1.TBL_ONR.address1%TYPE;
    v_address2  UD_CISC637_GROUP1.TBL_ONR.address2%TYPE;
    v_city      UD_CISC637_GROUP1.TBL_ONR.city%TYPE;
    v_state     UD_CISC637_GROUP1.TBL_ONR.state%TYPE;
    v_zipcode   UD_CISC637_GROUP1.TBL_ONR.zipcode%TYPE;
    v_phone     UD_CISC637_GROUP1.TBL_ONR.phone%TYPE;
    v_fax       UD_CISC637_GROUP1.TBL_ONR.fax%TYPE;
    v_code      UD_CISC637_GROUP1.TBL_ONR.code%TYPE;
    v_email     UD_CISC637_GROUP1.TBL_ONR.email%TYPE;
    v_mdf_date  UD_CISC637_GROUP1.TBL_ONR.modifydate%TYPE;
    v_mdf_user  UD_CISC637_GROUP1.TBL_ONR.modifyuser%TYPE;
    v_crt_date  UD_CISC637_GROUP1.TBL_ONR.createdate%TYPE;
    v_crt_user  UD_CISC637_GROUP1.TBL_ONR.createuser%TYPE;

    -- Retrieved type IDs
    v_contact_type_id  UD_CISC637_GROUP1_TARGET.contact_type.contact_type_id%TYPE;
    v_office_type_id_hq   UD_CISC637_GROUP1_TARGET.office_type.office_type_id%TYPE;
    v_address_type_id_home   UD_CISC637_GROUP1_TARGET.address_type.address_type_id%TYPE;
    v_phone_type_id_per UD_CISC637_GROUP1_TARGET.phone_type.phone_type_id%TYPE;
    v_phone_type_id_fax UD_CISC637_GROUP1_TARGET.phone_type.phone_type_id%TYPE;
    v_email_type_id_work  UD_CISC637_GROUP1_TARGET.email_type.email_type_id%TYPE;

    -- Get needed type_ids
    -- Presumes existence of 
    --      office_type_desc: HQ
    --      address_type_desc: Home
    --      phone_type_desc: Fax, Personal
    --      email_type_desc: Work    
    BEGIN
        SELECT OFFICE_TYPE_ID INTO v_office_type_id_hq FROM UD_CISC637_GROUP1_TARGET.office_type WHERE OFFICE_TYPE_DESC = 'HQ';
        SELECT ADDRESS_TYPE_ID INTO v_address_type_id_home FROM UD_CISC637_GROUP1_TARGET.address_type WHERE ADDRESS_TYPE_DESC = 'Home';
        SELECT PHONE_TYPE_ID INTO v_phone_type_id_per FROM UD_CISC637_GROUP1_TARGET.phone_type WHERE PHONE_TYPE_DESC = 'Personal';
        SELECT PHONE_TYPE_ID INTO v_phone_type_id_fax FROM UD_CISC637_GROUP1_TARGET.phone_type WHERE PHONE_TYPE_DESC = 'Fax';
        SELECT EMAIL_TYPE_ID INTO v_email_type_id_work FROM UD_CISC637_GROUP1_TARGET.email_type WHERE EMAIL_TYPE_DESC = 'Work';
        SELECT contact_type_id INTO v_contact_type_id FROM UD_CISC637_GROUP1_TARGET.contact_type WHERE contact_type_desc = 'ONR';

    --Put values into variables
    FOR og IN c_cursor LOOP   
        v_office   := og.office;
        v_region   := og.region;
        v_address1 := og.address1;
        v_address2 := og.address2;
        v_city     := og.city;
        v_state    := og.state;
        v_zipcode  := og.zipcode;
        v_phone    := og.phone;
        v_fax      := og.fax;
        v_code     := og.code;
        v_email    := og.email;
        v_mdf_date := og.modifydate;
        v_mdf_user := og.modifyuser;
        v_crt_date := og.createdate;
        v_crt_user := og.createuser;


        -- Creates a new contact with CONTACT_TYPE_ID for ONR and returns the
        -- CONTACT_ID that is generated by the trg01
        ----------------------------------------------------------
        INSERT INTO ud_cisc637_group1_target.contact (contact_contact_type_id)
        VALUES(v_contact_type_id) RETURNING contact_id INTO v_contact_id;
        COMMIT;
        ----------------------------------------------------------

--Office handling
--------------------------------------------------------

        IF og.office IS NOT NULL THEN

            -- Inserts Office
            v_office_id := insert_or_get_office(
                    in_dest_table_name     => 'OFFICE',
                    in_office_name         => v_office,
                    in_office_office_type_id      => v_office_type_id_hq,
                    in_office_crtd_id      => v_crt_user,
                    in_office_crtd_dt      => v_crt_date,
                    in_office_updt_id      => v_mdf_user,
                    in_office_updt_dt      => v_mdf_date
                );

            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_office
            (contact_office_contact_id, contact_office_office_id)
            VALUES(v_contact_id, v_office_id);
        END IF;

--Address1, region, city, state, zipcode, handling
--------------------------------------------------------

        IF og.address1 IS NOT NULL THEN   
            --Inserts Address1
            v_address1_id := insert_or_get_address(
                in_dest_table_name => 'ADDRESS',
                in_address_region  => v_region,
                in_address_value   => v_address1,
                in_address_city    => v_city,
                in_address_state   => v_state,
                in_address_zip     => v_zipcode,
                in_address_address_type_id => v_address_type_id_home,
                in_address_crtd_id => v_crt_user,
                in_address_crtd_dt => v_crt_date,
                in_address_updt_id => v_mdf_user,
                in_address_updt_dt => v_mdf_date
            );

            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_address
            (contact_address_contact_id, contact_address_address_id)
            VALUES(v_contact_id, v_address1_id);
        END IF;

--Address2, region, city, state, zipcode, handling
--------------------------------------------------------
        IF og.address2 IS NOT NULL THEN
            --Inserts Address2
            v_address2_id := insert_or_get_address(
                in_dest_table_name => 'ADDRESS',
                in_address_value   => v_address2,
                in_address_region => v_region,
                in_address_city    => v_city,
                in_address_state   => v_state,
                in_address_zip     => v_zipcode,
                in_address_address_type_id => v_address_type_id_home,
                in_address_crtd_id => v_crt_user,
                in_address_crtd_dt => v_crt_date,
                in_address_updt_id => v_mdf_user,
                in_address_updt_dt => v_mdf_date
            );


            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_address
            (contact_address_contact_id, contact_address_address_id)
            VALUES(v_contact_id, v_address2_id);
        END IF;

--Phone handling
--------------------------------------------------------

        IF og.phone IS NOT NULL THEN
            --Inserts Phone Number
            v_phone_per_id := insert_or_get_phone(
                in_dest_table_name      => 'PHONE',
                in_phone_number         => v_phone,
                in_phone_phone_type_id        => v_phone_type_id_per,
                in_phone_crtd_id      => v_crt_user,
                in_phone_crtd_dt      => v_crt_date,
                in_phone_updt_id      => v_mdf_user,
                in_phone_updt_dt      => v_mdf_date
            );

            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_phone
            (contact_phone_contact_id, contact_phone_phone_id)
            VALUES(v_contact_id, v_phone_per_id);
        END IF;

--Fax handling
--------------------------------------------------------

        IF og.fax IS NOT NULL THEN
            -- Inserts Fax Number
            v_phone_fax_id := insert_or_get_phone(
                in_dest_table_name    => 'PHONE',
                in_phone_number       => v_fax,
                in_phone_phone_type_id      => v_phone_type_id_fax,
                in_phone_crtd_id      => v_crt_user,
                in_phone_crtd_dt      => v_crt_date,
                in_phone_updt_id      => v_mdf_user,
                in_phone_updt_dt      => v_mdf_date
            );

            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_phone
            (contact_phone_contact_id, contact_phone_phone_id)
            VALUES(v_contact_id, v_phone_fax_id);
        END IF;

--Email handling
--------------------------------------------------------

        IF og.email IS NOT NULL THEN

            -- Inserts Email
            v_email_id := insert_or_get_email(
                in_dest_table_name    => 'EMAIL',
                in_email_name         => v_email,
                in_email_email_type_id      => v_email_type_id_work,
                in_email_crtd_id      => v_crt_user,
                in_email_crtd_dt      => v_crt_date,
                in_email_updt_id      => v_mdf_user,
                in_email_updt_dt      => v_mdf_date
            );

            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_email
            (contact_email_contact_id, contact_email_email_id)
            VALUES(v_contact_id, v_email_id);
        END IF;
    END LOOP;
    COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE VALUE_ERROR;
    END MIGRATE_ONR;
/

BEGIN
    MIGRATE_DFAS();
    MIGRATE_DCAA();
    MIGRATE_ONR();
END;
/

ALTER TRIGGER trg01_address ENABLE;

ALTER TRIGGER trg01_phone ENABLE;

ALTER TRIGGER trg01_email ENABLE;
