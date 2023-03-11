--Name of the database is called 'customer_case'.

--There are 4 tables in the database, 
--custcase(ca, customer_case), 
--custinfo(ci, customer_information), 
--custprod(cp, customer_product) and 
--prodinfo(pi, product_information).

--(1)Add constraint/primary key to custcase(ca) table
ALTER TABLE custcase
ADD CONSTRAINT PK_case_id PRIMARY KEY (case_id);

--(2)Add constraint/primary key to custinfo(ci) table
ALTER TABLE custinfo
ADD CONSTRAINT PK_customer_id PRIMARY KEY (customer_id);

-- (3)Add constraint/primary key to prodinfo(pi) table
ALTER TABLE prodinfo
ADD CONSTRAINT PK_product_id PRIMARY KEY (product_id);

--(4)Add foreign key to custcase(ca) table
ALTER TABLE custcase
ADD FOREIGN KEY (customer_id) REFERENCES custinfo (customer_id);

--(5)Add foreign key to custprod(cp) table
ALTER TABLE custprod
ADD FOREIGN KEY (customer_id) REFERENCES custinfo (customer_id);

--(6)Add foreign key to custprod(cp) table
ALTER TABLE custprod
ADD FOREIGN KEY (product_id) REFERENCES prodinfo (product_id);


--Check that logical links are created for the 4 tables.
SELECT * 
FROM custcase ca
INNER JOIN custinfo ci
ON ca.customer_id = ci.customer_id
INNER JOIN custprod cp
ON ci.customer_id = cp.customer_id
INNER JOIN prodinfo pi
ON cp.product_id = pi.product_id;

--Check total number of rows tally to raw dataset.
SELECT COUNT(*) FROM custcase;
SELECT COUNT(*) FROM custinfo;
SELECT COUNT(*) FROM custprod;
SELECT COUNT(*) FROM prodinfo;
