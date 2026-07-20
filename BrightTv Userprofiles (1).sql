-- Databricks notebook source

----------------------------------------------------------------------------
-- I wanted to see the whole table before I start doing any analysis on it
-----------------------------------------------------------------------------
SELECT*
FROM workspace.default.userprofiles
LIMIT 10;
-----------------------------------------------------------
-- checking for duplicates in my data
-----------------------------------------------------------
SELECT UserID,
COUNT(*) AS duplicate_count
FROM    workspace.default.userprofiles
GROUP BY UserID
HAVING COUNT(*) > 1;
-----------------------------------------------------------
-- I am checking the size of the data
------------------------------------------------------------
SELECT COUNT(*) AS number_of_rows,
COUNT(DISTINCT UserID) AS number_subs
FROM workspace.default.userprofiles;
--------------------------------------------------------------
-- Are the any rows where useRID is NULL
--------------------------------------------------------------
SELECT COUNT(*) AS cnt
FROM workspace.default.userprofiles
WHERE UserID IS NULL;
SELECT DISTINCT UserID
FROM workspace.default.userprofiles;
---------------------------------------------------------
--Gender Checks
---------------------------------------------------------
SELECT DISTINCT gender
FROM workspace.default.userprofiles;
SELECT COUNT(*)
FROM workspace.default.userprofiles
WHERE gender=' ';
SELECT
COUNT(DISTINCT userid) AS subs,
CASE
WHEN gender =' ' THEN 'None'
ELSE gender
END AS Gender
FROM workspace.default.userprofiles
GROUP BY Gender;
---------------------------------------------------------
--Race Checks
---------------------------------------------------------
SELECT COUNT(*) AS num_rows
FROM workspace.default.userprofiles
WHERE Race IS NULL;
SELECT DISTINCT Race
FROM workspace.default.userprofiles;
SELECT DISTINCT
CASE
WHEN Race='other' THEN 'None'
WHEN Race=' ' THEN 'None'
ELSE Race
END AS Race
FROM workspace.default.userprofiles;
---------------------------------------------------------
--Province Checks
---------------------------------------------------------
SELECT DISTINCT Province
FROM workspace.default.userprofiles;
SELECT DISTINCT
CASE
WHEN Province=' ' THEN 'Uncategorized'
WHEN Province='None' THEN 'Uncategorized'
ELSE Province
END AS Region
FROM workspace.default.userprofiles;
---------------------------------------------------------
--Age
---------------------------------------------------------
SELECT MIN(Age) AS min_age, --- = 0
MAX(Age) AS max_age -- = 114
FROM workspace.default.userprofiles;
SELECT COUNT(*) AS cnt
FROM workspace.default.userprofiles
WHERE age IS NULL;
WITH user_profiles AS (
SELECT UserID,
CASE
WHEN Province=' ' THEN 'Uncategorized'
WHEN Province='None' THEN 'Uncategorized'
ELSE Province
END AS Region,
age,
CASE
WHEN age = 0 THEN 'Infants'
WHEN age BETWEEN 1 AND 12 THEN 'Kids'
WHEN age BETWEEN 13 AND 19 THEN 'Teenager'
WHEN age BETWEEN 20 AND 35 THEN 'Youth'
WHEN age BETWEEN 36 AND 50 THEN 'Adult'
WHEN age BETWEEN 51 AND 65 THEN 'Elder'
WHEN age >65 THEN 'Pensioner'
END AS age_groups,
CASE
WHEN (email IS NOT NULL) OR (email=' ') OR (email NOT IN ('None')) THEN 1
ELSE 0
END AS email_flag,
CASE
WHEN `Social Media Handle` IS NOT NULL OR `Social Media Handle`=' ' OR `Social Media Handle` NOT IN ('None') THEN 1
ELSE 0
END AS sm_flag,
CASE
WHEN Race='other' THEN 'None'
WHEN Race=' ' THEN 'None'
ELSE Race
END AS Race,
CASE
WHEN gender =' ' THEN 'None'
ELSE gender
END AS Gender
FROM workspace.default.userprofiles
)
SELECT * FROM user_profiles;
