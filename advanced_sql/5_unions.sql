-- Unions
-- Get jobs and companies from January

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

-- Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs

UNION ALL

-- Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs
;

/*
UNION ALL Practice Problem:
- Context: We'll be using the three tables (January, February, March) created previously from job_postings_fact using a filter on job__posted_month 
- Get the corresponding skill (name of skill) and skill type (e.g., programming)
for each job posting in Q1 (January to March)
- Includes those jobs without any skills, too
- Why? Look at the skills and the skill type for each job in Q1 that has a salaray > $70,000
*/

SELECT
    jj.*,
    sd.skills AS skill_name,
    sd.type AS skill_type
FROM
    january_jobs AS jj
LEFT JOIN skills_job_dim as sjd
    ON jj.job_id = sjd.job_id
LEFT JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jj.salary_year_avg > 70000

UNION ALL

SELECT
    fj.*,
    sd.skills AS skill_name,
    sd.type AS skill_type
FROM
    february_jobs AS fj
LEFT JOIN skills_job_dim as sjd
    ON fj.job_id = sjd.job_id
LEFT JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    fj.salary_year_avg > 70000

UNION ALL

SELECT
    mj.*,
    sd.skills AS skill_name,
    sd.type AS skill_type
FROM
    march_jobs AS mj
LEFT JOIN skills_job_dim as sjd
    ON mj.job_id = sjd.job_id
LEFT JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    mj.salary_year_avg > 70000
ORDER BY
    job_posted_date ASC
;

-- ChatGPT said the query above works, 
-- but a cleaner way would be to use a CTE + UNION ALL first.

WITH all_jobs_q1 AS (
    SELECT * FROM january_jobs
    UNION ALL
    SELECT * FROM february_jobs
    UNION ALL
    SELECT * FROM march_jobs
)
SELECT 
    aj.*,
    sd.skills AS skill_name,
    sd.type AS skill_type
FROM all_jobs_q1 AS aj
LEFT JOIN skills_job_dim AS sjd ON aj.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE aj.salary_year_avg > 70000
ORDER BY aj.job_posted_date ASC;

-- Practice Problem 8

-- With CTE

WITH q1_job_postings AS
(
    SELECT * FROM january_jobs
    UNION ALL
    SELECT * FROM february_jobs
    UNION ALL
    SELECT * FROM march_jobs
)
SELECT
    q1_job_postings.job_title_short,
    q1_job_postings.job_location,
    q1_job_postings.job_via,
    q1_job_postings.job_posted_date::DATE,
    q1_job_postings.salary_year_avg
FROM
    q1_job_postings
WHERE
    q1_job_postings.salary_year_avg > 70000 AND
    q1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    q1_job_postings.salary_year_avg DESC;


-- With subquery in FROM

SELECT
    q1_job_postings.job_title_short,
    q1_job_postings.job_location,
    q1_job_postings.job_via,
    q1_job_postings.job_posted_date::DATE,
    q1_job_postings.salary_year_avg
FROM (
    SELECT * FROM january_jobs
    UNION ALL
    SELECT * FROM february_jobs
    UNION ALL
    SELECT * FROM march_jobs
) AS q1_job_postings
WHERE
    q1_job_postings.salary_year_avg > 70000 AND
    q1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    q1_job_postings.salary_year_avg DESC;