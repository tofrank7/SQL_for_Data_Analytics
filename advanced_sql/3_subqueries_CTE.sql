-- Subqueries

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;


SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
    ORDER BY
        company_id
);

-- CTEs

WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)
SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN company_job_count
    ON company_dim.company_id = company_job_count.company_id
ORDER BY
    total_jobs DESC;

-- Practice Problem 7
/*
Find the count of the number of remote job postings per skill
    - Display the top 5 skills by their demand in remote jobs
    - Include skill ID, name, and count of postings requiring the skill

First, build a CTE that collects number of job postings per skill. 
Join job_postings_fact table and skills_job_dim table to do this.
Because we're trying to get the count of jobs that actually exist, we use inner join.
Once we have this temporary result set, we can combine it with our skills_dim table.
*/

WITH skill_count_CTE AS (
    SELECT
        sjd.skill_id,
        COUNT(jpf.job_id) AS skill_count
    FROM
        skills_job_dim AS sjd
    INNER JOIN job_postings_fact AS jpf
        ON sjd.job_id = jpf.job_id
    WHERE
        jpf.job_work_from_home = true AND 
        jpf.job_title_short = 'Data Analyst'
    GROUP BY
        sjd.skill_id
)
SELECT 
    scc.skill_id AS skill_id,
    sd.skills AS skill_name,
    scc.skill_count AS skill_count
FROM 
    skill_count_CTE AS scc
INNER JOIN skills_dim AS sd
    ON scc.skill_id = sd.skill_id
ORDER BY 
    skill_count DESC
LIMIT 5
;