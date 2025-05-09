--Function Tests
SET SERVEROUTPUT ON;

--Inserts some types, IDS are then put in manualy
/*
INSERT INTO UD_CISC637_GROUP1_TARGET.OFFICE_TYPE (office_type_desc) VALUES ('HQ');
INSERT INTO UD_CISC637_GROUP1_TARGET.EMAIL_TYPE (email_type_desc) VALUES ('WORK');
INSERT INTO UD_CISC637_GROUP1_TARGET.PHONE_TYPE (phone_type_desc) VALUES ('FAX');
INSERT INTO UD_CISC637_GROUP1_TARGET.ADDRESS_TYPE (address_type_desc) VALUES ('HOME');
*/




--------TEST OFFICE FUNCTION-------
DECLARE
    v_office_id VARCHAR2(50);
BEGIN
    v_office_id := ud_cisc637_group1_target.insert_or_get_office(
        in_dest_table_name     => 'office',          -- Replace with your actual table name if different
        in_office_name         => 'Main Office',
        in_office_office_type_id      => '877032681D21459C8F480647A4DEB112',              -- Use the correct type or ID based on your schema
        in_office_crtd_id      => 'admin',
        in_office_crtd_dt      => SYSDATE,
        in_office_updt_id      => 'admin',
        in_office_updt_dt      => SYSDATE
    );

    DBMS_OUTPUT.PUT_LINE('Returned Office ID: ' || v_office_id);
END;
/

--------TEST ADDRESS FUNCTION-------
DECLARE
    v_address_id VARCHAR2(50);
BEGIN
    v_address_id := ud_cisc637_group1_target.insert_or_get_address(
        in_dest_table_name     => 'address',
        in_address_region      => 'Northeast',
        in_address_value       => '123 Main St',
        in_address_city        => 'Newark',
        in_address_state       => 'DE',
        in_address_zip         => '19711',
        in_address_address_type_id => '3FAF94131B6E462CB476D45AF47CA577',
        in_address_crtd_id     => 'admin',
        in_address_crtd_dt     => SYSDATE,
        in_address_updt_id     => 'admin',
        in_address_updt_dt     => SYSDATE
    );

    DBMS_OUTPUT.PUT_LINE('Returned Address ID: ' || v_address_id);
END;
/

--------TEST PHONE FUNCTION-------
DECLARE
    v_phone_id VARCHAR2(50);
BEGIN
    v_phone_id := ud_cisc637_group1_target.insert_or_get_phone(
        in_dest_table_name     => 'phone',            -- Make sure this matches the actual target table
        in_phone_number        => '3025551234',
        in_phone_phone_type_id       => 'CDF46C8125314268B74F3ACCA9746920',           -- Use a valid type ID or description depending on schema
        in_phone_crtd_id       => 'admin',
        in_phone_crtd_dt       => SYSDATE,
        in_phone_updt_id       => 'admin',
        in_phone_updt_dt       => SYSDATE
    );

    DBMS_OUTPUT.PUT_LINE('Returned Phone ID: ' || v_phone_id);
END;
/

--------TEST EMAIL FUNCTION-------
DECLARE
    v_email_id VARCHAR2(50);
BEGIN
    v_email_id := ud_cisc637_group1_target.insert_or_get_email(
        in_dest_table_name     => 'email',
        in_email_name          => 'testuser@example.com',
        in_email_email_type_id       => '62013B7C07F5471D87DB7371185C8651', -- use actual type ID if it's numeric
        in_email_crtd_id       => 'admin',
        in_email_crtd_dt       => SYSDATE,
        in_email_updt_id       => 'admin',
        in_email_updt_dt       => SYSDATE
    );

    DBMS_OUTPUT.PUT_LINE('Returned Email ID: ' || v_email_id);
END;
/