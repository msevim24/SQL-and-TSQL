--********************** ALIASING **********************
--Firstname with alias
SELECT FirstName AS FName --It works also without "AS"
FROM EmployeeDemographics

--Combine FirstName and LastName and display it AS FullName
SELECT FirstName + ' ' + LastName AS FullName
FROM EmployeeDemographics

--Find Average Age and show it as "AvgAge"  
SELECT AVG(Age) AS AvgAge
FROM EmployeeDemographics

--Aliasing Table name
SELECT Demo.EmployeeID
FROM EmployeeDemographics AS Demo --alias for the table

--It is easy to read especially in joins. Instead of witing entire table names we can use aliases.
--"d" for EmployeeDemographics and "s" for EmployeeSalary table
SELECT d.EmployeeID, s.Salary
FROM EmployeeDemographics d --we can use it without AS
JOIN EmployeeSalary s
	ON d.EmployeeID = s.EmployeeID

--Three table with aliases (D, S, W are the aliases for the tables)
SELECT D.EmployeeID, D.FirstName, S.JobTitle, W.Age
FROM EmployeeDemographics D
LEFT JOIN EmployeeSalary S
	ON D.EmployeeID = S.EmployeeID
LEFT JOIN WareHouseEmployeeDemographics W
	ON D.EmployeeID = W.EmployeeID
