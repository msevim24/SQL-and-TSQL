--********************* SUBQUERIES ****************

--In SQL a Subquery can be simply defined as a query within another query.
--The outer query is called as main query and inner query is called as subquery.
--You can place the Subquery in a number of SQL clauses: WHERE clause, HAVING clause, FROM clause. 
--Subqueries can be used with SELECT, UPDATE, INSERT, DELETE statements along with expression operator. 
--It could be equality operator or comparison operator such as =, >, =, <= and Like operator.
--ORDER BY command cannot be used in a Subquery. GROUPBY command can be used to perform same function as ORDER BY command.
--Use single-row operators with singlerow Subqueries. Use multiple-row operators with multiple-row Subqueries.


--***Subquery in SELECT
SELECT EmployeeID, Salary, 
	(SELECT AVG(Salary) FROM EmployeeSalary) AS AllAvgSalary--The Select statement in the parentheses showing AVG is our subquery
FROM EmployeeSalary
--It displays Average Salary for each Employee

--*** With PARTICION BY
SELECT EmployeeID, Salary, AVG(Salary) OVER () AS AllAvgSalary
FROM EmployeeSalary --The result is the same with the above SELECT statment

--Let's try it using GROUP BY and see whether it works or not
SELECT EmployeeID, Salary, AVG(Salary) AS AllAvgSalary
FROM EmployeeSalary 
GROUP BY EmployeeID, Salary
ORDER BY 1,2 --As seen, it does not give Avg Salary

--***Subquery in FROM
SELECT a.EmployeeID, AllAvgSalary
FROM (SELECT EmployeeID, Salary, AVG(Salary) OVER () AS AllAvgSalary
	  FROM EmployeeSalary) a   --This subquery is our table, like a temp table with alias "a", showing the Avg Salary

--***Subquery in WHERE

--Let's display EmployeeID, JobTitle and Salary from one table and the Employees greater than 30 years old (Age) from another table without joining tables
SELECT EmployeeID, JobTitle, Salary  --Columns from the first table
FROM EmployeeSalary 
WHERE EmployeeID IN ( 
	SELECT EmployeeID		--The query in the parentheses is our subquery showing Employees over 30 years old
	FROM EmployeeDemographics			--Second table
	WHERE Age > 30)
