--******************* JOIN *******************
-- (Inner, Left/Right/Full Outer Join)

--Before joining the tables, lest's add some records with different ids to see the difference between join types.

--FIRST TABLE
INSERT INTO EmployeeDemographics VALUES 
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly', 'Flax', NULL, NULL),
(1013, 'Darryl', 'Phibin', NULL, 'Male')

SELECT * FROM EmployeeDemographics

--SECOND TABLE
INSERT INTO EmployeeSalary VALUES 
(1010, NULL, 47000),
(NULL, 'Salesman', 43000)

SELECT * FROM EmployeeSalary

--*** INNER JOIN ***
--The structure: Table_1 Inner Join Table_2 ON Common columns
-- It returns common ids. So, we cannot see all columns.

SELECT * FROM SQLTutorial.dbo.EmployeeDemographics --DB name is not necesssary here
Inner Join SQLTutorial.dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--Since it shows only common columns, there may be some missing columns 

--*** FULL OUTER JOIN ***
--To see all columns including null values we have to use Full Outer Join
--If there is no common id on one of the tables, it returns NULL

SELECT * FROM SQLTutorial.dbo.EmployeeDemographics 
Full Outer Join SQLTutorial.dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--*** LEFT OUTER JOIN ***
--Shows all the values of the table on the left (first table) but returns only common ones on the second table

SELECT * FROM SQLTutorial.dbo.EmployeeDemographics 
Left Outer Join SQLTutorial.dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--*** RIGHT OUTER JOIN ***
--Shows all the values of the table on the right (second table)

SELECT * FROM SQLTutorial.dbo.EmployeeDemographics 
Right Outer Join SQLTutorial.dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--Show some spesific columns from both table using Right Outer Join
SELECT FirstName, LastName, JobTitle, Salary 
FROM EmployeeDemographics 
Right Outer Join EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--If want to see EmployeeID, we need to write its table too because both table have the same column name.
SELECT EmployeeDemographics.EmployeeID, FirstName, LastName, JobTitle, Salary 
FROM EmployeeDemographics 
Left Outer Join EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--When we try EmployeeID with the second table we have a different result
SELECT EmployeeSalary.EmployeeID, FirstName, LastName, JobTitle, Salary 
FROM EmployeeDemographics 
Left Outer Join EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--Regional Manager Michael Scott wants to see the employees' salary tohether with employeeID, first and last names in descending order
SELECT EmployeeDemographics.EmployeeID, FirstName, LastName, Salary 
FROM EmployeeDemographics
Inner Join EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE FirstName <> 'Michael' --not equal to Michael
ORDER BY Salary DESC 

--Let's find the AVG salary for Salesman on the table
SELECT JobTitle, AVG(Salary) AS Avg_Salary
FROM EmployeeDemographics
Inner Join EmployeeSalary
	ON EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID
WHERE JobTitle = 'Salesman'
GROUP BY JobTitle --We need to groop them according to jobtitle to see salesman

--***************** UNION *********************

--We can use "Union" to combine two tables when we have same columns. The number of columns have to be equal.
--Let's create a new table having the same column names with the EmployeeDemographics table.

--THIRD TABLE (Create)
CREATE TABLE WareHouseEmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

--THIRD TABLE (Insert)
INSERT INTO WareHouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')

SELECT * FROM WareHouseEmployeeDemographics

--Now both EmployeeDemographics and WareHouseEmployeeDemographics have the same columns
-- At least the data types and the amount of columns must be the same

--Select both table separately and union both tables
SELECT * FROM EmployeeDemographics
UNION
SELECT * FROM WareHouseEmployeeDemographics 
--If the tables are located in different databases, write the name of db before the tables (SQLTutorial.dbo.Table)

--"UNION ALL" brings duplicates too.
SELECT * FROM EmployeeDemographics
UNION ALL
SELECT * FROM WareHouseEmployeeDemographics 

--Union works also on the tables having the same number of columns. 
--However, if the columns hold different data, it does not make sense (For example, Age and Salary values on the same column).
--Let's combine EmployeeDemographics and EmployeeSalary table by selecting 3 columns from each table
SELECT EmployeeID, FirstName, Age
FROM EmployeeDemographics
UNION 
SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary

--As seen from the table, union worked in this example because both have 3 columns and the data types are the same, but it does not make sense.
