--************************************************
--            MICROSOFT SQL TUTORIAL
--************************************************
-- Source: 
-- YouTube Videos:https://www.youtube.com/@AlexTheAnalyst


--************* CREATE TABLE ************

--TABLE 1--
CREATE TABLE EmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
)  

--To make all these lines comment, select lines and use "comment out" icon above 

--Let's creare another table

--TABLE 2--
CREATE TABLE EmployeeSalary
(EmployeeID int,
JobTitle varchar(50),
Salary int)

--To see the rows we can simply right click on the table name: "Select Top 1000 Rows"
--However, we do not have any values now. So, we need to insert some values.

--**************** INSERT INTO ... VALUES **************

--TABLE 1--
INSERT INTO EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')

SELECT * FROM EmployeeDemographics;

--TABLE 2--
INSERT INTO EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)

SELECT * FROM EmployeeSalary;

--*********** SELECT STATEMENT (TOP, DISTINCT, COUNT, MIN, MAX, SUM, AVG) *************

--Select by column names
SELECT FirstName, LastName FROM EmployeeDemographics

--Select Top 5 rows
SELECT TOP 5 *
FROM EmployeeDemographics

--Distinct Gender
SELECT DISTINCT Gender 
FROM EmployeeDemographics --Male and Female

--Count
SELECT COUNT(LastName)
FROM EmployeeDemographics --9 records

--In this query, there is no column name. We can name it using "AS"

SELECT COUNT(LastName) AS LastNameCount
FROM EmployeeDemographics

--Max Salary from EmployeeSalary Table
SELECT MAX(Salary) AS max_salary
FROM EmployeeSalary --65000

--Min Salary
SELECT MIN(Salary) AS min_salary
FROM EmployeeSalary --36000

--Average Salary
SELECT AVG(Salary) AS avg_salary
FROM EmployeeSalary --48555

--Total Salary
SELECT SUM(Salary) AS total_salary
FROM EmployeeSalary --437000

-- Select Database--

--We work on SQLTutorial DB that we created for this practice.
--However, when we change it, for example, to Master above, we need to call the database in which our tables located.
--Let's reach EmployeeSalary table in SQLTutorial DB

SELECT *
FROM SQLTutorial.dbo.EmployeeSalary