-- Chun-Wei Chen
-- mijc0517@cs
-- CSE 344 HW8 Problem 3
-- 03/11/14

register s3n://uw-cse344-code/myudfs.jar

-- load the file into Pig
raw = LOAD 's3n://uw-cse344/btc-2010-chunk-000' USING TextLoader AS (line:chararray);

-- parse each line into ntriples
ntriples = FOREACH raw GENERATE FLATTEN(myudfs.RDFSplit3(line)) AS (subject:chararray,predicate:chararray,object:chararray);

-- filter the subjects that match the string pattern '.*rdfabout\\.com.*'
filtered_subjects = FILTER ntriples BY (subject matches '.*rdfabout\\.com.*');

-- generate a copy of filtered_subject in order to join
filtered_subjects_copy = FOREACH filtered_subjects GENERATE $0 AS subject2:chararray, $1 AS predicate2:chararray, $2 AS object2:chararray;

-- join by object = subject2 to get all length two chains 
-- (duplicates are dropped automatically by newer version of Pig)
length_two_chains = JOIN filtered_subjects BY object, filtered_subjects_copy BY subject2;

-- just to be compatible with older version of pig, although we are using the newer version
distinct_length_two_chains = DISTINCT length_two_chains;

-- sort the result by the predicate from the first copy
distinct_length_two_chains_ordered = ORDER distinct_length_two_chains BY (predicate);

-- store the result
STORE distinct_length_two_chains_ordered INTO '/user/hadoop/p3' USING PigStorage();
