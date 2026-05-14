/*
AIM: Find the most in-demand skills for data analysts
    - join job postings using inner joins 
    - identify the top 5 in-demand skills for a data analyst
    - To highlight insights about the most valuable skills for job seekers
*/

-- Solution:

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' 
GROUP BY 
    skills
ORDER BY demand_count DESC
LIMIT 5;