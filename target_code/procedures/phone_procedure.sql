-- Goal is to make a procedure that is called gets an phone from the table 

/* 
    Call the procedure with all of the variables for an insert on the table
    along with the source_table, dest_table, dest_col_name, 
    and in this case phone_num
*/

CREATE OR REPLACE PROCEDURE ud_cisc637_group1_target.insert_or_get_phone(
    in_dest_table_name          IN VARCHAR2,
    in_dest_col_name            IN VARCHAR2,

    in_phone_number             IN VARCHAR2,

    in_phone_type_id            IN VARCHAR2,

    in_phone_crtd_id            IN VARCHAR2,
    in_phone_crtd_dt            IN VARCHAR2,
    
    in_phone_updt_id            IN VARCHAR2,
    in_phone_updt_dt            IN VARCHAR2,

    out_phone_id                OUT VARCHAR2
)
IS
    v_sql               VARCHAR2(1000);
    v_tmp_phone_id    VARCHAR2(38);

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
            INTO v_tmp_phone_id
            USING in_phone_number,
                in_phone_type_id,
                in_phone_crtd_id, in_phone_crtd_dt,
                in_phone_updt_id, in_phone_updt_dt;
            
            --Setting out variable
            out_phone_id := v_tmp_phone_id;
        
    END;
    
    --Raise if nothing is found or inserted
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
END;
/
