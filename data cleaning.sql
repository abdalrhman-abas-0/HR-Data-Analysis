CREATE TABLE original_hr
(
    id TEXT,
    first_name TEXT,
    last_name TEXT,
    birthdate TEXT,
    gender TEXT,
    race TEXT,
    department TEXT,
    jobtitle TEXT,
    "location" TEXT,
    hire_date TEXT,
    termdate TEXT,
    location_city TEXT,
    location_state TEXT
);

COPY original_hr
FROM 'D:\Documents\Data Analysis\projects\SQL _ PowerBI Portfolio Project for Data Analysts(720P_60FPS)\Human Resources.csv' 
DELIMITER ',' CSV HEADER
NULL '';
	
SELECT *
FROM original_hr;

SELECT *
INTO TABLE hr 
FROM original_hr;

SELECT column_name,
	data_type,
	table_schema
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'hr';

ALTER TABLE hr
RENAME COLUMN jobtitle TO job_title;

ALTER TABLE hr
RENAME COLUMN birthdate TO birth_date;

ALTER TABLE hr
RENAME COLUMN termdate TO term_date;


SELECT *
FROM hr;

UPDATE hr
SET birth_date = to_date(birth_date, 'mm/dd/yyyy');

ALTER TABLE hr
ALTER COLUMN birth_date TYPE DATE
USING birth_date :: DATE;

UPDATE hr
SET hire_date = to_date(hire_date, 'mm/dd/yyyy');

ALTER TABLE hr
ALTER COLUMN hire_date TYPE DATE
USING hire_date :: DATE;

UPDATE hr
SET term_date = date(term_date);

ALTER TABLE hr
ALTER COLUMN term_date TYPE DATE
USING term_date :: DATE;

ALTER TABLE hr
ADD COLUMN age INT;

UPDATE hr
SET age = ROUND(((DATE(NOW())- birth_date)/365.25),0);


SELECT MAX(age),
	MIN(age)
FROM hr;

SELECT *
FROM hr;

-- found some records with termination dates after 2020 "the current year of the data"
SELECT *
FROM hr
WHERE TO_CHAR(DATE_TRUNC('year', term_date)::DATE, 'yyyy')::INT > 2020

CREATE TABLE hr2
AS TABLE hr


DELETE FROM hr2
WHERE TO_CHAR(DATE_TRUNC('year', term_date)::DATE, 'yyyy')::INT > 2020
;

SELECT COUNT(*)
FROM hr;

SELECT COUNT(*)
FROM hr2;

DROP TABLE hr;

ALTER TABLE hr2 
RENAME TO hr;