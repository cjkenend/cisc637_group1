--NOT FINAL. JUST WANTED TO SHARE TO SEE IF ANYONE HAD ANY NOTES

CREATE OR REPLACE PROCEDURE move_onr AS
    CURSOR onr_cursor IS SELECT * FROM UD_CISC637_GROUP1.TBL_ONR;

    BEGIN
        FOR onr IN onr_cursor LOOP
    
        
        -- See if the Address already exists in ADDRESS: Save boolean HAS_ADDRESS
        -- See if the Phone already exists in PHONE: Save boolean HAS_PHONE
        -- See if the email already exists in EMAIL Save boolean HAS_EMAILS
            -- If any of the above are true, take the CONTACT_ID associated to them
            -- Save CONTACT_ID into variable NOW_CONTACT_ID
            
            -- If None of the above are true, create a new contact in CONTACT
            -- Save generated CONTACT_ID into variable NOW_CONTACT_ID
        
        
        --PHONE PART
        --Check variable HAS_PHONE
            --TRUE: 
                --It already exists, do nothing and move on to address
            --FALSE:
                --It does not exist yet
                --INSERT onr.PHONE and onr.FAX in PHONE (With proper type ID)
                --INSERT 2 new records in CONTACT_PHONE using NOW_CONTACT_ID (one for PHONE and one for FAX)
        
        --ADDRESS PART
        --Check variable HAS_ADDRESS
            --TRUE: 
                --It already exists, do nothing and move on to email
            --FALSE:
                --It does not exist yet
                --INSERT onr.ADDRESS1 and onr.ADDRESS2 into ADDRESS (With proper type ID)
                --INSERT 2 new records in CONTACT_ADRESS using NOW_CONTACT_ID (one for ADDRESS1 and one for ADDRESS2)
                
        --EMAIL PART
        --Check variable HAS_EMAIL
            --TRUE: 
                --It already exists, do nothing and commit all changes
            --FALSE:
                --It does not exist yet
                --INSERT onr.EMAIL into EMAIL(With proper type ID)
                --INSERT a new record in CONTACT_EMAIL using NOW_CONTACT_ID
      END LOOP;
END;