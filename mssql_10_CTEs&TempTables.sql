/*				*** ADVANCED SQL TOPICS ***

************* CTEs (Common Table Expression) *************/

--Each SQL CTE is like a named query, whose result is stored in a virtual table (a CTE) to be referenced later in the main query.
--We can define CTEs by adding a WITH clause directly before the SELECT, INSERT, UPDATE, DELETE, or MERGE statement. 
--The WITH clause can include one or more CTEs separated by commas. 

--Find the amount of gender for each group and AVG Salary by Gender Where Salary greater than 45000 and call it as CTE_Employee
WITH CTE_Employee AS 
(SELECT FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender,
AVG(Salary) OVER (PARTITION BY Gender) as AvgSalary
FROM EmployeeDemographics Dem
JOIN EmployeeSalary Sal
	ON Dem.EmployeeID=Sal.EmployeeID
WHERE Salary>45000
)
SELECT * FROM CTE_Employee  --Instead of each column (*), we could select some specific columns

---------------NEW TABLE -----------
--Let's create a new table named Employee (Source: GeeksforGeeks)
CREATE TABLE Employees
(EmployeeID int NOT NULL PRIMARY KEY,
  FirstName varchar(50) NOT NULL,
  LastName varchar(50) NOT NULL,
  ManagerID int NULL
)

INSERT INTO Employees VALUES (1, 'Ken', 'Thompson', NULL)
INSERT INTO Employees VALUES (2, 'Terri', 'Ryan', 1)
INSERT INTO Employees VALUES (3, 'Robert', 'Durello', 1)
INSERT INTO Employees VALUES (4, 'Rob', 'Bailey', 2)
INSERT INTO Employees VALUES (5, 'Kent', 'Erickson', 2)
INSERT INTO Employees VALUES (6, 'Bill', 'Goldberg', 3)
INSERT INTO Employees VALUES (7, 'Ryan', 'Miller', 3)
INSERT INTO Employees VALUES (8, 'Dane', 'Mark', 5)
INSERT INTO Employees VALUES (9, 'Charles', 'Matthew', 6)
INSERT INTO Employees VALUES (10, 'Michael', 'Jhonson', 6) 

--Let's have a look at the new table
SELECT * FROM Employees

--Let's create a CTE called cteReports
WITH cteReports (EmpID, FirstName, LastName, MgrID, EmpLevel) AS
(SELECT EmployeeID, FirstName, LastName, ManagerID, 1
FROM Employees
WHERE ManagerID IS NULL
UNION ALL
SELECT e.EmployeeID, e.FirstName, e.LastName, e.ManagerID, r.EmpLevel + 1
FROM Employees e
INNER JOIN cteReports r
   ON e.ManagerID = r.EmpID
)
SELECT FirstName + ' ' + LastName AS FullName, EmpLevel, --This is CTE's select statement but there is another select statement after it
(SELECT FirstName + ' ' + LastName
FROM Employees 
WHERE EmployeeID = cteReports.MgrID) AS Manager
FROM cteReports 
ORDER BY EmpLevel, MgrID 


------------------------------*************---------------------------
--******************* TEMP TABLES (TEMPORARY TABLES) ******************

-- Why are Temporary Tables Important in SQL Servers?

--1) Session-Specific, Data Storage: The data stored in the temp table is only for the ongoing session or transaction. 
--As soon as the session ends the data is cleared from the database storage which saves a lot of space for the user and reduces the memory consumption.
--2) Optimized Performance: For complex operations, the intermediate data is stored in the temp which improves the query execution speed for the SQL server. 
--3) Data Isolation: The temporary tables are only visible and accessible within the session in which they were created. This ensures data isolation and integrity.
--4) Safe Testing Environment: The temporary tables allow testing the queries without affecting the actual tables of the user.
--The users can test their queries easily without rolling back the operations. 
--The temporary tables ensures that no permanent data of the user is affected during any query execution.

--*** CREATE A TEMP TABLE***

--The syntax to create the temporary table is the same as the syntax we use to create the normal permanent tables in our databases. 
--But here we use "#" before the table name to create it. (Syntax: Create Table #tableName(Attribute 1, Attribute 2 .... ))
CREATE TABLE #temp_Employee (
EmployeeID int,
JobTitle varchar(100),
Salary int
)

SELECT * FROM #temp_Employee

INSERT INTO #temp_Employee VALUES (
'1001', 'HR', '45000'
)

-- Let's insert the values of EmployeeSalary into our temporary table (#temp_Employee)
INSERT INTO #temp_Employee
SELECT * FROM SQLTutorial..EmployeeSalary --instead of writing values, we use the values of existing table

--Check the temp table
Select * From #temp_Employee


--*** CREATE ANOTHER TEMP TABLE

DROP TABLE IF EXISTS #Temp_Employee2 --When we try to create this temp table again it will give error. So, to be sure, use drop
CREATE TABLE #Temp_Employee2 (
JobTitle varchar(100),
EmployeesPerJob int,
AvgAge int,
AvgSalary int
)


INSERT INTO #Temp_Employee2 
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(salary) --temp table's values come from this select statement
FROM SQLTutorial..EmployeeDemographics Dem
JOIN SQLTutorial..EmployeeSalary Sal
	ON Dem.EmployeeID = Sal.EmployeeID
GROUP BY JobTitle

--Check the new temp table
SELECT * FROM #Temp_Employee2 

--Multiply AvgAge and AvgSalary
SELECT AvgAge * AvgSalary FROM #Temp_Employee2 