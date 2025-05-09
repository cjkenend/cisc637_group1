--Function Tests
SET SERVEROUTPUT ON;




--------TEST OFFICE FUNCTION-------
DECLARE
    v_office_id VARCHAR2(50);
BEGIN
    v_office_id := ud_cisc637_group1_target.insert_or_get_office(
        in_dest_table_name     => 'office',          -- Replace with your actual table name if different
        in_office_name         => 'Main Office',
        in_office_type_id      => 'HQ',              -- Use the correct type or ID based on your schema
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
        in_address_address_type_id => 'HOME',
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
        in_phone_type_id       => 'MOBILE',           -- Use a valid type ID or description depending on schema
        in_phone_crtd_id       => 'admin',
        in_phone_crtd_dt       => TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
        in_phone_updt_id       => 'admin',
        in_phone_updt_dt       => TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
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
        in_email_type_id       => 'PRIMARY', -- use actual type ID if it's numeric
        in_email_crtd_id       => 'admin',
        in_email_crtd_dt       => SYSDATE,
        in_email_updt_id       => 'admin',
        in_email_updt_dt       => SYSDATE
    );

    DBMS_OUTPUT.PUT_LINE('Returned Email ID: ' || v_email_id);
END;
/