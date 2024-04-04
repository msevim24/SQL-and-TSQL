--***************** UPDATE... SET... *****************
--"Uptade" alters preexisting rows. It is different from "Insert into" because insert creates a row.

--Let's fill in the NULL values in the existing rows. 
--Add an EmployeeID "1012" which looks NULL
SELECT * FROM EmployeeDemographics -- See how you can reach this row to add an ID

UPDATE EmployeeDemographics 
SET EmployeeID = 1012 --What we want to change
WHERE FirstName = 'Holly' AND LastName = 'Flax' --If we do not specify it, it will change all ID's to 1012

-- Update Age and Gender for the same row
UPDATE EmployeeDemographics 
SET Age = 31, Gender = 'Female' --We can change more than one value using "comma". We do not need AND.
WHERE EmployeeID = 1012 --Since we know its ID, it is easy to reach the row

--There remained one NULL value on the table: Age of Darryl Phibin. Let's change it
UPDATE EmployeeDemographics
SET Age = 33
WHERE EmployeeID = 1013

--Let's fill in the NULL values on the EmployeeSalary table
SELECT * FROM EmployeeSalary

UPDATE EmployeeSalary
SET EmployeeID = 1011
WHERE JobTitle ='Salesman' AND Salary = 43000 --Since tehre are several Salesman we need give more information such as Salary

--Change Jobtitle info as "HR" for the row with "1010" EmployeeID
UPDATE EmployeeSalary
SET JobTitle = 'HR'
WHERE EmployeeID = 1010

--******************** DELETE FROM **********************
--DELETE is used to remove the entire row
--DELETE is a DML (Data Manipulation Language) command. This command removes records from a table. 
--It is used only for deleting data from a table, not to remove the table from the database. 
--If specific rows are not selected, it will delete all rows. (To delete all records: DELETE FROM table_name)
--So, before using delete, select row that you want to delete. Then after seeing it, you can delete it by changing Select with Delete. (Select From / Delete From)

DELETE FROM EmployeeDemographics --If the row is not specified, it will delete the all recods on the table
WHERE EmployeeID = 1005

SELECT * FROM EmployeeDemographics --As seen, the row with 1005 EmployeeID was deleted.

--************* The differences between DELETE, TRUNCATE, and DROP ***************
--DELETE is used to remove specific rows from a table based on a given condition. It is a DML command
--TRUNCATE TABLE is similar to DELETE, but it is used to delete all rows from a table, leaving the row with the column names.
--TRUNCATE is a DDL (Data Definition Language) command. It doesn’t use the WHERE clause. (TRUNCATE TABLE table_name)
--TRUNCATE is faster than DELETE, as it doesn't scan every record before removing it.
--The DROP TABLE is another DDL (Data Definition Language) operation.
--DROP is used to delete an entire table, including its structure and data from database.(DROP TABLE table_name;)
--DELETE can be rolled back, but TRUNCATE and DROP cannot be undone.