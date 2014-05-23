-- Chun-Wei Chen
-- 1267040
-- mijc0517@cs
-- CSE344 HW2
-- 01/25/14
--------------------------------------------------------------------------------
-- hw2-queries.sql
-- Part C: SQL queries
--------------------------------------------------------------------------------

-- query 1 (13 rows)
SELECT a.fname, a.lname 
FROM ACTOR a, CASTS c, MOVIE m 
WHERE a.id = c.pid AND m.id = c.mid AND m.name = 'Officer 444';

-- query 2 (113 rows)
SELECT d.fname, d.lname, m.name, m.year 
FROM MOVIE m, DIRECTORS d, MOVIE_DIRECTORS md, GENRE g 
WHERE m.id = md.mid AND md.did = d.id AND m.id = g.mid 
AND g.genre = 'Film-Noir' AND (m.year % 4 = 0);

-- query 3 (53 rows)
SELECT DISTINCT a.fname, a.lname 
FROM ACTOR a, MOVIE m1, MOVIE m2, CASTS c1, CASTS c2 
WHERE a.id = c1.pid AND a.id = c2.pid 
AND c1.mid = m1.id AND c2.mid = m2.id 
AND m1.year < 1900 AND m2.year > 2000;

-- Investigation
-- I saw there are some records in movie.txt with empty value in year field,
-- so I assumed that the empty values cause this result to happen. And then I
-- did query below, and found that the record with empty year field showed up.
SELECT * FROM MOVIE WHERE year > 20000 LIMIT 10;

-- When SQLite imports data from the file, it interprets the empty value in year field
-- as an empty string, which is evaluated to be greater than any numerical value,
-- instead of a null value. That's why (m1.year < 1900 AND m2.year > 2000) is 
-- possibly true in the query for this question.

-- comment: -3 More explanations. Empty values do not account for all entries.

-- query 4 (47 rows)
SELECT d.fname, d.lname, COUNT(*) as m_cnt 
FROM DIRECTORS d, MOVIE_DIRECTORS md 
WHERE d.id = md.did 
GROUP BY d.id, d.fname, d.lname 
HAVING COUNT(*) >= 500
ORDER BY m_cnt DESC;
-- lost 5 pts because I didn't put d.fname, d.lname in GROUP BY

-- query 5 (24 rows)
SELECT a.fname, a.lname, COUNT(DISTINCT c.role) 
FROM ACTOR a, MOVIE m, CASTS c 
WHERE a.id = c.pid AND c.mid = m.id AND m.year = 2010 
GROUP BY a.id, m.id, a.fname, a.lname 
HAVING COUNT(DISTINCT c.role) >= 5;
-- lost 5 pts because I didn't put d.fname, d.lname in GROUP BY