/*
OBJECTIVE:
Identify the highest-paying skills for Data Analyst positions
in Germany and remote jobs.

The query:
1. Filters Data Analyst job postings with available annual salaries.
2. Extracts the skills associated with each job posting.
3. Calculates the number of job postings associated with each skill.
4. Calculates the average annual salary for each skill.
5. Excludes skills appearing in 50 or fewer job postings.
6. Ranks skills by their average annual salary in descending order.

The results help compare skill demand (job count) against
earning potential (average annual salary).
*/

WITH top_paying_jobs AS(
    SELECT  job_id,
            job_title,
            name AS company_name,
            salary_year_avg
    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE job_title_short = 'Data Analyst' AND 
        job_location IN ('Germany', 'Anywhere') AND 
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
)

SELECT
        Count(top_paying_jobs.job_title) AS job_count,
        skills,
        ROUND(AVG(salary_year_avg),0) AS anual_salary_skill_avg
FROM top_paying_jobs
LEFT JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
Where skills IS NOT NULL
GROUP BY skills_dim.skills
HAVING  Count(top_paying_jobs.job_title) > 50
ORDER BY anual_salary_skill_avg DESC

/*  Key insights
- Python has the highest average annual salary ($101,397).
- SQL has the highest job count (398), indicating the greatest demand in this dataset.
- R ranks second in salary ($100,499), despite appearing in only 148 job listings.
- Excel and PowerPoint have the lowest average salaries ($87,322 and $88,701).
- higher job demand does not necessarily translate into higher salaries.
- Python offers a strong combination of high salary and job demand.

[
  {
    "job_count": "236",
    "skills": "python",
    "anual_salary_skill_avg": "101397"
  },
  {
    "job_count": "148",
    "skills": "r",
    "anual_salary_skill_avg": "100499"
  },
  {
    "job_count": "230",
    "skills": "tableau",
    "anual_salary_skill_avg": "99288"
  },
  {
    "job_count": "126",
    "skills": "sas",
    "anual_salary_skill_avg": "98902"
  },
  {
    "job_count": "111",
    "skills": "power bi",
    "anual_salary_skill_avg": "97555"
  },
  {
    "job_count": "398",
    "skills": "sql",
    "anual_salary_skill_avg": "97237"
  },
  {
    "job_count": "58",
    "skills": "powerpoint",
    "anual_salary_skill_avg": "88701"
  },
  {
    "job_count": "258",
    "skills": "excel",
    "anual_salary_skill_avg": "87322"
  }
]
*/
