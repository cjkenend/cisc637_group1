
-- NOTES
-- Missing Handling of Region
-- Assumes existence of 
--      office_type_desc: HEADQUARTERS
--      address_type_desc: HOME
--      phone_type_desc: FAX, PERSONAL 
--      email_type_desc: WORK
---------------------------------------------------
-- Loop over rows in DFAS table

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
    v_office_type_id        UD_CISC637_GROUP1_TARGET.office_type.office_type_id%TYPE;
    v_address_type_id       UD_CISC637_GROUP1_TARGET.address_type.address_type_id%TYPE;
    v_phone_type_id         UD_CISC637_GROUP1_TARGET.phone_type.phone_type_id%TYPE;
    v_fax_type_id           UD_CISC637_GROUP1_TARGET.phone_type.phone_type_id%TYPE;

BEGIN
    -- Get needed type_ids
    SELECT OFFICE_TYPE_ID INTO v_office_type_id FROM UD_CISC637_GROUP1_TARGET.office_type WHERE OFFICE_TYPE_DESC = 'FINANCIAL_OFFICE';
    SELECT ADDRESS_TYPE_ID INTO v_address_type_id FROM UD_CISC637_GROUP1_TARGET.address_type WHERE ADDRESS_TYPE_DESC = 'OPERATIONAL';
    SELECT PHONE_TYPE_ID INTO v_phone_type_id FROM UD_CISC637_GROUP1_TARGET.phone_type WHERE PHONE_TYPE_DESC = 'WORK';
    SELECT PHONE_TYPE_ID INTO v_fax_type_id FROM UD_CISC637_GROUP1_TARGET.phone_type WHERE PHONE_TYPE_DESC = 'FAX';
    SELECT CONTACT_TYPE_ID INTO v_contact_type_id FROM UD_CISC637_GROUP1_TARGET.contact_type WHERE CONTACT_TYPE_DESC = 'dfas';

    -- Put values into variables
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

        -- Creates a new contact with CONTACT_TYPE_ID for DFAS
        ----------------------------------------------------------
        INSERT INTO ud_cisc637_group1_target.contact (contact_contact_type_id)
        VALUES(v_contact_type_id) RETURNING contact_id INTO v_contact_id;
        COMMIT;
        ----------------------------------------------------------

        --OFFICE PART------------------------------------------------
        IF df.office IS NOT NULL THEN
            v_office_id := insert_or_get_office(
                in_dest_table_name     => 'OFFICE',
                in_office_name         => v_office,
                in_office_office_type_id     => v_office_type_id,
                in_office_crtd_id     => v_crt_user,
                in_office_crtd_dt     => v_crt_date,
                in_office_updt_id     => v_mdf_user,
                in_office_updt_dt     => v_mdf_date
            );
            
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_office
            (contact_office_contact_id, contact_office_office_id)
            VALUES(v_contact_id, v_office_id);
        END IF;

        --ADDRESS1 HANDLING------------------------------------------
        IF df.address1 IS NOT NULL THEN   
            v_address1_id := insert_or_get_address(
                in_dest_table_name => 'ADDRESS',
                in_address_value   => v_address1,
                in_address_region  => NULL,
                in_address_city    => v_city,
                in_address_state   => v_state,
                in_address_zip     => v_zip,
                in_address_address_type_id => v_address_type_id,
                in_address_crtd_id => v_crt_user,
                in_address_crtd_dt => v_crt_date,
                in_address_updt_id => v_mdf_user,
                in_address_updt_dt => v_mdf_date
            );
            
            INSERT INTO UD_CISC637_GROUP1_TARGET.contact_address
            (contact_address_contact_id, contact_address_address_id)
            VALUES(v_contact_id, v_address1_id);
        END IF;

        --ADDRESS2 HANDLING------------------------------------------
        IF df.address2 IS NOT NULL THEN
            v_address2_id := insert_or_get_address(
                in_dest_table_name => 'ADDRESS',
                in_address_value   => v_address2,
                in_address_region  => NULL,
                in_address_city    => v_city,
                in_address_state   => v_state,
                in_address_zip     => v_zip,
                in_address_address_type_id => v_address_type_id,
                in_address_crtd_id => v_crt_user,
                in_address_crtd_dt => v_crt_date,
                in_address_updt_id => v_mdf_user,
                in_address_updt_dt => v_mdf_date
            );
            
            INSERT INTO contact_address VALUES(v_contact_id, v_address2_id);
        END IF;

        --PHONE1 HANDLING--------------------------------------------
        IF df.phone1 IS NOT NULL THEN
            v_phone1_id := insert_or_get_phone(
                in_dest_table_name => 'PHONE',
                in_phone_number    => v_phone1,
                in_phone_phone_type_id  => v_phone_type_id,
                in_phone_crtd_id  => v_crt_user,
                in_phone_crtd_dt  => v_crt_date,
                in_phone_updt_id  => v_mdf_user,
                in_phone_updt_dt  => v_mdf_date
            );
            
            INSERT INTO contact_phone VALUES(v_contact_id, v_phone1_id);
        END IF;

        --PHONE2 HANDLING--------------------------------------------
        IF df.phone2 IS NOT NULL THEN
            v_phone2_id := insert_or_get_phone(
                in_dest_table_name => 'PHONE',
                in_phone_number    => v_phone2,
                in_phone_phone_type_id  => v_phone_type_id,
                in_phone_crtd_id  => v_crt_user,
                in_phone_crtd_dt  => v_crt_date,
                in_phone_updt_id  => v_mdf_user,
                in_phone_updt_dt  => v_mdf_date
            );
            
            INSERT INTO contact_phone VALUES(v_contact_id, v_phone2_id);
        END IF;

        --FAX HANDLING-----------------------------------------------
        IF df.fax IS NOT NULL THEN
            v_fax_id := insert_or_get_phone(
                in_dest_table_name => 'PHONE',
                in_phone_number    => v_fax,
                in_phone_type_id  => v_fax_type_id,
                in_phone_crtd_id  => v_crt_user,
                in_phone_crtd_dt  => v_crt_date,
                in_phone_updt_id  => v_mdf_user,
                in_phone_updt_dt  => v_mdf_date
            );
            
            INSERT INTO contact_phone VALUES(v_contact_id, v_fax_id);
        END IF;

    END LOOP;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END MIGRATE_DFAS;
