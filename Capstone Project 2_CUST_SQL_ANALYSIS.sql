USE customer_case
GO

--Create view for the 4 tables
CREATE VIEW vwoverall AS
SELECT ca.case_id, ca.date_time,ca.customer_id,ca.channel, ca.reason,ci.age,ci.gender, cp.product_id, cp.signup_date_time, 
cp.cancel_date_time, pi.product_name,pi.billing_cycle, pi.price
FROM custcase ca
INNER JOIN custinfo ci
ON ca.customer_id = ci.customer_id
INNER JOIN custprod cp
ON ca.customer_id = cp.customer_id
INNER JOIN prodinfo pi
ON cp.product_id = pi.product_id;

--DROP VIEW vwoverall;

SELECT * FROM vwoverall;
========================================================================================================================
--Overall cases from year 2018 to 2020

CREATE VIEW Overall_Yearly_cases AS
SELECT Top 3
year(date_time) AS "Year", COUNT(*) AS "No_of_cases"
FROM custcase
GROUP BY year(date_time)
ORDER BY 1;

--DROP VIEW Overall_Yearly_cases;

SELECT * , FORMAT(ROUND((No_of_cases*100.00/177149),2),'#.##') AS 'Percentage'
FROM Overall_Yearly_Cases;
=============================================================================================================================
--Yearly cases for 2018, 2019, 2020 (use VIEW, JOIN, DATE, SUM, 

CREATE VIEW year_2018 AS
SELECT year(date_time) AS 'YEAR', month(date_time) AS 'MONTH',COUNT(*) AS 'CASES_2018'
FROM custcase
WHERE year(date_time) = '2018'
GROUP BY year(date_time),month(date_time);

--DROP VIEW year_2018;
SELECT * FROM year_2018;

CREATE VIEW year_2019 AS
SELECT year(date_time) AS 'YEAR', month(date_time) AS 'MONTH',COUNT(*) AS 'CASES_2019'
FROM custcase
WHERE year(date_time) = '2019'
GROUP BY year(date_time),month(date_time);

--DROP VIEW year_2019;
SELECT * FROM year_2019;

CREATE VIEW year_2020 AS
SELECT year(date_time) AS 'YEAR', month(date_time) AS 'MONTH',COUNT(*) AS 'CASES_2020'
FROM custcase
WHERE year(date_time) = '2020'
GROUP BY year(date_time),month(date_time);

--DROP VIEW year_2020;
SELECT * FROM year_2020;

CREATE VIEW vwCases_in_table AS
SELECT yr18.month AS 'MONTH',yr18.cases_2018 AS 'CASES_2018',
yr19.cases_2019 AS 'CASES_2019',yr20.cases_2020 AS 'CASES_2020'
FROM year_2018 yr18
INNER JOIN year_2019 yr19
ON yr18.month = yr19.month
INNER JOIN year_2020 yr20
ON yr19.month = yr20.month;

--DROP VIEW vwCases_in_table;
SELECT * FROM vwCases_in_table;

CREATE VIEW summary_table AS
SELECT *, FORMAT(ROUND((100.00*(cases_2019 - cases_2018)/(cases_2018)),2), '#.##') AS '% Increase in 2019', 
FORMAT(ROUND((100.00*(cases_2020 - cases_2019)/(cases_2019)),2),'#.##') AS '% Increase in 2020'
FROM vwCases_in_table;

--DROP VIEW summary_table;

SELECT * 
FROM summary_table
ORDER BY MONTH;
=========================================================================================================================
--Create procedure to retrieve yearly customer signup cases
CREATE VIEW vwage_gender AS
SELECT cp.customer_id, cp.signup_date_time, ci.age, ci.gender, year(cp.signup_date_time) AS 'Year_signup'
FROM custprod cp
INNER JOIN custinfo ci
ON cp.customer_id = ci.customer_id;

--DROP VIEW vwage_gender;

SELECT COUNT(*) 
FROM vwage_gender;

--Create a view from vwoverall to analyse age_range
CREATE VIEW vwage_range AS
SELECT customer_id, gender, age,
	CASE
		WHEN age <= 40 THEN 'Age_21-40'
		WHEN age <= 60 THEN 'Age_41-60'
		WHEN age <= 80 THEN 'Age_61-80'
		ELSE 'Age_>90'
	END AS 'Age_range'
FROM vwage_gender;

--DROP VIEW vwage_range;

SELECT COUNT(*) FROM vwage_range;
SELECT * FROM vwage_range;

CREATE VIEW vwage_signup AS
SELECT age_range, COUNT(*) AS 'No_of_signup_cases'
FROM vwage_range
GROUP BY age_range;

SELECT * 
FROM vwage_signup
ORDER BY No_of_signup_cases DESC;

SELECT *, FORMAT(ROUND((No_of_signup_cases*100.00/313617), 2), '#.##')  AS 'age_percentage'
FROM vwage_signup
ORDER BY age_percentage DESC;
======================================================================================================================
--Analyze subscription types
CREATE VIEW vwprod_type AS
SELECT cp.customer_id,pi.product_name, cp.product_id, year(cp.signup_date_time) AS 'Year_signup'
FROM custprod cp
INNER JOIN prodinfo pi
ON cp.product_id = pi.product_id;

SELECT * 
FROM vwprod_type;

CREATE VIEW vwprod_type_table AS
SELECT product_name, COUNT(*) AS 'No_of_signup'
FROM vwprod_type
GROUP BY product_name;

SELECT product_name, No_of_signup, FORMAT(ROUND((No_of_signup*100.0/313617), 2), '#.##') AS 'Percentage'
FROM vwprod_type_table
ORDER BY percentage DESC;

SELECT year_signup, product_name, COUNT(*) AS 'Total_no_of_subscribers'
FROM vwprod_type
GROUP BY year_signup, product_name
ORDER BY year_signup
==========================================================================================================================
--Analyze signup based on gender by using the previous VIEW created under age section
CREATE VIEW gender AS
SELECT gender, COUNT(*) AS 'No_of_cases'
FROM vwage_gender
GROUP BY gender;

--DROP VIEW gender;

SELECT *, FORMAT(ROUND((No_of_cases*100.0/313617), 2),'#.##') AS 'percentage'
FROM gender
ORDER BY percentage DESC;
===========================================================================================================================
--Analyze channel & reason, created function to calculate percentage
CREATE VIEW reason AS
SELECT reason, COUNT(*) AS 'Cases_reason'
FROM custcase
GROUP BY reason;

CREATE VIEW Channel AS
SELECT channel, COUNT(*) AS 'Cases_channel'
FROM custcase
GROUP BY channel;

--DROP FUNCTION percentage_reason;
SELECT * FROM reason; 

--DROP VIEW channel;
SELECT * FROM channel;

CREATE FUNCTION percentage 
(@cases float)
RETURNS float
AS
BEGIN
	RETURN FORMAT(ROUND((@cases*100.00/177149.00),2), '#.##')
END;

--DROP FUNCTION percentage;

SELECT reason, cases_reason, customer_case.dbo.percentage(cases_reason) AS 'percentage'
FROM reason
ORDER BY percentage DESC;

SELECT channel, cases_channel, customer_case.dbo.percentage(cases_channel) AS 'percentage'
FROM Channel
ORDER BY percentage DESC;
=========================================================================================================================
--Analyze phone & email cases
CREATE PROCEDURE reason_channel
(@rsn nvarchar(50), @chnl nvarchar(50))
AS
BEGIN
	SELECT year(date_time) AS 'Year', COUNT(*) AS 'Cases'
	FROM custcase
	WHERE reason = @rsn AND channel = @chnl
	GROUP BY year(date_time)
	ORDER BY year(date_time)
END;

--DROP PROCEDURE reason_channel;

EXEC reason_channel 'signup','phone'
EXEC reason_channel 'support','phone' 

EXEC reason_channel 'signup','email' --NIL RECORD FOUND.Email signup not available.Customer only can signup via phone.
EXEC reason_channel 'support','email'
===========================================================================================================================
--Analyze cancelled cases within the same month of signup (from table custinfo, ci) & customer case (from custcase, ca)
CREATE VIEW vwdays_diff 
AS
WITH days_diff AS
	(SELECT customer_id, datediff(day, signup_date_time, cancel_date_time) AS 'days_different'
	FROM custprod
	WHERE cancel_date_time IS NOT NULL 
	AND signup_date_time IS NOT NULL),
cinfo AS
	(SELECT customer_id, gender, age
	FROM custinfo),
ccase AS
	(SELECT customer_id, channel, reason, date_time
	FROM custcase)
SELECT df.customer_id, df.days_different,ca.date_time, ca.channel, ca.reason, pi.product_name, ci.gender
FROM days_diff df
JOIN cinfo ci
ON df.customer_id = ci.customer_id
JOIN ccase ca
ON ci.customer_id = ca.customer_id
JOIN custprod cp
ON ci.customer_id = cp.customer_id
JOIN prodinfo pi
ON cp.product_id = pi.product_id

--DROP VIEW vwdays_diff;

SELECT * FROM vwdays_diff;

SELECT year(date_time), days_different AS 'No_of_days_subscripted', COUNT(*) AS 'Total_cases'
FROM vwdays_diff
WHERE days_different <=31
GROUP BY year(date_time),days_different
ORDER BY days_different;

SELECT year(date_time) AS 'Year', COUNT(*) AS 'Total_cases'
FROM vwdays_diff
WHERE days_different <=31
GROUP BY year(date_time)
ORDER BY year(date_time);