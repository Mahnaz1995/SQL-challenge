-- Create 'employees' table
CREATE TABLE employees(
	emp_no INTEGER PRIMARY KEY,
	emp_title_id VARCHAR(10) NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id),
	birth_date DATE NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	sex VARCHAR(1) NOT NULL,
	hire_date DATE NOT NULL);

-- View table
SELECT * FROM employees;

-- Create 'departments' table
CREATE TABLE departments (
	dept_no VARCHAR(10) PRIMARY KEY,
	dept_name VARCHAR(50) NOT NULL
);

-- View table
SELECT * FROM departments;

-- Create 'dept_emp' table
CREATE TABLE dept_emp (
emp_no INTEGER NOT NULL, FOREIGN KEY (emp_no) REFERENCES employee(emp_no),
dept_no VARCHAR(10)NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES department(dept_no));

-- View table
SELECT * FROM dept_emp;

-- Create 'dept_manager' table
CREATE TABLE dept_manager (dept_no VARCHAR(10) NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	emp_no INTEGER PRIMARY KEY,
		FOREIGN KEY (emp_no) REFERENCES employees(emp_no));

-- View table
SELECT * FROM dept_manager;

-- Create 'salaries' table
CREATE TABLE salaries (	emp_no INTEGER PRIMARY KEY, FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	salary INTEGER NOT NULL);

-- View table
SELECT * FROM salaries;

-- Create 'titles' table
CREATE TABLE titles (
	title_id VARCHAR(10),
	title VARCHAR(50));

-- View table
SELECT * FROM titles;

-- Analysis Query

-- 1. Emp_no, last_name, first_name, sex, salary each employee

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
	FROM salaries
	INNER JOIN employees
	ON employees.emp_no = salaries.emp_no;

-- 2. First_name, Last_name, hire_date = 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE date_part('year',hire_date) = 1986

-- 3. Manager for each depart - department nmbr, depart name, emp_no, last_name, first_name
SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM dept_manager dm
INNER JOIN departments d
ON dm.dept_no = d.dept_no
INNER JOIN employees e
ON dm.emp_no = e.emp_no;

-- 4. Each employee - emp_no, last_name, first_name, dept_no, dept_name
SELECT e.emp_no, e.last_name, e.first_name, de.dept_no,
	(SELECT d.dept_name
	FROM departments d
	WHERE de.dept_no = d.dept_no)
FROM employees e
INNER JOIN dept_emp de
ON e.emp_no = de.emp_no;

-- 5. first_name, last_name, sex of FN = Hercules and LN begins 'B'
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';


-- 6. Sales department - emp_no, last_name, first_name
SELECT de.emp_no, e.last_name, e.first_name
FROM dept_emp de
INNER JOIN employees e
ON de.emp_no = e.emp_no
WHERE de.dept_no = 'd007';


-- 7. Sales and Dev departments - emp_no, last_name, first_name, dept_name
SELECT de.emp_no, e.last_name, e.first_name,
	(SELECT d.dept_name
	FROM departments d
	WHERE de.dept_no = d.dept_no)
FROM dept_emp de
INNER JOIN employees e
ON de.emp_no = e.emp_no
WHERE de.dept_no = 'd007' -- Sales department
OR de.dept_no = 'd005'; -- Dev department


-- 8. Count of surname DESC
SELECT last_name, COUNT(last_name) AS "Count of Last Name"
FROM employees
GROUP BY last_name
ORDER BY "Count of Last Name" DESC;

