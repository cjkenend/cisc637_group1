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
