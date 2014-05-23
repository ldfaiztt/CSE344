-- Chun-Wei Chen
-- 1267040
-- mijc0517@cs
-- CSE344 HW2
-- 01/25/14
--------------------------------------------------------------------------------
-- create-tables.sql
-- Part A: Importing the IMDB database
--------------------------------------------------------------------------------

PRAGMA foreign_keys=ON;

CREATE TABLE ACTOR
  (id int PRIMARY KEY,
   fname VARCHAR(30),
   lname VARCHAR(30),
   gender VARCHAR(1));

CREATE TABLE MOVIE
  (id int PRIMARY KEY,
   name VARCHAR(150),
   year int);

CREATE TABLE DIRECTORS 
  (id int PRIMARY KEY,
   fname VARCHAR(30),
   lname VARCHAR(30));

CREATE TABLE CASTS
  (pid int REFERENCES ACTOR,
   mid int REFERENCES MOVIE,
   role VARCHAR(50));
 
CREATE TABLE MOVIE_DIRECTORS
  (did int REFERENCES DIRECTORS,
   mid int REFERENCES MOVIE);

CREATE TABLE GENRE
  (mid int,
   genre VARCHAR(50));

.import 'imdb2010/actor.txt' ACTOR
.import 'imdb2010/movie.txt' MOVIE
.import 'imdb2010/directors.txt' DIRECTORS
.import 'imdb2010/casts.txt' CASTS
.import 'imdb2010/movie_directors.txt' MOVIE_DIRECTORS
.import 'imdb2010/genre.txt' GENRE