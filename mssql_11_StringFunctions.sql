--**************** STRING FUNCTIONS ********************
-- (TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower)

--Source: Alex The Analyst- https://www.youtube.com/watch?v=GQj6_6V_jVA&list=PLUaB-1hjhk8EBZNL4nx4Otoa5Wb--rEpU&index=3

--For this exercise, let's create a new table with some values that need to be corrected
--Drop Table EmployeeErrors;

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

INSERT INTO EmployeeErrors VALUES
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

SELECT * FROM EmployeeErrors --As seen from the table, some values need to be corrrected (blank spaces, capital letter, name with "-", etc.)

-- *** TRIM, LTRIM (Left Trim), RTRIM (Right Trim) ***

--We use TRIM to remove blank spaces before or after the value
--On the other hand, Left TRIM (LTRIM) removes spaces before the value and RTRIM after the value

--Remove blank spaces before/after IDs (for both sides, use TRIM)
SELECT EmployeeID, TRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors 

--Remove spaces only from the left side 
SELECT EmployeeID, LTRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors 
--Even if right sight cannot be seen, there is space after the first and the last IDs on the table. So, it corrected only ID 1002.

--Remove spaces only from the right side 
SELECT EmployeeID, RTRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors

--*** REPLACE ***

--Reove "- Fired" from the LastName "Flenderson - Fired" 
SELECT LastName, REPLACE(LastName, '- Fired', '') AS LastNameFixed --replace it with ''
FROM EmployeeErrors


--*** SUBSTRING ***
--Syntax: SUBSTRING(input_string, start, length)

--In this example, we try to match names from both table which have some small differences. For example, "Jimbo" on one table and "Jim" on the other.
SELECT SUBSTRING(err.FirstName,1,3), SUBSTRING(dem.FirstName,1,3), SUBSTRING(err.LastName,1,3), SUBSTRING(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	ON SUBSTRING(err.FirstName,1,3) = SUBSTRING(dem.FirstName,1,3)
	AND SUBSTRING(err.LastName,1,3) = SUBSTRING(dem.LastName,1,3)



--*** UPPER and LOWER ***

--Let's make all FirstNames lower case
SELECT FirstName, LOWER(FirstName) AS Lower_FName
FROM EmployeeErrors


--Let's capitalize all FirstNames 
SELECT Firstname, UPPER(FirstName) AS Upper_FName
FROM EmployeeErrors