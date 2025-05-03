
-- 1. What is the ratio of the employees who work from the Onsite Vs Remotely?
SELECT "location",
    COUNT("location") AS employees_count,
    ROUND(
        COUNT("location")::NUMERIC/(
            SELECT COUNT(*)
            FROM hr 
            WHERE term_date IS NULL
        )*100,2
    ) AS employees_percentage
FROM hr 
WHERE term_date IS NULL
GROUP BY 1;



-- 2. What is the distribution of employees across locations by state?
SELECT location_state,
    COUNT(id) AS employees_count
FROM hr 
WHERE term_date IS NULL 
GROUP BY location_state
ORDER BY COUNT(id)  DESC;



-- 3. What is the gender breakdown of employees in the company?
SELECT gender,
    COUNT(gender) AS gender_counts,
    ROUND(
        COUNT(gender)::NUMERIC/(
            SELECT COUNT(*) AS whole_count 
            FROM hr 
            WHERE term_date IS NULL
        )*100,2
    ) AS gender_percentage
FROM hr 
WHERE term_date IS NULL
GROUP BY gender;



-- 4. What is the distribution of the employees age across the company?
SELECT CASE
        WHEN age >= 18 AND age <25 THEN '18-24'
        WHEN age >= 25 AND age <35 THEN '25-34'
        WHEN age >= 35 AND age <44 THEN '35-44'
        WHEN age >= 45 AND age <54 THEN '45-54'
        ELSE '55+'
    END AS age_groups,
    COUNT(id) AS total_count,
    COUNT(id) FILTER(WHERE gender='Male')AS male_count,
    COUNT(id) FILTER(WHERE gender='Female')AS female_counts,
    COUNT(id) FILTER(WHERE gender='Non-Conforming')AS Non_Conforming_counts
FROM hr 
WHERE term_date IS NULL
GROUP BY 1
ORDER BY 2 DESC;




-- 5. What is the distribution of the Ethnicity of the employees across the company?
SELECT race,
    COUNT(race) AS race_count,
    ROUND(
        COUNT(race)::NUMERIC/(
            SELECT COUNT(*)
            FROM hr 
            WHERE term_date IS NULL
        )*100,2
    ) AS race_percentage
FROM hr 
WHERE term_date IS NULL
GROUP BY race
ORDER BY 2 DESC;




-- 6. What is the  distribution of job titles across the departments?
SELECT department,
    job_title,
    COUNT(id) AS total_employees
FROM hr 
WHERE term_date IS NULL
GROUP BY 1,2
ORDER BY 3 DESC;



-- 7. What is the distribution of job titles across the entire company?
SELECT job_title,
    COUNT(job_title) AS job_title_counts
FROM hr 
WHERE term_date IS NULL
GROUP BY 1
ORDER BY 2 DESC;



-- 8. Which department has the highest turnover rate?
SELECT department,
    total_count,
    turner,
    round(turner/total_count::NUMERIC, 3) AS termination_rate
FROM (
    SELECT department,
        sum(
            CASE 
                WHEN term_date IS NOT NULL THEN 1 
                ELSE 0 
            END
        ) AS turner,
        COUNT(*) AS total_count
    FROM hr
    GROUP BY department
) AS turnovers
ORDER BY 4 DESC;



-- 9. How has the company's employee count changed over the years?
WITH hire_term_counts AS (
    SELECT TO_CHAR(DATE_TRUNC('year', hire_date)::DATE, 'yyyy') AS years,
        COUNT(hire_date) AS hires,
        COUNT(term_date) AS terminations,
        COUNT(hire_date)-COUNT(term_date) AS net_new_employees
    FROM hr 
    GROUP BY 1
),
employees_counts_ AS (
    SELECT *,
        SUM(net_new_employees) OVER (ORDER BY years) AS total_employees
    FROM hire_term_counts
),
employees_counts AS (
    SELECT *,
        LAG(total_employees) OVER (ORDER BY years) AS original_count
    FROM employees_counts_
)
SELECT years,
    original_count,
    hires,
    terminations,
    total_employees,
    ROUND(terminations/((original_count+(original_count+net_new_employees))/2)*100:: NUMERIC,2) AS turnover_rate
FROM employees_counts
ORDER BY 1 ;



-- 10. What is the average turner in the hole company?
SELECT avg((term_date-hire_date)/365):: INT AS average_employment_period
FROM hr;



-- 11. What is the tenure distribution for each department?
SELECT department,
    ROUND(avg((term_date-hire_date)/365),0) AS turner_count 
FROM hr
WHERE term_date IS NOT NULL
GROUP BY department
ORDER BY 2 DESC;

