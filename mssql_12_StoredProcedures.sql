--***************** STORED PROCEDURES ***************

--A stored procedure is a prepared SQL code that you can save, so the code can be reused over and over again.
--So if you have an SQL query that you want to reuse, save it as a stored procedure, and then just call it to execute it.
--Syntax: "CREATE PROCEDURE procedure_name AS sql_statement GO;" and to call it "EXEC procedure_name"
--Created procedures can be found under "Databases/SQLTutorial (the name of the database)/Programmability/Stored Procedures" on the left side

--Let's store a basic SELECT statement to reuse later
CREATE PROCEDURE TEST  --Test is the name of this procedure, we need this name to call it back
AS 
SELECT * FROM EmployeeDemographics --This is the statement we want to reuse and therefore store.
GO -- 

--To call it use EXEC
EXEC TEST

--Stored Procedure With One Parameter
--Create a stored procedure that selects a particular Jobtitle from "EmployeeSalary" table
CREATE PROCEDURE SelectJobTitle			--the name of the procedure 
@JobTitle varchar(100)
AS
SELECT * FROM EmployeeSalary WHERE JobTitle = @JobTitle
GO

--After creating it, Let's display a specific Jobtitle from our table
EXEC SelectJobTitle @JobTitle = 'Salesman' --we can display all Salesman on the table

-- Stored Procedure with Multiple Parameters
--Setting up multiple parameters is very easy. Just list each parameter and the data type separated by a comma.
CREATE PROCEDURE SelectJobSalary		--the name of the procedure 
@JobTitle varchar(100) , @Salary int
AS
SELECT * FROM EmployeeSalary WHERE JobTitle = @JobTitle AND Salary = @Salary
GO

--Display Salesman with the Salary 45000
EXEC SelectJobSalary @JobTitle='Salesman', @Salary=45000
