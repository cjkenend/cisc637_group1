--This is the thing the procedure(for type tables) should create but just in case it fails :)

-------------------------------------
--INSTERT, normalize for address_type
--------------------------------------
INSERT INTO ADDRESS_TYPE ( ADDRESS_TYPE_DESC )
    SELECT DISTINCT
        ADDRESS_DESC
    FROM
        ADDRESS;

ALTER TABLE ADDRESS ADD (
    ADDRESS_ADDRESS_TYPE_ID VARCHAR2(38)
);

UPDATE ADDRESS
SET
    ADDRESS_ADDRESS_TYPE_ID = (
        SELECT
            ADDRESS_TYPE_ID
        FROM
            ADDRESS_TYPE
        WHERE
            ADDRESS_TYPE_DESC = ADDRESS.ADDRESS_DESC
    );

ALTER TABLE ADDRESS
    ADD CONSTRAINT ADDRESS_fk1
        FOREIGN KEY ( ADDRESS_ADDRESS_TYPE_ID )
            REFERENCES ADDRESS_TYPE ( ADDRESS_TYPE_ID )
        ENABLE;

ALTER TABLE ADDRESS DROP COLUMN ADDRESS_DESC;

------------------------------------
--INSTERT, normalize for Phone_type
------------------------------------
INSERT INTO PHONE_TYPE ( PHONE_TYPE_DESC )
    SELECT DISTINCT
        PHONE_DESC
    FROM
        PHONE;

ALTER TABLE PHONE ADD (
    PHONE_PHONE_TYPE_ID VARCHAR2(38)
);

UPDATE PHONE
SET
    PHONE_PHONE_TYPE_ID = (
        SELECT
            PHONE_TYPE_ID
        FROM
            PHONE_TYPE
        WHERE
            PHONE_TYPE_DESC = PHONE.PHONE_DESC
    );

ALTER TABLE PHONE
    ADD CONSTRAINT PHONE_fk1
        FOREIGN KEY ( PHONE_PHONE_TYPE_ID )
            REFERENCES PHONE_TYPE ( PHONE_TYPE_ID )
        ENABLE;

ALTER TABLE PHONE DROP COLUMN PHONE_DESC;

-------------------------------------
--INSTERT, normalize for Email_type
-------------------------------------
INSERT INTO EMAIL_TYPE ( EMAIL_TYPE_DESC )
    SELECT DISTINCT
        EMAIL_DESC
    FROM
        EMAIL;

ALTER TABLE EMAIL ADD (
    EMAIL_EMAIL_TYPE_ID VARCHAR2(38)
);

UPDATE EMAIL
SET
    EMAIL_EMAIL_TYPE_ID = (
        SELECT
            EMAIL_TYPE_ID
        FROM
            EMAIL_TYPE
        WHERE
            EMAIL_TYPE_DESC = EMAIL.EMAIL_DESC
    );

ALTER TABLE EMAIL
    ADD CONSTRAINT EMAIL_fk1
        FOREIGN KEY ( EMAIL_EMAIL_TYPE_ID )
            REFERENCES EMAIL_TYPE ( EMAIL_TYPE_ID )
        ENABLE;

ALTER TABLE EMAIL DROP COLUMN EMAIL_DESC;

--------------------------------------
--INSTERT, normalize for Contact_type
--------------------------------------
INSERT INTO CONTACT_TYPE ( CONTACT_TYPE_DESC )
    SELECT DISTINCT
        CONTACT_DESC
    FROM
        CONTACT;

ALTER TABLE CONTACT ADD (
    CONTACT_CONTACT_TYPE_ID VARCHAR2(38)
);

UPDATE CONTACT
SET
    CONTACT_CONTACT_TYPE_ID = (
        SELECT
            CONTACT_TYPE_ID
        FROM
            CONTACT_TYPE
        WHERE
            CONTACT_TYPE_DESC = CONTACT.CONTACT_DESC
    );

ALTER TABLE CONTACT
    ADD CONSTRAINT CONTACT_fk1
        FOREIGN KEY ( CONTACT_CONTACT_TYPE_ID )
            REFERENCES CONTACT_TYPE ( CONTACT_TYPE_ID )
        ENABLE;

ALTER TABLE CONTACT DROP COLUMN CONTACT_DESC;



