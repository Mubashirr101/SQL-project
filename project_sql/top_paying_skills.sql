/*
AIM: Find what skills are required for top paying data analyst jobs
    - we can use the 10 top_paying_jobs query 
    - list the skills required for those jobs
    - helps provide understanding for the demand of skills in the highest paying roles
*/

-- Solution:
-- with subquries
SELECT 
    top_10_jobs.*,
    skills_dim.skills
FROM (
     SELECT  
        job_id,
        job_title,
        name AS company_name,
        salary_year_avg
        
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE   
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
) AS top_10_jobs
LEFT JOIN skills_job_dim ON skills_job_dim.job_id = top_10_jobs.job_id
LEFT JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE skills_dim.skills IS NOT NULL
ORDER BY salary_year_avg DESC
;