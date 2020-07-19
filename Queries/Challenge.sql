-- Query for employees born between 1952-1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
-- Query for employees born between 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31'
-- Query for employees born between 1953
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31'
-- Query for employees born between 1954
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31'
-- Query for employees born between 1955
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31'
-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31'); 
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Create a new table with the eligible employees for retirement
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Look at the retirement table
SELECT *
FROM retirement_info
-- Drop the retirement table to recreate it
DROP TABLE retirement_info;
-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;
-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;
-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;
-- Simplifying the code using Aliases 
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date 
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
Select *
from current_emp
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO emp_by_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
Select *
From emp_by_dept
SELECT * FROM salaries
ORDER BY to_date DESC;
drop table retirement_info cascade;
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	      AND (de.to_date = '9999-01-01');
select * 
from emp_info
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
select * 
from manager_info
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);
select *
from retirement_info
select ri.emp_no,
ri.first_name,
ri.last_name,
d.dept_name
from retirement_info as ri
Inner Join dept_emp as de
On (ri.emp_no = de.emp_no)
Inner Join departments as d
on (de.dept_no = d.dept_no)
where d.dept_name In ('Sales','Development')
Select e.emp_no, concat(e.first_name,' ', e.last_name) as Name,ti.Title, ti.From_Date, s.Salary
Into Retiring_titles
from emp_info as e
Inner Join Titles as ti
On (e.emp_no = ti.emp_no)
Inner Join Salaries as s
On (e.emp_no = s.emp_no)
Group By ti.title,e.emp_no, name,s.Salary,ti.From_Date
select * from retiring_titles
-- Partition the data to show only most recent title per employee
SELECT  emp_no,  Name,Title, From_Date, Salary
INTO latest_titles
FROM 
(SELECT emp_no,  Name,Title, From_Date, Salary,
 ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
 FROM retiring_titles) tmp WHERE rn = 1
ORDER BY emp_no;
select * from latest_titles
select 
from employees
-- List of employees eligible for mentorship
SELECT emp.emp_no,
		emp.first_name,
		emp.last_name,
		titles.title,
		titles.from_date,
		titles.to_date
INTO mentors_list
FROM employees as emp LEFT JOIN titles
		ON (titles.emp_no = emp.emp_no)
	WHERE (titles.to_date = '9999-01-01')
	AND (emp.birth_date BETWEEN '1965-01-01' AND '1965-12-31');
select *
From mentors_list