-- Goal is to make a procedure that is called gets an address from the table 

/* 
    Call the procedure with all of the variables for an insert on the table
    along with the source_table, dest_table, dest_col_name, 
    and in this case address_num
*/

CREATE OR REPLACE PROCEDURE ud_cisc637_group1_target.insert_or_get_address(
    IN_EMAIL                 IN VARCHAR2,

    EMAIL_NAME            IN VARCHAR2,
    EMAIL_TYPE_ID         IN VARCHAR2,

    EMAIL_CRTD_ID         IN VARCHAR2,
    EMAIL_CRTD_DT          IN VARCHAR2,
    
    EMAIL_UPDT_ID          IN VARCHAR2,
    EMAIL_UPDT_DT          IN VARCHAR2,

    OUT_EMAIL_ID              OUT VARCHAR2
)
IS
    v_sql               VARCHAR2(1000);
    v_tmp_address_id    VARCHAR2(38);

BEGIN

    --Set up check for address
    v_sql := '
        SELECT address_id 
        FROM ' || IN_EMAIL || '
        WHERE EMAIL_NAME;

    --Now go through the execution process
    BEGIN
    
        --Execute
        EXECUTE IMMEDIATE v_sql
        INTO OUT_EMAIL_ID
        USING IN_EMAIL_NAME;
    
    --Set an exception if data isn't found
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            
            --Handle the insert now 
            v_sql := '
                INSERT INTO ud_cisc637_group1_target.' || IN_EMAIL || '(
                    EMAIL_NAME, 
                    EMAIL_EMAIL_TYPE_ID,
                    EMAIL_CRTD_ID, EMAIL_CRTD_DT,
                    EMAIL_UPDT_ID, EMAIL_UPDT_ID
                )
                VALUES (
                    :EMAIL_NAME,
                    :EMAIL_EMAIL_TYPE_ID,
                    :EMAIL_CRTD_ID, :EMAIL_CRTD_DT,
                    :ADDRESS_UPDT_ID, :ADDRESS_UPDT_ID
                )
                RETURNING EMAIL_ID INTO :NEW_EMAIL_ID';
            
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
