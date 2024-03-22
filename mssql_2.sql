--************** WHERE STATEMENT *******************
-- (=,>, <, And, Or, Like, In, Null, Not Null)

--We use where statement to limit the data that we want to return

--Find "Jim"
SELECT * FROM EmployeeDemographics
WHERE FirstName='Jim'

--Find employees except Jim ("<>" means not equal)
SELECT * FROM EmployeeDemographics
WHERE FirstName<>'Jim'

--Age greater than 30
SELECT * FROM EmployeeDemographics
WHERE Age > 30

--Include also 30 years old (>=)
SELECT * FROM EmployeeDemographics
WHERE Age >= 30

--Less than and equals to 32
SELECT * FROM EmployeeDemographics
WHERE Age <= 32

--Find also Male employees in these ages
SELECT * FROM EmployeeDemographics
WHERE Age <=32 AND Gender='Male'

--With OR
SELECT * FROM EmployeeDemographics
WHERE Age<=32 OR Gender='Male'

--*** LIKE ***--

--LastName starting with "S"
SELECT * FROM EmployeeDemographics
WHERE LastName LIKE 'S%'  -- Start with S and continue with anyhting (%) after S

--LastName including S 
SELECT * FROM EmployeeDemographics
WHERE LastName LIKE '%S%' --anyything before or after S

--LastName starting with "S" and including "o"
SELECT * FROM EmployeeDemographics
WHERE LastName LIKE 'S%o%' -- There is only Scott

--*** is NULL, NOT NULL ***
SELECT * FROM EmployeeDemographics
WHERE LastName is NULL --Tere is no NULL values on the table

SELECT * FROM EmployeeDemographics
WHERE LastName is NOT NULL

--*** IN ***
--"IN" works like a multiple equal statements
--For exapmle, reach two firstnames
SELECT * FROM EmployeeDemographics
WHERE FirstName IN('Jim','Michael')


