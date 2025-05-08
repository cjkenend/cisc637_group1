-- Goal is to make a procedure that is called gets an address from the table 

/* 
    Call the procedure with all of the variables for an insert on the table
    along with the source_table, dest_table, 
    and in this case address_num
*/

CREATE OR REPLACE PROCEDURE ud_cisc637_group1_target.insert_or_get_address(
    in_dest_table_name          IN VARCHAR2,

    in_address_value            IN VARCHAR2,
    in_address_city             IN VARCHAR2,
    in_address_state            IN VARCHAR2,
    in_address_zip              IN VARCHAR2,

    in_address_type_id          IN VARCHAR2,

    in_address_crtd_id          IN VARCHAR2,
    in_address_crtd_dt          IN VARCHAR2,
    
    in_address_updt_id          IN VARCHAR2,
    in_address_updt_dt          IN VARCHAR2,

    out_address_id              OUT VARCHAR2
)
IS
    v_sql               VARCHAR2(1000);
    v_tmp_address_id    VARCHAR2(38);

BEGIN

    --Set up check for address
    v_sql := '
        SELECT address_id 
        FROM ' || in_dest_table_name || '
        WHERE address_value = :address_value
        AND address_city = :address_city
        AND address_state = :address_state
        AND address_zip = :address_zip';

    --Now go through the execution process
    BEGIN
    
        --Execute
        EXECUTE IMMEDIATE v_sql
        INTO out_address_id
        USING in_address_value, in_address_city, in_address_state, in_address_zip;
    
    --Set an exception if data isn't found
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            
            --Handle the insert now 
            v_sql := '
                INSERT INTO ud_cisc637_group1_target.' || in_dest_table_name || '(
                    address_value, address_city, address_state, address_zip, 
                    address_address_type_id,
                    address_crtd_id, address_crtd_dt,
                    address_updt_id, address_updt_dt
                )
                VALUES (
                    :address_value, :address_city, :address_state, :address_zip, 
                    :address_address_type_id,
                    :address_crtd_id, :address_crtd_dt,
                    :address_updt_id, :address_updt_dt
                )
                RETURNING address_id INTO :new_address_id';
            
            --Execute 
            EXECUTE IMMEDIATE v_sql
            INTO v_tmp_address_id
            USING in_address_value, in_address_city, in_address_state, in_address_zip,
                in_address_type_id,
                in_address_crtd_id, in_address_crtd_dt,
                in_address_updt_id, in_address_updt_dt;
            
            --Setting out variable
            out_address_id := v_tmp_address_id;
        
    END;
    
    --Raise if nothing is found or inserted
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
END;
/


