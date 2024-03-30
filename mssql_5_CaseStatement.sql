--******************** CASE STATEMENT ********************
-- (WHEN...THEN...ELSE...)

--Case Statement starts with "CASE" and ends with "END"

--Find all employees with Not Null ages and mark them "old" if is is over 30, and "young" if it is under 30
SELECT FirstName,  LastName, Age, --there is a comma here
CASE
	WHEN Age>30 THEN 'Old'
	ELSE 'Young'
END					-- we can name it here (AS ...)
FROM EmployeeDemographics
WHERE Age is NOT NULL --All ages with not null
ORDER BY Age

-- Age over 30 is "Old", between 27 and 30 is "Young", others are "Baby"
SELECT FirstName, LastName, Age,
CASE
	WHEN Age>30 THEN 'Old'
	WHEN Age BETWEEN 27 AND 30 THEN 'Young'
	ELSE 'Baby'
END
FROM EmployeeDemographics
WHERE Age is NOT NULL
ORDER BY Age

--If there are two conditions met by the case statement, the first one works, the following does not.
--For example Age>30 for one condition and Age=38 for another
SELECT FirstName, LastName, Age,
CASE
	WHEN Age>30 THEN 'Old'
	WHEN Age=38 THEN 'Favorite Age' --This does not work because it is over 30. So the previous statement works (Age>30).
	WHEN Age BETWEEN 27 AND 30 THEN 'Young'
	ELSE 'Baby'
END
FROM EmployeeDemographics
WHERE Age is NOT NULL
ORDER BY Age

-- We want to raise employees' salaries based on the following rates: Salesman 10%; Accountant 5%; HR 3%; the rest 2%
-- Name the column as "RaisedSalary"
-- Since the salary column is on the EmployeeSalary table, we need to join two tables

SELECT FirstName, LastName, JobTitle, Salary,
CASE
	WHEN JobTitle='Salesman' THEN Salary + (Salary * .10)
	WHEN JobTitle='Accountant' THEN Salary + (Salary * .05)
	WHEN JobTitle='HR' THEN Salary + (Salary * .03)
	ELSE Salary + (Salary * 0.2)
END AS RaisedSalary
FROM EmployeeDemographics
JOIN EmployeeSalary --by default Join means "Inner Join"
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID