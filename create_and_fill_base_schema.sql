CREATE TABLE UD_CISC637_GROUP1.TBL_DCAA (
    OFFICE VARCHAR2(50),
    ADDRESS1 VARCHAR2(50),
    ADDRESS2 VARCHAR2(50),
    ADDRESS3 VARCHAR2(50),
    CITY VARCHAR2(50),
    STATE VARCHAR2(2),
    ZIPCODE VARCHAR2(10),
    PHONE VARCHAR2(20),
    COMMENTS VARCHAR2(1000),
    MODIFYDATE DATE,
    MODIFYUSER VARCHAR2(50),
    CREATEDATE DATE,
    CREATEUSER VARCHAR2(50)
);

INSERT INTO UD_CISC637_GROUP1.TBL_DCAA (
    OFFICE, ADDRESS1, ADDRESS2, ADDRESS3, CITY, STATE, ZIPCODE, PHONE,
    COMMENTS, MODIFYDATE, MODIFYUSER, CREATEDATE, CREATEUSER
) VALUES (
    'Wayne Enterprises', '1939 Kane Street', 'Penthouse Suite', 'Gotham Tower', 
    'Gotham City', 'NY', '10001', '(212) 555-1234', 'Headquarters of Wayne Enterprises, owned by Bruce Wayne.',
    TO_DATE('2023-03-22 09:15:00', 'YYYY-MM-DD HH24:MI:SS'),
    'BRUCE WAYNE', TO_DATE('2023-03-22 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'BRUCE WAYNE'
);

CREATE TABLE UD_CISC637_GROUP1.TBL_DFAS (
	OFFICE VARCHAR2(50), 
	ADDRESS1 VARCHAR2(50), 
	ADDRESS2 VARCHAR2(50), 
	CITY VARCHAR2(50), 
	STATE VARCHAR2(2), 
	ZIP VARCHAR2(10), 
	PHONE1 VARCHAR2(20), 
	PHONE2 VARCHAR2(20), 
	FAX VARCHAR2(14), 
	CODE VARCHAR2(10), 
	MODIFYUSER VARCHAR2(50), 
	MODIFYDATE DATE, 
	CREATEUSER VARCHAR2(50), 
	CREATEDATE DATE
);

INSERT INTO UD_CISC637_GROUP1.TBL_DFAS (
    OFFICE, ADDRESS1, ADDRESS2, CITY, STATE, ZIP, PHONE1, PHONE2,
    FAX, CODE, MODIFYUSER, MODIFYDATE, CREATEUSER, CREATEDATE
) VALUES (
    'Gotham Police HQ', '1 Gotham Plaza', 'Gotham PD HQ', 'Gotham City', 'NY', '10001', 
    '(212) 555-9876', '(212) 555-6543', '(212) 555-4321', 'GCPD',
    'JAMES GORDON', TO_DATE('2022-06-15 14:20:00', 'YYYY-MM-DD HH24:MI:SS'),
    'JAMES GORDON', TO_DATE('2022-06-15 14:20:00', 'YYYY-MM-DD HH24:MI:SS')
);

CREATE TABLE UD_CISC637_GROUP1.TBL_ONR (
    OFFICE VARCHAR2(50),
    REGION VARCHAR2(50),
    ADDRESS1 VARCHAR2(50),
    ADDRESS2 VARCHAR2(50),
    CITY VARCHAR2(50),
    STATE VARCHAR2(2),
    ZIPCODE VARCHAR2(10),
    PHONE VARCHAR2(20),
    FAX VARCHAR2(14),
    CODE VARCHAR2(10),
    EMAIL VARCHAR2(50),
    COMMENTS VARCHAR2(1000),
    MODIFYUSER VARCHAR2(50),
    MODIFYDATE DATE,
    CREATEUSER VARCHAR2(50),
    CREATEDATE DATE
);

INSERT INTO UD_CISC637_GROUP1.TBL_ONR (
    OFFICE, REGION, ADDRESS1, ADDRESS2, CITY, STATE, ZIPCODE,
    PHONE, FAX, CODE, EMAIL, COMMENTS,
    MODIFYUSER, MODIFYDATE, CREATEUSER, CREATEDATE
) VALUES (
    'Batcave', 'Gotham Region', 'Batcave Entrance', 'Beneath Wayne Manor', 
    'Gotham City', 'NY', '10001', '(212) 555-0001', '(212) 555-9999', 'BAT-001', 
    'batman@gotham.com', 'Secret base of Batman, located under Wayne Manor.',
    'BATMAN', TO_DATE('2024-07-10 11:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    'BATMAN', TO_DATE('2024-07-10 11:30:00', 'YYYY-MM-DD HH24:MI:SS')
);

GRANT SELECT ON UD_CISC637_GROUP1.TBL_DCAA TO UD_CISC637_GROUP1_TARGET;
GRANT SELECT ON UD_CISC637_GROUP1.TBL_DFAS TO UD_CISC637_GROUP1_TARGET;
GRANT SELECT ON UD_CISC637_GROUP1.TBL_ONR TO UD_CISC637_GROUP1_TARGET;
