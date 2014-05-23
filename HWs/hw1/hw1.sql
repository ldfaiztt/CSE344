-- Chun-Wei Chen
-- 1267040
-- mijc0517@cs
-- CSE344 HW1
-- 01/16/14
--------------------------------------------------------------------------------

-- Set up
.header on
.mode column
.nullvalue NULL
PRAGMA foreign_keys = ON;

-- 1a
CREATE TABLE R(A int, B int);

-- 1b
INSERT INTO R VALUES(2, 4);
INSERT INTO R VALUES(1, 1);
INSERT INTO R VALUES(3, 2);

-- 1c
SELECT * FROM R;
.print

-- 1d
INSERT INTO R VALUES('5', '2');
-- No error message shows up.
-- SQLite is able to convert between TEXT and INTEGER, 
-- if such conversion is lossless and reversible.

-- 1e
SELECT A FROM R;
.print

-- 1f
SELECT * FROM R WHERE A <= B;
.print

-- 2
CREATE TABLE MyRestaurants
  (name VARCHAR(50), 
  foodType VARCHAR(20), 
  dist int, 
  lastVisit VARCHAR(10), 
  iLike int);

-- 3
INSERT INTO MyRestaurants VALUES('Thai 65', 'Thai', 4, '2013-11-18', NULL);
INSERT INTO MyRestaurants VALUES('Subway', 'Western', 5, '2014-01-13', NULL);
INSERT INTO MyRestaurants VALUES('Chipotle', 'Mexican', 5, '2014-01-10', 1);
INSERT INTO MyRestaurants VALUES('Green House', 'Korean', 5, '2013-10-01', 1);
INSERT INTO MyRestaurants VALUES('Mee Sum Pastry', 'Taiwanese', 6, '2014-01-15', 1);
INSERT INTO MyRestaurants VALUES('U:Don Fresh Japanese Noodle Station', 'Japanese', 6, '2013-12-03', 1);
INSERT INTO MyRestaurants VALUES('McDonalds', 'Western', 15, '2013-11-05', 0);

-- 4
SELECT * FROM MyRestaurants;
.print

-- 5a
.mode csv
SELECT * FROM MyRestaurants;
.print

-- 5b
.mode list
.separator "|"
SELECT * FROM MyRestaurants;
.print

-- 5c
.mode column
.width 15 15 15 15 15
SELECT * FROM MyRestaurants;
.print

-- 5d
-- I did a,b,c with header on (setting up at the very beginning), 
-- so I'll just do the same thing with header off.
.header off
.mode csv
SELECT * FROM MyRestaurants;
.print

.mode list
.separator "|"
SELECT * FROM MyRestaurants;
.print

.mode column
.width 15 15 15 15 15
SELECT * FROM MyRestaurants;
.print

-- Set the header back for the nicer format
.header on

-- 6
SELECT *, 
CASE WHEN iLike = 1 THEN 'I liked it'
WHEN iLike = 0 THEN 'I hated it'
ELSE 'Neutral' END AS iLikeStr
FROM MyRestaurants;
.print

-- 7
SELECT * 
FROM MyRestaurants
WHERE iLike = 1 AND lastVisit < DATE('now', '-3 month');