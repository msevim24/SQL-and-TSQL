--**************** PARTITION BY *******************

--The PARTITION BY is combined with OVER() and windows functions to calculate aggregated values. 
--This is very similar to GROUP BY and aggregate functions. Similarity: Both are used to return aggregated values.
--Difference: Using a GROUP BY clause collapses original rows; for that reason, you cannot access the original values later in the query. 
--On the other hand, using a PARTITION BY clause keeps original values while also allowing us to produce aggregated values.
--When you use a PARTITION BY, the row-level details are preserved and not collapsed. 
--That is, you still have the original row-level details as well as the aggregated values at your disposal. 
--All aggregate functions can be used as window functions.
--Using standard aggregate functions as window functions with the OVER() keyword allows us to combine aggregated values and keep the values from the original rows.

--Aggregate function with GROUP BY
SELECT Gender, COUNT(Gender)
FROM EmployeeDemographics AS D
JOIN EmployeeSalary AS S
	ON D.EmployeeID=S.EmployeeID
GROUP BY Gender --(3 Female, 6 Male)

--Let's try to use GROUP BY and aggregate funciton by displaying other columns too
SELECT FirstName, LastName, Gender, Salary, COUNT(Gender)
FROM EmployeeDemographics AS D
JOIN EmployeeSalary AS S
	ON D.EmployeeID=S.EmployeeID
GROUP BY FirstName, LastName, Gender, Salary
--It does not display the count of Gender. It shows 1 for each name

--Let's try it with PARTITION BY
SELECT FirstName, LastName, Gender, Salary, 
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender --Aggregate function OVER (PARTITION BY group_name)
FROM EmployeeDemographics AS D
JOIN EmployeeSalary AS S
	ON D.EmployeeID=S.EmployeeID
--It worked. We keep the columns and also see the count of Gender (3 Female, 6 Male)

--Compare the employees Salary with AVG Salary according to JobTitle
SELECT FirstName, LastName, Gender, JobTitle, Salary, 
AVG(Salary) OVER (PARTITION BY JobTitle) as AvgSalary 
FROM EmployeeDemographics AS D
JOIN EmployeeSalary AS S
	ON D.EmployeeID=S.EmployeeID

--GROUP BY does not provide the same information
SELECT FirstName, LastName, Gender, JobTitle, Salary, AVG(Salary) AS AvgSalary
FROM EmployeeDemographics AS D
JOIN EmployeeSalary AS S
	ON D.EmployeeID=S.EmployeeID
GROUP BY  FirstName, LastName, Gender, JobTitle, Salary
--As seen, the salary and Average salary columns display the same info

--So, it is better to use GROUP BY with the grouped column
SELECT JobTitle, AVG(Salary) AS AvgSalary 
FROM EmployeeDemographics AS D
JOIN EmployeeSalary AS S
	ON D.EmployeeID=S.EmployeeID
GROUP BY JobTitle
