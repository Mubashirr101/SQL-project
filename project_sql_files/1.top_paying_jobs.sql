/*
AIM: Find top paying data analyst jobs
    - identify top 10 highest paying data analyst roles that are available remotely
    - focus on job postings with specified salaries (remove nulls)
    - To highlight top paying opportunities for data analysts, offering insights
*/

-- Solution:

SELECT * FROM job_postings_fact LIMIT 5;

-- selected the relevant cols and filtered to make sure only remote data analyst jobs are chosen

SELECT  
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
WHERE   
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere';

-- now removing rows with null sals

SELECT  
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
WHERE   
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL;

-- now we get the top 10 highest paying jobs, also which company, also removing other non-imp cols

SELECT  
    job_id,
    job_title,
    name AS company_name,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE   
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;