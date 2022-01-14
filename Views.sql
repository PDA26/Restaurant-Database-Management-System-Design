CREATE OR REPLACE VIEW ALL_EMPLOYEE_TIPS
AS select a.tipsCount tips_count, b.firstName first_name, b.lastName last_name
    from attendant a
    join employee b
    on a.id = b.id
    union 
    select c.tipsCount tips_count, d.firstName first_name, d.lastName last_name 
    from deliveryattendant c
    join employee d
    on c.id = d.id;

CREATE OR REPLACE VIEW TABLE_AVAILABILITY
AS 
SELECT SYSDATE curr_time, DATETIMEIN time_in, DATETIMEOUT time_out, tableId table_id
    FROM RESERVATION 
    WHERE RESERVATION.STATUS <> 'Cancel';

 

CREATE OR REPLACE VIEW DELIVERY_TIPS  
AS 
  SELECT DELIVERID, TIPSVALUE 
FROM
    (SELECT DELIVERID, SUM(TIPSVALUE) TIPSVALUE
     FROM DELIVERYORDER D INNER JOIN PAYMENT P ON P.ID = D.PAYMENTID
     GROUP BY DELIVERID
    );

--------------------------------------------------------
--  DDL for View DINEIN_TIPS
--------------------------------------------------------

  CREATE OR REPLACE VIEW DINEIN_TIPS 
AS
  SELECT ATTENDANTID, TIPSVALUE
FROM
    (SELECT ATTENDANTID, SUM(TIPSVALUE) TIPSVALUE
     FROM (DINEINORDER D INNER JOIN DININGTABLE T ON D.TABLEID = T.ID) INNER JOIN PAYMENT P ON P.ID = D.PAYMENTID
     GROUP BY ATTENDANTID
     );

--------------------------------------------------------
--  DDL for View CURRENTDATE_MONEY
--------------------------------------------------------

  CREATE OR REPLACE VIEW CURRENTDATE_MONEY
AS 
  SELECT TO_CHAR(DATETIME, 'YYYY-MM-DD') CURRENT_DATE, SUM(MAINVALUE)
FROM PAYMENT
GROUP BY  TO_CHAR(DATETIME, 'YYYY-MM-DD')
ORDER BY TO_CHAR(DATETIME, 'YYYY-MM-DD');

