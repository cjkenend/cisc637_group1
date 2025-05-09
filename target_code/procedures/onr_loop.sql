-- NOTES
-- Missing Handling of Region
-- Assumes existence of 
--      office_type_desc: HEADQUARTERS
--      address_type_desc: HOME
--      phone_type_desc: FAX, PERSONAL 
--      email_type_desc: WORK
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
      
CREATE OR REPLACE PROCEDURE MIGRATE_ONR AS
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
    --      office_type_desc: HEADQUARTERS
    --      address_type_desc: HOME
    --      phone_type_desc: FAX, PERSONAL 
    --      email_type_desc: WORK    
    BEGIN
        SELECT OFFICE_TYPE_ID INTO v_office_type_id_hq FROM UD_CISC637_GROUP1_TARGET.office_type WHERE OFFICE_TYPE_DESC = 'HQ';
        SELECT ADDRESS_TYPE_ID INTO v_address_type_id_home FROM UD_CISC637_GROUP1_TARGET.address_type WHERE ADDRESS_TYPE_DESC = 'Home';
        SELECT PHONE_TYPE_ID INTO v_phone_type_id_per FROM UD_CISC637_GROUP1_TARGET.phone_type WHERE PHONE_TYPE_DESC = 'Personal';
        SELECT PHONE_TYPE_ID INTO v_phone_type_id_fax FROM UD_CISC637_GROUP1_TARGET.phone_type WHERE PHONE_TYPE_DESC = 'fax';
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
            RAISE;
    END MIGRATE_ONR;
