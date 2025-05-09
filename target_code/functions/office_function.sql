-- Goal is to make a function that is called gets an office from the table 

/* 
    Call the function with all of the variables for an insert on the table
    along with the source_table, dest_table, 
    and in this case office_num
*/

CREATE OR REPLACE FUNCTION ud_cisc637_group1_target.insert_or_get_office(
    in_dest_table_name          IN VARCHAR2,

    in_office_name             IN VARCHAR2,

    in_office_type_id            IN VARCHAR2,

    in_office_crtd_id            IN VARCHAR2,
    in_office_crtd_dt            IN VARCHAR2,
    
    in_office_updt_id            IN VARCHAR2,
    in_office_updt_dt            IN VARCHAR2,

    out_office_id                OUT VARCHAR2
)
RETURN VARCAHR2
IS
    v_sql               VARCHAR2(1000);
    v_tmp_office_id    VARCHAR2(38);

BEGIN

    --Set up check for office
    v_sql := '
        SELECT office_id 
        FROM ' || in_dest_table_name || '
        WHERE office_number = :office_number';

    --Now go through the execution process
    BEGIN
    
        --Execute
        EXECUTE IMMEDIATE v_sql
        INTO out_office_id
        USING in_office_name;

        -- Return 
        RETURN(out_office_id);
    
    --Set an exception if data isn't found
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            
            --Handle the insert now 
            v_sql := '
                INSERT INTO ud_cisc637_group1_target.' || in_dest_table_name || '(
                    office_number, 
                    office_office_type_id,
                    office_crtd_id, office_crtd_dt,
                    office_updt_id, office_updt_dt
                )
                VALUES (
                    :office_number, 
                    :office_office_type_id,
                    :office_crtd_id, :office_crtd_dt,
                    :office_updt_id, :office_updt_dt
                )
                RETURNING office_id INTO :new_office_id';
            
            --Execute 
            EXECUTE IMMEDIATE v_sql
            INTO v_tmp_office_id
            USING in_office_name,
                in_office_type_id,
                in_office_crtd_id, in_office_crtd_dt,
                in_office_updt_id, in_office_updt_dt;
            
            --Setting out variable
            out_office_id := v_tmp_office_id;

            --Return
            RETURN(out_office_id);
        
    END;
    
    --Raise if nothing is found or inserted
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;

            --Return null
            RETURN(NULL);
END;
/
