/*
Question: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for data analyst roles.
- Concentrates on remote postions with specified salaries.
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
  offering strategic insights fro career development in data anlaysis.
*/

WITH skills_demand_cte AS (
    SELECT
       sd.skill_id,
       sd.skills,
       COUNT(jpf.job_id) AS demand_count
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst' AND
        jpf.salary_year_avg IS NOT NULL AND
        jpf.job_work_from_home = true
    GROUP BY 
        sd.skill_id
),
average_salary_cte AS (
    SELECT
        sd.skill_id,
        sd.skills,
        ROUND(AVG(jpf.salary_year_avg), 0) AS average_salary
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst' AND
        jpf.salary_year_avg IS NOT NULL AND
        jpf.job_work_from_home = true
    GROUP BY 
        sd.skill_id
)
SELECT
    skills_demand_cte.skill_id,
    skills_demand_cte.skills,
    skills_demand_cte.demand_count,
    average_salary_cte.average_salary
FROM skills_demand_cte
INNER JOIN average_salary_cte
    ON skills_demand_cte.skill_id = average_salary_cte.skill_id
WHERE
    skills_demand_cte.demand_count > 10
ORDER BY
    average_salary_cte.average_salary DESC,
    skills_demand_cte.demand_count DESC
LIMIT 25
;

-- Rewriting this same query more concisely:

SELECT
    sd.skill_id,
    sd.skills,
    COUNT(jpf.job_id) AS demand_count,
    ROUND(AVG(jpf.salary_year_avg), 0) AS average_salary
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst' AND
    jpf.salary_year_avg IS NOT NULL AND
    jpf.job_work_from_home = true    
GROUP BY
    sd.skill_id
HAVING
    COUNT(jpf.job_id) > 10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25
;