--******************* HAVING CLAUSE *******************

-- Similar to WHERE it helps to apply conditions, but HAVING works with groups.
-- Having clause is only used with the SELECT clause.
-- Having clause is generally used after GROUP BY.   
-- In the query, ORDER BY is to be placed after the HAVING clause, if any.

--Let's try "Where" first to understand why we need "Having" clause
--In this example, we try to find amount of jobtitles which are greater than 1
SELECT JobTitle, COUNT(JobTitle)
FROM EmployeeSalary
WHERE COUNT(JobTitle)>1 
GROUP BY JobTitle
--It does not work. Instead, it warns us to use HAVING clause

--Let's try Having clause
--Since it is dependant on Group By, we can use it after Group By.
SELECT JobTitle, COUNT(JobTitle)
FROM EmployeeSalary
GROUP BY JobTitle
HAVING COUNT(JobTitle)>1 --Result: Accountant 2 and Salseman 4

--Find JobTitles with Average Salary greater than 45000
SELECT JobTitle, AVG(Salary)
FROM EmployeeSalary
GROUP BY JobTitle
HAVING AVG(Salary)>45000
ORDER BY AVG(Salary)

-- Jobtitles with Average Age greater than 30
SELECT JobTitle, AVG(Age)
FROM EmployeeDemographics 
JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING AVG(Age)>30
ORDER BY AVG(Age)

--Display the Jobtitles where the sum of salaries is 60000 or more
SELECT JobTitle, SUM(Salary) as Salary
FROM EmployeeSalary
GROUP BY JobTitle
HAVING SUM(Salary) >= 60000

-- Jobtitle having Total Salary between 45000 and 60000--Exclude Null Jobtitles
SELECT JobTitle, SUM(Salary)
FROM EmployeeSalary
WHERE JobTitle is NOT NULL
GROUP BY JobTitle
HAVING SUM(salary) BETWEEN 40000 AND 60000
ORDER BY SUM(Salary)

--Find the Jobs with min salary equal and greater than 40000
SELECT JobTitle, MIN(Salary)
FROM EmployeeDemographics e
INNER JOIN EmployeeSalary s 
	ON e.EmployeeID= s.EmployeeID -- e and s are aliases here
GROUP BY JobTitle
HAVING MIN(Salary) >= 40000
ORDER BY MIN(Salary)
--We could use EmployeeSalary table alone without joining the tables. But, using Inner Join, we excluded NULL JobTitle 

