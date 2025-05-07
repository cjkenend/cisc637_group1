----- DCAA

-- Getting work address1 from TBL_DCAA
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS1,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Work'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_DCAA og;
    
-- Getting personal address1 from TBL_DCAA
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS1,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Personal'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_DCAA og;
    
    
-- Getting work address2 from TBL_DCAA
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS2,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Work'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_DCAA og;
    
-- Getting personal address2 from TBL_DCAA
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS2,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Personal'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_DCAA og;
    
    
-- Getting work address3 from TBL_DCAA
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS3,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Work'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_DCAA og;
    
-- Getting personal address1 from TBL_DCAA
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS3,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Personal'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_DCAA og;





------------------- DFAS -----------------


-- Getting work address1 from TBL_DFAS
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS1,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Work'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_DCAA og;
    
-- Getting personal address1 from TBL_DCAA
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS1,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Personal'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_DCAA og;
    
-- Getting work address2 from TBL_DFAS
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS2,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Work'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_DCAA og;
    
-- Getting personal address2 from TBL_DCAA
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS2,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Personal'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_DCAA og;
    
    


---------------- ONR --------------------------------



-- Getting work address1 from TBL_ONR
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS1,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Work'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_ONR og;
    
-- Getting personal address1 from TBL_ONR
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS1,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Personal'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_ONR og;
    
-- Getting work address2 from TBL_ONR
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS2,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Work'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_ONR og;
    
-- Getting personal address2 from TBL_ONR
INSERT INTO ud_cisc637_group1_target.address 
(address_value1, address_address_type, address_city, address_state, address_zip)
    SELECT 
        og.ADDRESS2,
        (SELECT address_type_id FROM ud_cisc637_group1_target.address_type WHERE address_type_desc = 'Personal'),
        og.CITY, 
        og.STATE, 
        OG.ZIPCODE, 
        og.MODIFYDATE, 
        og.MODIFYUSER, 
        og.CREATEDATE, 
        og.CREATEUSER
    FROM ud_cisc637_group1.TBL_ONR og;
