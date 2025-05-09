-- Notes
/*
    Need to implement:
        - Need to change to start-end 
        - Have it so that it gets the UD_CISC637_GROUP1 -> UD_CISC637_GROUP1_TARGET
            - UD_CISC637_GROUP1 -> Contains original tables and datas
            - UD_CISC637_GROUP1_TARGET -> Our data
        - Call zap objects on TARGET schema
        - Add the data 
            - Make trigg02 first
            - Try to automate this to make it easier 
                - inputs: source table, taget table, source column, target column
                - Steps:
                    - Insert from source to target
                    - Alter main table for fk
                    - Link the fk 
                    - Drop the old table colun
                    -  Commit
                
        
    Checks:
        - Double check the columns
        - Check out 'code' column data in original table and insert where needed
 
*/



------------------------   Contact Tables ---------------------------------------

-- Making contact_type id
    -- Use: Hold all of the different names for the departments
CREATE TABLE contact_type (
    contact_type_id      VARCHAR2(38) NOT NULL,          --Right value for varchar?
    contact_type_crtd_id VARCHAR2(40) NOT NULL,
    contact_type_crtd_dt DATE NOT NULL,
    contact_type_updt_id VARCHAR2(40) NOT NULL,
    contact_type_updt_dt DATE NOT NULL,
    CONSTRAINT contact_type_pk PRIMARY KEY ( contact_type_id ) ENABLE
);

--- Making Contact table
    -- Use: Hold all of the information neeed for each department (onr, dcaa, etc.)
CREATE TABLE contact (
    contact_id              VARCHAR2(38) NOT NULL,          -- Make sure not missing and columns????
    contact_desc            VARCHAR2(4) NOT NULL,
    contact_crtd_id         VARCHAR2(40) NOT NULL,
    contact_crtd_dt         DATE NOT NULL,
    contact_updt_id         VARCHAR2(40) NOT NULL,
    contact_updt_dt         DATE NOT NULL,
    CONSTRAINT contact_pk PRIMARY KEY ( contact_id ) ENABLE
);

ALTER TABLE contact
    ADD CONSTRAINT contact_fk1
        FOREIGN KEY ( contact_contact_type_id )
            REFERENCES contact_type ( contact_type_id )
        ENABLE;



------------------------   Address Tables ---------------------------------------


-- Making the Address_type table 
    -- Use: Hold all of the different types of address 
CREATE TABLE address_type (
    address_type_id      VARCHAR2(38) NOT NULL,
    address_type_desc    VARCHAR2(255) NOT NULL,
    address_type_crtd_id VARCHAR2(40) NOT NULL,
    address_type_crtd_dt DATE NOT NULL,
    address_type_updt_id VARCHAR2(40) NOT NULL,
    address_type_updt_dt DATE NOT NULL,
    CONSTRAINT address_table_pk PRIMARY KEY ( address_type_id ) ENABLE
);

-- Making the Address table 
    -- Use: Hold all of the addresses
CREATE TABLE address (
    address_id              VARCHAR2(38) NOT NULL,
    address_value           VARCHAR2(50) NOT NULL,
    address_city            VARCHAR2(50) NOT NULL,
    address_state           VARCHAR2(2) NOT NULL,
    address_zip             VARCHAR2(10) NOT NULL,
    address_address_type_id VARCHAR2(38) NOT NULL,
    address_crtd_id         VARCHAR2(40) NOT NULL,
    address_crtd_dt         DATE NOT NULL,
    address_updt_id         VARCHAR2(40) NOT NULL,
    address_updt_dt         DATE NOT NULL,
    CONSTRAINT address_pk PRIMARY KEY ( address_id ) ENABLE
);

ALTER TABLE address
    ADD CONSTRAINT address_fk1
        FOREIGN KEY ( address_address_type_id )
            REFERENCES address_type ( address_type_id )
        ENABLE;






------------------------   Phone Tables ---------------------------------------
        

-- Making the Phone_type table 
    -- Use: Hold all of the different types of phones (fax, landline, work, personal, etc)
CREATE TABLE phone_type (
    phone_type_id      VARCHAR2(38) NOT NULL,
    phone_type_desc    VARCHAR2(50) NOT NULL,
    phone_type_crtd_id VARCHAR2(40) NOT NULL,
    phone_type_crtd_dt DATE NOT NULL,
    phone_type_updt_id VARCHAR2(40) NOT NULL,
    phone_type_updt_dt DATE NOT NULL,
    CONSTRAINT phone_type_pk PRIMARY KEY ( phone_type_id ) ENABLE
);


-- Making the Phone table 
    -- Use: Hold all of the different phones 
CREATE TABLE phone (
    phone_id            VARCHAR2(38) NOT NULL,
    phone_number        VARCHAR2(20) NOT NULL,          -- Longest Phone varchar was 20?
    phone_phone_type_id VARCHAR2(38) NOT NULL,          -- Do we need the code column here??
    phone_crtd_id       VARCHAR2(40) NOT NULL,
    phone_crtd_dt       DATE NOT NULL,
    phone_updt_id       VARCHAR2(40) NOT NULL,
    phone_updt_dt       DATE NOT NULL,
    CONSTRAINT phone_pk PRIMARY KEY ( phone_id ) ENABLE
);

