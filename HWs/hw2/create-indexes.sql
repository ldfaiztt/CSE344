-- Chun-Wei Chen
-- 1267040
-- mijc0517@cs
-- CSE344 HW2
-- 01/25/14
--------------------------------------------------------------------------------
-- create-indexes.sql
-- Part B: Choosing indexes
--------------------------------------------------------------------------------

-- in order to speed up the join in query 1, 3, 5
CREATE UNIQUE INDEX actor_id ON ACTOR(id);

-- in order to speed up the join in query 1, 2, 3, 5
CREATE UNIQUE INDEX movie_id ON MOVIE(id);

-- in order to speed up the join in query 2, 4
CREATE UNIQUE INDEX directors_id ON DIRECTORS(id);

-- in order to speed up the selection in query 2, 3, 5
CREATE INDEX moive_year ON MOVIE(year);

-- in order to speed up the join in query 1, 3, 5
CREATE INDEX casts_pid ON CASTS(pid);

-- in order to speed up the join in query 1, 3, 5
CREATE INDEX casts_mid ON CASTS(mid);

-- in order to speed up the join in query 2, 4
CREATE INDEX movie_directors_mid ON MOVIE_DIRECTORS(mid);

-- in order to speed up the join in query 2, 4
CREATE INDEX movie_directors_did ON MOVIE_DIRECTORS(did);

-- in order to speed up the selection in query 1, 3, 5 
CREATE INDEX actor_lname ON ACTOR(lname);

-- in order to speed up selection in query 1, 2
CREATE INDEX movie_name ON MOVIE(name);

-- in order to speed up the selection in query 2, 4
CREATE INDEX directors_lname ON DIRECTORS(lname);