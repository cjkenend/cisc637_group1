CREATE OR REPLACE PROCEDURE MIGRATE_ONR AS
    v_contact_id      VARCHAR2(38);
    v_office_id       VARCHAR2(38);
    v_address_id      VARCHAR2(38);
    v_phone_id        VARCHAR2(38);
    v_email_id        VARCHAR2(38);
    
    -- Type IDs
    v_addr_type       VARCHAR2(38);
    v_phone_type      VARCHAR2(38);
    v_fax_type        VARCHAR2(38);
    v_email_type      VARCHAR2(38);
    v_office_type     VARCHAR2(38);
BEGIN
    -- Get Type IDs
    SELECT address_type_id INTO v_addr_type 
    FROM addrress_type WHERE address_type_desc = 'Main Office';
    
    SELECT phone_type_id INTO v_phone_type 
    FROM phone_type WHERE phone_type_desc = 'Work Phone';
    
    SELECT phone_type_id INTO v_fax_type 
    FROM phone_type WHERE phone_type_desc = 'Fax';
    
    SELECT email_type_id INTO v_email_type 
    FROM email_type WHERE email_type_desc = 'Work Email';
    
    SELECT office_type_id INTO v_office_type 
    FROM office_type WHERE office_type_desc = 'Regional Office';

    FOR onr_rec IN (SELECT * FROM UD_CISC637_GROUP1.TBL_ONR) LOOP
        -- Process Office
        ud_cisc637_group1_target.insert_or_get_office(
            in_office_name => onr_rec.OFFICE,
            in_office_type_id => v_office_type,
            out_office_id => v_office_id
        );

        -- Create Contact
        INSERT INTO contact(contact_desc, office_id) 
        VALUES('ONR', v_office_id)
        RETURNING contact_id INTO v_contact_id;

        -- Process Addresses
        FOR i IN 1..2 LOOP
            IF (i = 1 AND onr_rec.ADDRESS1 IS NOT NULL) OR 
               (i = 2 AND onr_rec.ADDRESS2 IS NOT NULL) THEN
               
                ud_cisc637_group1_target.insert_or_get_address(
                    in_dest_table_name => 'ADDRESS',
                    in_address_value => DECODE(i, 1, onr_rec.ADDRESS1, onr_rec.ADDRESS2),
                    in_address_city => onr_rec.CITY,
                    in_address_state => onr_rec.STATE,
                    in_address_zip => onr_rec.ZIPCODE,
                    in_address_type_id => v_addr_type,
                    out_address_id => v_address_id
                );

                INSERT INTO contact_address(contact_address_contact_id, contact_address_address_id)
                VALUES(v_contact_id, v_address_id);
            END IF;
        END LOOP;

        -- Process Phone/Fax
        FOR phone_data IN (
            SELECT onr_rec.PHONE AS num, v_phone_type AS type FROM DUAL
            UNION ALL
            SELECT onr_rec.FAX, v_fax_type FROM DUAL
        ) LOOP
            IF phone_data.num IS NOT NULL THEN
                ud_cisc637_group1_target.insert_or_get_phone(
                    in_dest_table_name => 'PHONE',
                    in_phone_number => phone_data.num,
                    in_phone_type_id => phone_data.type,
                    out_phone_id => v_phone_id
                );

                INSERT INTO contact_phone(contact_phone_contact_id, contact_phone_phone_id)
                VALUES(v_contact_id, v_phone_id);
            END IF;
        END LOOP;

        -- Process Email
        IF onr_rec.EMAIL IS NOT NULL THEN
            ud_cisc637_group1_target.insert_or_get_email(
                in_email => 'EMAIL',
                in_email_name => onr_rec.EMAIL,
                in_email_type_id => v_email_type,
                out_email_id => v_email_id
            );

            INSERT INTO contact_email(contact_email_contact_id, contact_email_email_id)
            VALUES(v_contact_id, v_email_id);
        END IF;
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END MIGRATE_ONR;