ALTER TABLE phone
    ADD CONSTRAINT phone_fk1
        FOREIGN KEY ( phone_phone_type_id )
            REFERENCES phone_type ( phone_type_id )
        ENABLE;


   
   
   
        
------------------------   Email Tables ---------------------------------------
        
-- Making the Email_type table
    -- Use: Hold all the different email types
CREATE TABLE email_type (
    email_type_id      VARCHAR2(38) NOT NULL,
    email_type_desc    VARCHAR2(50) NOT NULL,       -- 50 is place holder. Personal/work???
    email_type_crtd_id VARCHAR2(40) NOT NULL,
    email_type_crtd_dt DATE NOT NULL,
    email_type_updt_id VARCHAR2(40) NOT NULL,
    email_type_updt_dt DATE NOT NULL,
    CONSTRAINT email_type_pk PRIMARY KEY ( email_type_id ) ENABLE
);


-- Making the Email table 
    -- Use: Hold all of the emails addresses
CREATE TABLE email (
    email_id            VARCHAR2(38) NOT NULL,
    email_name          VARCHAR2(20) NOT NULL,
    email_email_type_id VARCHAR2(38) NOT NULL,
    email_crtd_id       VARCHAR2(40) NOT NULL,
    email_crtd_dt       DATE NOT NULL,
    email_updt_id       VARCHAR2(40) NOT NULL,
    email_updt_dt       DATE NOT NULL,
    CONSTRAINT email_pk PRIMARY KEY ( email_id ) ENABLE
);

ALTER TABLE email
    ADD CONSTRAINT email_fk1
        FOREIGN KEY ( email_email_type_id )
            REFERENCES email_type ( email_type_id )
        ENABLE;
        
        
        
        
        
        
------------------------   Many to Many Tables ---------------------------------------


-- Making Contact_Address table
    -- Use: In between for the two tables 
CREATE TABLE contact_address (
    contact_address_id         VARCHAR2(38) NOT NULL,
    contact_address_contact_id VARCHAR2(38) NOT NULL,
    contact_address_address_id VARCHAR2(38) NOT NULL,
    contact_address_crtd_id    VARCHAR2(40) NOT NULL,
    contact_address_crtd_dt    DATE NOT NULL,
    contact_address_updt_id    VARCHAR2(40) NOT NULL,
    contact_address_updt_dt    DATE NOT NULL,
    CONSTRAINT contact_address_pk PRIMARY KEY ( contact_address_id ) ENABLE
);

ALTER TABLE contact_address
    ADD CONSTRAINT contact_address_fk1
        FOREIGN KEY ( contact_address_contact_id )
            REFERENCES contact ( contact_id )
        ENABLE;

ALTER TABLE contact_address
    ADD CONSTRAINT contact_address_fk2
        FOREIGN KEY ( contact_address_address_id )
            REFERENCES address ( address_id )
        ENABLE;
        



-- Making Contact_Phone table
    -- Use: In between for the two tables 
CREATE TABLE contact_phone (
    contact_phone_id         VARCHAR2(38) NOT NULL,
    contact_phone_contact_id VARCHAR2(38) NOT NULL,
    contact_phone_phone_id   VARCHAR2(38) NOT NULL,
    contact_phone_crtd_id    VARCHAR2(40) NOT NULL,
    contact_phone_crtd_dt    DATE NOT NULL,
    contact_phone_updt_id    VARCHAR2(40) NOT NULL,
    contact_phone_updt_dt    DATE NOT NULL,
    CONSTRAINT contact_phone_pk PRIMARY KEY ( contact_phone_id ) ENABLE
);

ALTER TABLE contact_phone
    ADD CONSTRAINT contact_phone_fk1
        FOREIGN KEY ( contact_phone_contact_id )
            REFERENCES contact ( contact_id )
        ENABLE;

ALTER TABLE contact_phone
    ADD CONSTRAINT contact_phone_fk2
        FOREIGN KEY ( contact_phone_phone_id )
            REFERENCES phone ( phone_id )
        ENABLE;
        
        
        

-- Making Contact_Email table
    -- Use: In between for the two tables 
CREATE TABLE contact_email (
    contact_email_id         VARCHAR2(38) NOT NULL,
    contact_email_contact_id VARCHAR2(38) NOT NULL,
    contact_email_email_id   VARCHAR2(38) NOT NULL,
    contact_email_crtd_id    VARCHAR2(40) NOT NULL,
    contact_email_crtd_dt    DATE NOT NULL,
    contact_email_updt_id    VARCHAR2(40) NOT NULL,
    contact_email_updt_dt    DATE NOT NULL,
    CONSTRAINT contact_email_pk PRIMARY KEY ( contact_email_id ) ENABLE
);

ALTER TABLE contact_email
    ADD CONSTRAINT contact_email_fk1
        FOREIGN KEY ( contact_email_contact_id )
            REFERENCES contact ( contact_id )
        ENABLE;

ALTER TABLE contact_email
    ADD CONSTRAINT contact_email_fk2
        FOREIGN KEY ( contact_email_email_id )
            REFERENCES email ( email_id )
        ENABLE;
