-- Chun-Wei Chen (1267040)
-- CSE 344 Homework 6 Problem 5
-- 02/27/14
---------------------------------------

-- part i
CREATE TABLE Sales(name VARCHAR(50), discount FLOAT, month VARCHAR(3), price INT);
.import mrFrumbleData.txt Sales

-- part ii
SELECT COUNT(*) 
FROM Sales s1, Sales s2 
WHERE s1.discount = s2.discount AND s1.month = s2.month AND s1.price = s2.price 
AND s1.name != s2.name;

/*
s1.name != s2.name
s1.price != s2.price
s1.month != s2.month
s1.discount != s2.discount
**/

-- part iv
INSERT INTO S1 SELECT DISTINCT name, price FROM Sales;
SELECT * FROM S1;
INSERT INTO S21 SELECT DISTINCT month, discount FROM Sales;
SELECT * FROM S21;
INSERT INTO S22 SELECT DISTINCT month, name FROM Sales;
SELECT * FROM S22;