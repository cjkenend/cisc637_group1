
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
    v_office_type_id_fin    UD_CISC637_GROUP1_TARGET.office_type.office_type_id%TYPE;
    v_address_type_id_op    UD_CISC637_GROUP1_TARGET.address_type.address_type_id%TYPE;
    v_phone_type_id_work    UD_CISC637_GROUP1_TARGET.phone_type.phone_type_id%TYPE;
    v_phone_type_id_fax     UD_CISC637_GROUP1_TARGET.phone_type.phone_type_id%TYPE;

BEGIN
    -- Get needed type_ids
    SELECT OFFICE_TYPE_ID INTO v_office_type_id_fin FROM UD_CISC637_GROUP1_TARGET.office_type WHERE OFFICE_TYPE_DESC = 'FINANCIAL_OFFICE';
    SELECT ADDRESS_TYPE_ID INTO v_address_type_id_op FROM UD_CISC637_GROUP1_TARGET.address_type WHERE ADDRESS_TYPE_DESC = 'OPERATIONAL';
    SELECT PHONE_TYPE_ID INTO v_phone_type_id_work FROM UD_CISC637_GROUP1_TARGET.phone_type WHERE PHONE_TYPE_DESC = 'WORK';
    SELECT PHONE_TYPE_ID INTO v_phone_type_id_fax FROM UD_CISC637_GROUP1_TARGET.phone_type WHERE PHONE_TYPE_DESC = 'FAX';
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

        -- Create Contact
        INSERT INTO ud_cisc637_group1_target.contact (contact_contact_type_id)
        VALUES(v_contact_type_id) RETURNING contact_id INTO v_contact_id;

        --OFFICE HANDLING--------------------------------------------
        IF df.office IS NOT NULL THEN
            v_office_id := insert_or_get_office(
                in_dest_table_name     => 'OFFICE',
                in_office_name         => v_office,
                in_office_office_type_id => v_office_type_id_fin,
                in_office_crtd_id      => v_crt_user,
                in_office_crtd_dt      => v_crt_date,
                in_office_updt_id      => v_mdf_user,
                in_office_updt_dt      => v_mdf_date
            );
            INSERT INTO contact_office VALUES(v_contact_id, v_office_id);
        END IF;

        --ADDRESS HANDLING-------------------------------------------
        -- Address1
        IF df.address1 IS NOT NULL THEN   
            v_address1_id := insert_or_get_address(...); -- With v_address_type_id_op
            INSERT INTO contact_address VALUES(v_contact_id, v_address1_id);
        END IF;

        -- Address2
        IF df.address2 IS NOT NULL THEN
            v_address2_id := insert_or_get_address(...); -- With v_address_type_id_op
            INSERT INTO contact_address VALUES(v_contact_id, v_address2_id);
        END IF;

        --PHONE HANDLING---------------------------------------------
        -- Phone1
        IF df.phone1 IS NOT NULL THEN
            v_phone1_id := insert_or_get_phone(...); -- With v_phone_type_id_work
            INSERT INTO contact_phone VALUES(v_contact_id, v_phone1_id);
        END IF;

        -- Phone2
        IF df.phone2 IS NOT NULL THEN
            v_phone2_id := insert_or_get_phone(...); -- With v_phone_type_id_work
            INSERT INTO contact_phone VALUES(v_contact_id, v_phone2_id);
        END IF;

        --FAX HANDLING-----------------------------------------------
        IF df.fax IS NOT NULL THEN
            v_fax_id := insert_or_get_phone(
                in_dest_table_name => 'PHONE',
                in_phone_number    => v_fax,
                in_phone_type_id   => v_phone_type_id_fax,
                ... -- Other parameters
            );
            INSERT INTO contact_phone VALUES(v_contact_id, v_fax_id);
        END IF;

    END LOOP;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE VALUE_ERROR;
END MIGRATE_DFAS;
