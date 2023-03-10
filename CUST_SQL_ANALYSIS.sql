USE customers
GO

--Create view for tables, custprod & prodinfo
CREATE VIEW 

select * from custprod;
select * from prodinfo;

SELECT cp.customer_id, cp.product_id, cp.signup_date_time, cp.cancel_date_time, pi.product_name, pi.billing_cycle, pi.price
FROM custprod cp
JOIN prodinfo pi
ON cp.product_id = pi.product_id

CREATE VIEW signup AS
SELECT customer_id,product_id, signup_date_time, cancel_date_time,
FORMAT(signup_date_time, 'dd-MM-yyyy') AS "signupDDMMYYYY", 
FORMAT(cancel_date_time, 'dd-MM-yyyy') AS "cancelDDMMYYYY"
FROM custprod
WHERE signup_date_time IS NOT NULL AND cancel_date_time IS NOT NULL;

DROP VIEW signup;

SELECT * FROM signup;

SELECT COUNT(customer_id), product_id
FROM signup
GROUP BY product_id;

SELECT day(signup_date_time) AS "Day",month(signup_date_time) AS "Month", YEAR(signup_date_time) AS "Year"
FROM custprod
WHERE day(signup_date_time)IS NOT NULL AND month(signup_date_time) IS NOT NULL AND YEAR(signup_date_time) IS NOT NULL;

SELECT DATEPART(YYYY,signup_date_time), DATEPART(YYYY,cancel_date_time)
FROM custprod;

SELECT DATEDIFF(year, DATEPART(year, signup_date_time), DATEPART(year,cancel_date_time))
FROM custprod;