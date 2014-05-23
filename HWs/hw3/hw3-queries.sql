-- Chun-Wei Chen
-- 1267040
-- mijc0517@cs
-- CSE344 HW3
-- 02/04/14

-- Part B: SQL QUERIES

-- 1 (137 rows)
SELECT a.lname, a.fname, m.name, c2.role 
FROM ACTOR a, MOVIE m, CASTS c2, (SELECT c1.pid, c1.mid 
                                  FROM CASTS c1 
                                  GROUP BY c1.pid, c1.mid 
                                  HAVING COUNT(DISTINCT c1.role) >= 5) AS res 
WHERE a.id = c2.pid AND m.id = c2.mid 
AND c2.pid = res.pid AND c2.mid = res.mid AND m.year = 2010 
ORDER BY a.lname, a.fname;

-- 2 (129 rows)
SELECT m.year, COUNT(*)
FROM MOVIE m 
WHERE m.id NOT IN (SELECT c.mid 
                   FROM ACTOR a, CASTS c 
                   WHERE a.id = c.pid AND a.gender != 'F') 
GROUP BY m.year 
ORDER BY m.year;

-- 3 (128 rows)
SELECT x.year, (x.cnt * 100.0 / y.total), y.total  
FROM (SELECT m.year, COUNT(*) AS cnt
      FROM MOVIE m 
      WHERE m.id NOT IN (SELECT c.mid 
                         FROM ACTOR a, CASTS c 
                         WHERE a.id = c.pid AND a.gender != 'F') 
      GROUP BY m.year) AS x, 
     (SELECT m.year, COUNT(*) AS total 
      FROM MOVIE m 
      GROUP BY m.year) AS y 
WHERE x.year = y.year 
ORDER BY x.year;

-- 4 (1 row, cast size: 1298)
SELECT m2.name, COUNT(DISTINCT c2.pid) AS cast_size 
FROM MOVIE m2, CASTS c2 
WHERE m2.id = c2.mid 
GROUP BY m2.id, m2.name 
HAVING COUNT(DISTINCT c2.pid) >= ALL (SELECT COUNT(DISTINCT c1.pid) 
                                      FROM MOVIE m1, CASTS c1 
                                      WHERE m1.id = c1.mid 
                                      GROUP BY m1.id);

-- 5 (1 row, number of movies: 457481)
SELECT y1.year, COUNT(m1.id) AS total
FROM MOVIE m1, (SELECT DISTINCT m2.year FROM MOVIE m2) AS y1
WHERE m1.year >= y1.year AND m1.year < y1.year + 10 
GROUP BY y1.year 
HAVING COUNT(m1.id) >= ALL (SELECT COUNT(m3.id) 
                            FROM MOVIE m3, (SELECT DISTINCT m4.year 
                                            FROM MOVIE m4) AS y2 
                            WHERE m3.year >= y2.year 
                            AND m3.year < y2.year + 10 
                            GROUP BY y2.year);

-- 6 (1 row, number of characters with Bacon number 2: 521876)
SELECT COUNT(DISTINCT c3.pid) AS total 
FROM ACTOR a2, CASTS c1_2, CASTS c2_2, CASTS c2_3, CASTS c3 
WHERE a2.id = c1_2.pid AND a2.fname = 'Kevin' AND a2.lname = 'Bacon' 
AND c1_2.mid = c2_2.mid AND c2_2.pid = c2_3.pid AND c2_3.mid = c3.mid 
AND c3.pid NOT IN (SELECT c2_1.pid 
				   FROM ACTOR a1, CASTS c1_1, CASTS c2_1 
				   WHERE a1.id = c1_1.pid AND a1.fname = 'Kevin' 
				   AND a1.lname = 'Bacon' AND c1_1.mid = c2_1.mid);

-- Part C: Using a Cloud Service

-- By doing this assignment, I think the DBMS cloud service is great since 
-- we don't need to keep the space-consuming database file (about 1 GB after 
-- I've done with HW2) on or disk in order to do the queries. And I believe 
-- the computing power of the cloud service is much better than usual 
-- PCs or laptops, so some time-consuming queries can be done in a much 
-- shorter time. The most important pros of the DBMS cloud service is that 
-- multiple clients can connect to the same database and do some queries 
-- simultaneously. I little cons of the DBMS cloud service is that we need 
-- to have Internet connection in order to query the database.
-- Despite some of the pros of the DBMS cloud service I just mentioned, 
-- I don't think the idea of offering a DBMS as a service in a public cloud 
-- is good unless the following cons are addressed appropriately. First, 
-- when the cloud servers are down, the clients won't be able to do the query 
-- since the database is stored in the cloud service. So the cloud service 
-- provider needs to find a way to make the cloud service available almost 
-- every moment. Second, since the data is stored in the cloud service, the 
-- cloud service provider needs to ensure that people who have no permission 
-- won't be able to access the data, and the cloud service provider must not 
-- disclose the data to others. If the cloud service provider deals with these 
-- two cons properly, I think offering a DBMS as a service in a public cloud 
-- is a good idea.