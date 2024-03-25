--**************** GROUP BY & ORDER BY ****************

--How many employees are Male / Female

SELECT Gender, COUNT(Gender) --Number of Male and Female Employees
FROM EmployeeDemographics
GROUP BY Gender --Answer: 3F, 6M

--How many of them are greater than 31
SELECT Gender, COUNT(Gender)
FROM EmployeeDemographics
WHERE Age>31
GROUP BY Gender --Answer: 1F and 3M

--Name it "CountGender" and sort it in descending order (DESC)
SELECT Gender, COUNT(Gender) AS CountGender
FROM EmployeeDemographics
WHERE Age>31
GROUP BY Gender
ORDER BY CountGender DESC --By default ASC

--Sort the whole table based on Age and Gender
SELECT * 
FROM EmployeeDemographics
ORDER BY Age, Gender --If there is same age, it sort it according to gender as well. For example, fist Age 30 Female, then Male

--Sort Age in ascdending order and Gender in descending order
SELECT *
FROM EmployeeDemographics
ORDER BY Age, Gender DESC --First Male, then Female

--Both in descending order
SELECT *
FROM EmployeeDemographics
ORDER BY Age DESC, Gender DESC

--We can do the same thing without using the column names but indexes
--Age in the 4. and Gender in the 5. indexes
SELECT *
FROM EmployeeDemographics
ORDER BY 4 DESC, 5 DESC
