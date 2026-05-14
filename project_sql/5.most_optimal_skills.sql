/*
AIM: Find the most optimal skills to learn
    - they should be high demand and high salary
    - first on all jobs then on remote jobs
    - for data analyst roles
    - It helps to identify and target skills that offer jobs security and most financial benefit
*/

-- Solution:

WITH 
    skills_in_demand AS (
        SELECT 
            skills,
            COUNT(skills_job_dim.job_id) AS demand_count,
            skills_dim.skill_id AS skill_id
        FROM job_postings_fact
        INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
        INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
        WHERE job_title_short = 'Data Analyst' 
        GROUP BY 
            skills_dim.skill_id
    ) ,
 top_paying_skills AS (
        SELECT 
            skills_job_dim.skill_id AS skill_id,
            ROUND(AVG(salary_year_avg),0) AS avg_salary
        FROM job_postings_fact
        INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
        INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
        WHERE 
            job_title_short = 'Data Analyst' AND
            salary_year_avg IS NOT NULL
        GROUP BY 
            skills_job_dim.skill_id
    )

SELECT 
    skills_in_demand.skill_id,
    skills_in_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_in_demand
INNER JOIN top_paying_skills ON skills_in_demand.skill_id = top_paying_skills.skill_id
ORDER BY 
    demand_count DESC,
    avg_salary DESC



-- a bit more concise query

-- 1: With demand in focus
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
ORDER BY 
    demand_count DESC,
    avg_salary DESC

-- 2: With salary in focus
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING 
    COUNT(skills_job_dim.job_id) > 50
ORDER BY 
    avg_salary DESC,
    demand_count DESC