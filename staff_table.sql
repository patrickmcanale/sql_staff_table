SELECT * 
FROM company_divisions

SELECT * 
FROM company_regions

SELECT * 
FROM staff

--male and female count 

SELECT gender, COUNT(*) 
FROM staff
GROUP BY gender


--count number of departments

SELECT department, COUNT(*) 
FROM staff
GROUP BY department


--min/max salary in each department

SELECT department,MIN(salary) as min_salary, MAX(salary) as max_salary
FROM staff
GROUP BY department

--min/max salary for male/female

SELECT gender ,MIN(salary) as min_salary, MAX(salary) as max_salary
FROM staff
GROUP BY gender

--total salary paid to each department

SELECT department, SUM(salary) as total_salary
FROM staff
GROUP BY department

--total and average salary paid to each department

SELECT department, SUM(salary) as total_salary, 
AVG(salary) as avg_salary
FROM staff
GROUP BY department

--stdevp and varp w/2 decimal

SELECT department, SUM(salary) as total_salary, 
AVG(salary) as avg_salary, 
ROUND(VARP(salary),2) as varp, 
ROUND(STDEVP(salary),2) as stdevp
FROM staff
GROUP BY department

--department starts with 'bo' and sum total salary

SELECT department, SUM(salary) as total_salary
FROM staff
WHERE department LIKE 'Bo%'
GROUP BY department

--department that begins with B and end with Y

SELECT department, SUM(salary) as total_salary
FROM staff
WHERE department LIKE 'B%y'
GROUP BY department

--select job title with assistant

SELECT job_title
FROM staff
WHERE job_title LIKE '%Assistant%'

-- select assistant from job_title

SELECT SUBSTRING(job_title,1,10)
FROM staff
WHERE job_title LIKE 'Assistant%'

--replace assistant with asst.

SELECT REPLACE(job_title,'Assistant','Asst.')
FROM staff
WHERE job_title LIKE 'Assistant%'

--job title starts with e p or s

SELECT job_title
FROM staff
WHERE job_title LIKE '[EPS]%'

--Subqueries

SELECT s1.last_name,s1.salary,s1.department,
(SELECT AVG(salary) FROM staff as s2 WHERE s2.department = s1.department)
FROM staff as s1

--sub select statement

SELECT s1.department,
		AVG(s1.salary)
FROM
		(SELECT department,salary
		FROM staff
		WHERE salary > 100000)as s1
GROUP BY s1.department


--subquery in where clause

SELECT s1.department, s1.last_name, s1.salary
FROM staff as s1
WHERE s1.salary =
				(SELECT MAX(s2.salary)
				FROM staff as s2)

--inner join two tables--returned all but 47 rows

SELECT 
s.last_name,
s.department,
cd.company_division
FROM staff as s
INNER JOIN company_divisions as cd
ON s.department = cd.department

--LEFT join--returns all 1000 rows

SELECT 
s.last_name,
s.department,
cd.company_division
FROM staff as s
LEFT JOIN company_divisions as cd
ON s.department = cd.department


--create a view

CREATE VIEW staff_div_reg as a
SELECT 
s.id,s.last_name,s.email,s.gender,s.department,s.start_date,s.salary,
s.job_title,
s.region_id,
cd.company_division,
cr.company_regions
FROM staff as s
LEFT JOIN company_divisions as cd
ON s.department = cd.company_division
LEFT JOIN company_regions as cr
ON s.region_id = cr.region_id

--from the view

SELECT
company_region,
count(*),
FROM staff_div_reg
GROUP BY company_region
ORDER BY company_region

--window functions

SELECT department,
last_name,
salary,
AVG(salary) OVER(PARTITION BY department)
FROM staff

--first value

SELECT department,
last_name,
salary,
FIRST_VALUE(salary) OVER (Partition by department order by last_name)
from staff

--rank function

SELECT department,
last_name,
salary,
rank() OVER (Partition by department order by salary desc)
from staff

--lag and lead

SELECT department,
last_name,
salary,
lag(salary) OVER (Partition by department order by salary desc)
From staff

SELECT department,
last_name,
salary,
lead(salary) OVER (Partition by department order by salary desc)
From staff

--ntile function

SELECT department,
last_name,
salary,
NTILE(4) OVER (Partition by department order by salary desc)
from staff