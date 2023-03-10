SELECT COUNT(*) AS product FROM product;
SELECT COUNT(*) AS customer_info FROM customer_info;
SELECT COUNT(*) AS customer_case FROM customer_case;
SELECT COUNT(*) AS customer_product FROM customer_prod;


SELECT * FROM customer_info;
SELECT * FROM customer_case;
SELECT * FROM customer_prod;
SELECT * FROM product;


--No. of cases by gender
SELECT cu.gender,COUNT(ca.case_id) AS "customer_case"
FROM customer_info cu
LEFT JOIN customer_case ca
ON cu.customer_id = ca.customer_id
GROUP BY cu.gender;

--group by age
SELECT ci.age, 
	CASE
		WHEN age <= 20 THEN "Age_10_to_20"
		WHEN age <= 40 THEN "Age_21_to_40"
		WHEN age <= 60 THEN "Age_41_to_60"
		WHEN age <= 80 THEN "Age_61_to_80"
		ELSE "Age_>_90"
	END AS "Age_range"
FROM customer_info ci
LEFT JOIN customer_case cc
ON ci.customer_id = cc.customer_id 
ORDER by 2;

SELECT gender, COUNT(customer_id)
FROM customer_info
GROUP BY gender;

SELECT age, COUNT(customer_id)
FROM customer_info
GROUP BY age;

-----------------------------------------------------------------
SELECT * FROM customer_case;

SELECT channel, COUNT(*) AS "No_time_recorded"
FROM customer_case
WHERE date_time IS NULL
GROUP BY channel;

SELECT reason, COUNT(*) AS "Reason"
FROM customer_case
WHERE date_time IS NULL
GROUP BY reason;

SELECT customer_id, COUNT(case_id) AS "No_of_case"
FROM customer_case
GROUP BY customer_id
HAVING COUNT(case_id) >3
ORDER BY 2 DESC;

SELECT * FROM customer_case;
SELECT * FROM customer_prod;
--------------------------------------------------------------------
SELECT product_id, COUNT(customer_id)
FROM customer_prod
GROUP BY product_id;

SELECT product_id, signup_date_time, cancel_date_time
FROM customer_prod
WHERE signup_date_time IS NULL 
AND cancel_date_time IS NOT NULL;

--signup_date_time IS NULL, while cancel_date_time IS NOT NULL
SELECT product_id, COUNT(customer_id)
FROM customer_prod
WHERE product_id  IN (
		SELECT product_id
		FROM customer_prod
		WHERE signup_date_time IS NULL 
		AND cancel_date_time IS NOT NULL
		)
GROUP BY product_id
ORDER BY 2 DESC;


--CREATE PROCEDURE, WITHOUT parameter
SELECT * 
FROM customer_prod cp
INNER JOIN product p
ON cp.product_id = p.product_id;

SELECT * 
FROM customer_info ci
INNER JOIN customer_case ca
ON ci.customer_id = ca.customer_id

SELECT * 
FROM customer_info ci
INNER JOIN customer_case ca
ON ci.customer_id = ca.customer_id
INNER JOIN customer_prod cp 
ON ci.customer_id = cp.customer_id
INNER JOIN product p
ON cp.product_id = p.product_id;

--CREATE PROCEDURE WITH parameter
CREATE FUNCTION subprice
(@subprice int


-----------------------------------
SELECT * FROM product;
SELECT * FROM customer_prod;

SELECT *
FROM product
WHERE product_id IN (
					SELECT product_id, COUNT(*) AS "EXCLUDE_NULL"
					FROM customer_prod
					WHERE signup_date_time IS NOT NULL AND cancel_date_time IS NOT NULL
					GROUP BY product_id
SELECT product_id, COUNT(*) AS "INCLUDED_NULL"
FROM customer_prod
--WHERE signup_date_time IS NOT NULL AND cancel_date_time IS NOT NULL
GROUP BY product_id;

SELECT COUNT(*)--product_id, COUNT(*) AS "INCLUDED_NULL"
FROM customer_prod
WHERE signup_date_time IS NULL AND cancel_date_time IS NULL
GROUP BY product_id;