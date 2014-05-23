-- Chun-Wei Chen
-- mijc0517@cs
-- CSE 344 HW8 Problem 4
-- 03/11/14

register s3n://uw-cse344-code/myudfs.jar

-- set all the MapReduce jobs that get launched to use 50 reducers
SET default_parallel 50;

-- load the file into Pig
raw = LOAD 's3n://uw-cse344' USING TextLoader AS (line:chararray);

-- parse each line into ntriples
ntriples = FOREACH raw GENERATE FLATTEN(myudfs.RDFSplit3(line)) AS (subject:chararray,predicate:chararray,object:chararray);

-- group the n-triples by subject column
subjects = GROUP ntriples BY (subject);

-- generate a intermediate state that hold tuples; each contains a subject and # of tuples associated with it
count_by_subject = FOREACH subjects GENERATE FLATTEN($0), COUNT($1) AS tuple_count;

-- group the count_by_subject by # of tuples
group_subject_by_count = GROUP count_by_subject BY (tuple_count);

-- generate the (x, y) we want, ((x,y): y subjects each had x tuples associated with them after we group by subject)
count_subject_by_count = FOREACH group_subject_by_count GENERATE FLATTEN($0) AS tuple_count, COUNT($1) AS num_subject;

-- sort the result by the # of tuples
count_subject_by_count_ordered = ORDER count_subject_by_count BY (tuple_count);

-- store the result
STORE count_subject_by_count_ordered INTO '/user/hadoop/p4' USING PigStorage();
