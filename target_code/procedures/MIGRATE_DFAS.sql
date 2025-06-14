
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