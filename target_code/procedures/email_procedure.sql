-- Goal is to make a procedure that is called gets an email from the table 

/* 
    Call the procedure with all of the variables for an insert on the table
    along with the source_table, dest_table, 
    and in this case email_num
*/

CREATE OR REPLACE PROCEDURE ud_cisc637_group1_target.insert_or_get_email(
    in_dest_table_name          IN VARCHAR2,

    in_email_name             IN VARCHAR2,

    in_email_type_id            IN VARCHAR2,

    in_email_crtd_id            IN VARCHAR2,
    in_email_crtd_dt            IN VARCHAR2,
    
    in_email_updt_id            IN VARCHAR2,
    in_email_updt_dt            IN VARCHAR2,

    out_email_id                OUT VARCHAR2
)
IS
    v_sql               VARCHAR2(1000);
    v_tmp_email_id    VARCHAR2(38);

BEGIN

    --Set up check for email
    v_sql := '
        SELECT email_id 
        FROM ' || in_dest_table_name || '
        WHERE email_number = :email_number';

    --Now go through the execution process
    BEGIN
    
        --Execute
        EXECUTE IMMEDIATE v_sql
        INTO out_email_id
        USING in_email_name;
    
    --Set an exception if data isn't found
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            
            --Handle the insert now 
            v_sql := '
                INSERT INTO ud_cisc637_group1_target.' || in_dest_table_name || '(
                    email_number, 
                    email_email_type_id,
                    email_crtd_id, email_crtd_dt,
                    email_updt_id, email_updt_dt
                )
                VALUES (
                    :email_number, 
                    :email_email_type_id,
                    :email_crtd_id, :email_crtd_dt,
                    :email_updt_id, :email_updt_dt
                )
                RETURNING email_id INTO :new_email_id';
            
            --Execute 
            EXECUTE IMMEDIATE v_sql
            INTO v_tmp_email_id
            USING in_email_name,
                in_email_type_id,
                in_email_crtd_id, in_email_crtd_dt,
                in_email_updt_id, in_email_updt_dt;
            
            --Setting out variable
            out_email_id := v_tmp_email_id;
        
    END;
    
    --Raise if nothing is found or inserted
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
END;
/
