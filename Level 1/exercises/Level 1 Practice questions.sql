-- =====================================================================
-- SQL PRACTICE: QUESTIONS WITH ANSWERS  (SSMS / T-SQL)
-- Tables: Departments, Emp, Porn  (loaded with the T-SQL insert script)
--
-- HOW TO USE
--   1. Read a question (Q) and write your own query first.
--   2. Run it, then compare with the answer (A) and the expected result.
--   3. Run one query at a time: select it and press F5 (or Ctrl+E).
--
-- THE DATA (for checking your results)
--   Departments: 1 HR/Pune, 2 IT/Mumbai, 3 Finance/Pune, 4 Sales/Delhi,
--                5 Marketing/Bengaluru, 6 Legal/Chennai (no employees)
--   Emp: 15 rows. Arjun has NULL salary, Manoj has NULL DeptID,
--        Rohit is inactive, and Asha Patil appears twice (EmpID 1 and 15).
--   Porn: 5 rows, ratings 4, 5, 3, 2, 1.
--
-- NOTES
--   * Failed inserts and rolled-back transactions still use up identity values,
--     so new rows may get EmpID 16+ with gaps. Existing rows keep their IDs.
--   * Years of service use a "full years" formula (DATEDIFF alone counts
--     calendar-year boundaries, not complete years).
-- =====================================================================
USE PracticeDB;
GO

-- =====================================================================
-- PART 1: BASIC SELECT
-- =====================================================================

-- Q1. Show every column of every employee.
SELECT * FROM Emp;                                   -- 15 rows

-- Q2. Show only first name, last name and salary.
SELECT FirstName, LastName, Salary FROM Emp;

-- Q3. Show first name and annual salary (monthly x 12) with the alias "Annual Salary".
SELECT FirstName, Salary * 12 AS [Annual Salary] FROM Emp;   -- Arjun's value is NULL

-- Q4. Show the full name in one column called FullName.
SELECT CONCAT(FirstName, ' ', LastName) AS FullName FROM Emp;

-- Q5. List the distinct department ids used in Emp.
SELECT DISTINCT DeptID FROM Emp;                     -- 6 rows: NULL,1,2,3,4,5

-- Q6. List the distinct first names.
SELECT DISTINCT FirstName FROM Emp;                  -- 14 rows (Asha twice -> once)

-- Q7. Run a SELECT with no table: 5 + 3, today's date, and the text 'hello'.
SELECT 5 + 3, CAST(GETDATE() AS DATE), 'hello';      -- 8, today, hello

-- Q8. Show all departments.
SELECT * FROM Departments;                           -- 6 rows

-- Q9. Show all Porn rows.
SELECT * FROM Porn;                                  -- 5 rows

-- =====================================================================
-- PART 2: WHERE (filters)
-- =====================================================================

-- Q10. Employees in department 2.
SELECT * FROM Emp WHERE DeptID = 2;                  -- 4 rows: Ravi, Karan, Priya, Tina

-- Q11. Employees earning more than 60000.
SELECT FirstName, Salary FROM Emp WHERE Salary > 60000;     -- 6 rows

-- Q12. Salary between 50000 and 60000 (inclusive).
SELECT FirstName, Salary FROM Emp WHERE Salary BETWEEN 50000 AND 60000;   -- 5 rows

-- Q13. Employees in departments 1 or 3 (use IN).
SELECT FirstName, DeptID FROM Emp WHERE DeptID IN (1, 3);   -- 6 rows

-- Q14. Employees NOT in departments 1 or 3.
SELECT FirstName, DeptID FROM Emp WHERE DeptID NOT IN (1, 3);
-- 8 rows. Manoj (NULL DeptID) is NOT returned: NULL NOT IN (...) is unknown, not true.
-- To include him:
SELECT FirstName, DeptID FROM Emp WHERE DeptID NOT IN (1, 3) OR DeptID IS NULL;   -- 9 rows

-- Q15. First names starting with A.
SELECT FirstName FROM Emp WHERE FirstName LIKE 'A%';        -- 4 rows: Asha, Anita, Arjun, Asha

-- Q16. Last names ending with i.
SELECT LastName FROM Emp WHERE LastName LIKE '%i';          -- 3 rows: Joshi, Desai, Kulkarni

-- Q17. Last names containing "ar".
SELECT LastName FROM Emp WHERE LastName LIKE '%ar%';        -- 3 rows: Kumar, Kulkarni, Pawar

-- Q18. First names whose second letter is a.
SELECT FirstName FROM Emp WHERE FirstName LIKE '_a%';       -- 4 rows: Ravi, Karan, Sameer, Manoj

-- Q19. First names starting with A, R or P.
-- SQL Server has no REGEXP, but LIKE supports [ ] character sets.
SELECT FirstName FROM Emp WHERE FirstName LIKE '[ARP]%';    -- Asha, Ravi, Anita, Rohit, Priya, Arjun, Asha

-- Q20. First names that are exactly 5 letters long.
SELECT FirstName FROM Emp WHERE LEN(FirstName) = 5;         -- 8 rows
-- Same with LIKE and five underscores:
SELECT FirstName FROM Emp WHERE FirstName LIKE '_____';

-- Q21. Employees with no salary.
SELECT * FROM Emp WHERE Salary IS NULL;              -- 1 row: Arjun

-- Q22. Employees with no department.
SELECT * FROM Emp WHERE DeptID IS NULL;              -- 1 row: Manoj

-- Q23. Why does this return nothing? Fix it.
SELECT * FROM Emp WHERE Salary = NULL;               -- 0 rows: nothing equals NULL
SELECT * FROM Emp WHERE Salary IS NULL;              -- correct

-- Q24. Employees in department 2 earning more than 65000 (AND).
SELECT FirstName, Salary FROM Emp WHERE DeptID = 2 AND Salary > 65000;   -- 3 rows: Karan, Priya, Tina

-- Q25. Employees in department 1 or department 4 (OR).
SELECT FirstName, DeptID FROM Emp WHERE DeptID = 1 OR DeptID = 4;        -- 5 rows

-- Q26. Operator precedence. Compare these two queries.
SELECT FirstName FROM Emp
WHERE DeptID = 2 AND Salary < 65000 OR HireDate > '2023-01-01';
-- 5 rows (AND runs first): Ravi + Sneha, Rohit, Arjun, Manoj
SELECT FirstName FROM Emp
WHERE DeptID = 2 AND (Salary < 65000 OR HireDate > '2023-01-01');
-- 1 row: Ravi

-- Q27. Employees hired in 2021.
SELECT FirstName, HireDate FROM Emp WHERE YEAR(HireDate) = 2021;         -- 3 rows: Asha, Vikram, Sameer
-- Faster form (can use an index):
SELECT FirstName, HireDate FROM Emp WHERE HireDate BETWEEN '2021-01-01' AND '2021-12-31';

-- Q28. Active employees, then inactive ones.
SELECT FirstName FROM Emp WHERE IsActive = 1;        -- 14 rows
SELECT FirstName FROM Emp WHERE IsActive = 0;        -- 1 row: Rohit

-- Q29. Salary not equal to 55000.
SELECT FirstName, Salary FROM Emp WHERE Salary <> 55000;
-- 13 rows: Arjun (NULL) is excluded because NULL <> 55000 is unknown

-- Q30. Employees who have an entry in Porn (PId is not null).
SELECT FirstName, PId FROM Emp WHERE PId IS NOT NULL;        -- 8 rows
SELECT FirstName FROM Emp WHERE PId IS NULL;                 -- 7 rows

-- Q31. Porn rows with rating 4 or higher.
SELECT StarName, Rating FROM Porn WHERE Rating >= 4;         -- 2 rows: Star One, Star Two

-- Q32. Departments located in Pune.
SELECT DeptName FROM Departments WHERE Location = 'Pune';    -- HR, Finance

-- =====================================================================
-- PART 3: ORDER BY, TOP, OFFSET ... FETCH
-- =====================================================================

-- Q33. Employees by salary, highest first.
SELECT FirstName, Salary FROM Emp ORDER BY Salary DESC;      -- Tina 81000 first, Arjun (NULL) last

-- Q34. The 3 highest-paid employees.
SELECT TOP 3 FirstName, Salary FROM Emp ORDER BY Salary DESC;   -- Tina 81000, Karan 75000, Priya 72000

-- Q35. The 3 lowest-paid employees (ignore NULL).
SELECT TOP 3 FirstName, Salary FROM Emp
WHERE Salary IS NOT NULL
ORDER BY Salary ASC;                                 -- Rohit 45000, Manoj 47000, Meera 48000
-- Without the WHERE, Arjun comes first: SQL Server also treats NULL as the lowest value.

-- Q36. Sort by department ascending, then salary descending.
SELECT FirstName, DeptID, Salary FROM Emp ORDER BY DeptID ASC, Salary DESC;

-- Q37. Sort by column position (3rd column in the SELECT).
SELECT FirstName, LastName, Salary FROM Emp ORDER BY 3 DESC;

-- Q38. Show NULL salaries last when sorting ascending.
-- "ORDER BY Salary IS NULL" is not valid here; use CASE instead.
SELECT FirstName, Salary FROM Emp
ORDER BY CASE WHEN Salary IS NULL THEN 1 ELSE 0 END, Salary;

-- Q39. Page 2 of employees (4 per page, ordered by EmpID).
SELECT EmpID, FirstName FROM Emp ORDER BY EmpID OFFSET 4 ROWS FETCH NEXT 4 ROWS ONLY;   -- EmpID 5, 6, 7, 8

-- Q40. The second-highest salary.
SELECT FirstName, Salary FROM Emp ORDER BY Salary DESC OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;   -- Karan 75000

-- Q41. The longest-serving employee.
SELECT TOP 1 FirstName, HireDate FROM Emp ORDER BY HireDate ASC;  -- Tina, 2017-10-10

-- Q42. Sort by an alias.
SELECT FirstName, Salary * 12 AS Annual FROM Emp ORDER BY Annual DESC;

-- Q43. Porn rows from best to worst rating.
SELECT StarName, Rating FROM Porn ORDER BY Rating DESC;

-- =====================================================================
-- PART 4: FUNCTIONS (string, number, date)
-- =====================================================================

-- Q44. First names in upper case, last names in lower case.
SELECT UPPER(FirstName), LOWER(LastName) FROM Emp;

-- Q45. Length of each last name.
SELECT LastName, LEN(LastName) AS Len FROM Emp;

-- Q46. First 3 letters of the first name; last 2 letters of the last name.
SELECT LEFT(FirstName, 3), RIGHT(LastName, 2) FROM Emp;

-- Q47. Characters 2 to 4 of the first name.
SELECT FirstName, SUBSTRING(FirstName, 2, 3) FROM Emp;

-- Q48. Position of '@' in each email.
SELECT Email, CHARINDEX('@', Email) FROM Emp;

-- Q49. Email username and domain. (No SUBSTRING_INDEX in SQL Server.)
SELECT Email,
       LEFT(Email, CHARINDEX('@', Email) - 1)                       AS Username,
       SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email))      AS Domain
FROM Emp;
-- An email without '@' would make LEFT(..., -1) fail; guard with WHERE Email LIKE '%@%' if needed.

-- Q50. Replace corp.com with company.in in the email.
SELECT REPLACE(Email, 'corp.com', 'company.in') FROM Emp;

-- Q51. Remove extra spaces and reverse a string.
SELECT TRIM('   hello   '), REVERSE('hello');        -- 'hello', 'olleh'

-- Q52. Join first name, last name and email with ' | ', skipping NULLs.
SELECT CONCAT_WS(' | ', FirstName, LastName, Email) FROM Emp;

-- Q53. Daily rate (salary / 30) rounded to 2 decimals.
SELECT FirstName, ROUND(Salary / 30, 2) AS DailyRate FROM Emp;

-- Q54. Round salary to the nearest thousand; show ceiling and floor of salary / 7000.
SELECT Salary, ROUND(Salary, -3), CEILING(Salary / 7000), FLOOR(Salary / 7000) FROM Emp;

-- Q55. Absolute value, remainder and power. (MOD(a, b) becomes a % b.)
SELECT ABS(-15), 17 % 5, POWER(2, 10);               -- 15, 2, 1024

-- Q56. Year, month number and day of each hire date.
SELECT HireDate, YEAR(HireDate), MONTH(HireDate), DAY(HireDate) FROM Emp;

-- Q57. Month name and weekday name of each hire date.
SELECT HireDate, DATENAME(MONTH, HireDate), DATENAME(WEEKDAY, HireDate) FROM Emp;

-- Q58. Years of service for each employee, longest first (full years).
SELECT FirstName, HireDate, y.Years
FROM Emp
CROSS APPLY (SELECT DATEDIFF(YEAR, HireDate, GETDATE())
                    - IIF(DATEADD(YEAR, DATEDIFF(YEAR, HireDate, GETDATE()), HireDate)
                          > CAST(GETDATE() AS DATE), 1, 0) AS Years) AS y
ORDER BY y.Years DESC;

-- Q59. Days since each employee was hired.
SELECT FirstName, DATEDIFF(DAY, HireDate, GETDATE()) AS DaysSinceHire FROM Emp;

-- Q60. Employees hired in the last 3 years.
SELECT FirstName, HireDate FROM Emp
WHERE HireDate >= DATEADD(YEAR, -3, CAST(GETDATE() AS DATE));
-- As of October 2026 this returns 2 rows: Arjun and Manoj. The result changes as time passes.

-- Q61. Each employee's first work anniversary.
SELECT FirstName, DATEADD(YEAR, 1, HireDate) AS Anniversary FROM Emp;

-- Q62. Last day of the month of each hire date.
SELECT HireDate, EOMONTH(HireDate) FROM Emp;

-- Q63. Hire date shown as 15-Mar-2021 and as 15/03/2021.
SELECT FORMAT(HireDate, 'dd-MMM-yyyy'), FORMAT(HireDate, 'dd/MM/yyyy') FROM Emp;

-- Q64. Current date and time.
SELECT GETDATE(), CAST(GETDATE() AS DATE), CAST(GETDATE() AS TIME);

-- =====================================================================
-- PART 5: NULL HANDLING
-- =====================================================================

-- Q65. Show salary as 0 when it is NULL.
SELECT FirstName, ISNULL(Salary, 0) FROM Emp;

-- Q66. Show 'no department' text for NULL DeptID (COALESCE).
-- DeptID is INT, and SQL Server converts everything to the highest-priority type (INT),
-- so COALESCE(DeptID, 'no department') fails. Cast DeptID to text first.
SELECT FirstName, COALESCE(CAST(DeptID AS VARCHAR(10)), 'no department') FROM Emp;

-- Q67. What do these return? (SQL Server cannot SELECT a comparison directly, so wrap it in CASE.)
SELECT CASE WHEN NULL = NULL THEN 'true' ELSE 'not true (unknown)' END;   -- not true (unknown)
SELECT CASE WHEN NULL IS NULL THEN 'true' ELSE 'false' END;               -- true
SELECT 5 + NULL;             -- NULL
SELECT NULLIF(10, 10);       -- NULL (equal values give NULL)
SELECT NULLIF(10, 5);        -- 10

-- Q68. Count rows, salaries and departments, and see how COUNT treats NULL.
SELECT COUNT(*), COUNT(Salary), COUNT(DeptID) FROM Emp;     -- 15, 14, 14

-- =====================================================================
-- PART 6: CASE and IIF
-- =====================================================================

-- Q69. Label salary bands: Low under 50000, Mid up to 65000, High above, Unknown if NULL.
SELECT FirstName, Salary,
       CASE
           WHEN Salary IS NULL  THEN 'Unknown'
           WHEN Salary < 50000  THEN 'Low'
           WHEN Salary <= 65000 THEN 'Mid'
           ELSE 'High'
       END AS Band
FROM Emp;
-- Counts: Low 3, Mid 7, High 4, Unknown 1

-- Q70. Show Yes or No for salary above 60000 (IIF).
SELECT FirstName, IIF(Salary > 60000, 'Yes', 'No') AS HighEarner FROM Emp;
-- Arjun gets 'No' because the condition with NULL is not true.

-- Q71. Show Active or Inactive from IsActive (BIT needs "= 1").
SELECT FirstName, IIF(IsActive = 1, 'Active', 'Inactive') AS Status FROM Emp;

-- Q72. Convert values: salary as integer, hire date as text.
SELECT CAST(Salary AS INT), CAST(HireDate AS VARCHAR(10)) FROM Emp;
-- SELECT CAST('abc' AS INT);       -- ERROR in SQL Server (MySQL only warned)
SELECT TRY_CAST('abc' AS INT);      -- NULL, no error

-- =====================================================================
-- PART 7: INSERT, UPDATE, DELETE   (everything is rolled back at the end)
-- SSMS has no Safe Updates mode: an UPDATE or DELETE without WHERE hits every row.
-- =====================================================================

-- Q73. Insert one employee, check it, and remove it again.
BEGIN TRANSACTION;
INSERT INTO Emp (FirstName, LastName, Email, Salary, DeptID)
VALUES ('Zara', 'Khan', 'zara@corp.com', 50000, 1);
SELECT * FROM Emp WHERE FirstName = 'Zara';          -- HireDate = today, IsActive = 1 by default
ROLLBACK TRANSACTION;

-- Q74. Insert three employees in one statement.
BEGIN TRANSACTION;
INSERT INTO Emp (FirstName, LastName, Email, Salary, DeptID) VALUES
('Om',   'Sharma', 'om@corp.com',   42000, 4),
('Isha', 'Verma',  'isha@corp.com', 46000, 5),
('Dev',  'Malik',  'dev@corp.com',  49000, 1);
SELECT COUNT(*) FROM Emp;                            -- 18
ROLLBACK TRANSACTION;

-- Q75. Copy rows with INSERT ... SELECT into a new table.
CREATE TABLE HighEarners (FirstName VARCHAR(50), Salary DECIMAL(10,2));
GO
INSERT INTO HighEarners SELECT FirstName, Salary FROM Emp WHERE Salary > 70000;
SELECT * FROM HighEarners;                           -- Karan, Priya, Tina
DROP TABLE HighEarners;
GO

-- Q76. Give employee 1 a salary of 58000.
BEGIN TRANSACTION;
UPDATE Emp SET Salary = 58000 WHERE EmpID = 1;
SELECT FirstName, Salary FROM Emp WHERE EmpID = 1;
ROLLBACK TRANSACTION;

-- Q77. Raise IT (department 2) salaries by 10%.
BEGIN TRANSACTION;
UPDATE Emp SET Salary = Salary * 1.10 WHERE DeptID = 2;
SELECT FirstName, Salary FROM Emp WHERE DeptID = 2;  -- 68200, 82500, 79200, 89100
ROLLBACK TRANSACTION;

-- Q78. Update salary and department of employee 5 together.
BEGIN TRANSACTION;
UPDATE Emp SET Salary = 52000, DeptID = 4 WHERE EmpID = 5;
SELECT FirstName, Salary, DeptID FROM Emp WHERE EmpID = 5;
ROLLBACK TRANSACTION;

-- Q79. Raise salaries 15% if below 50000, otherwise 5% (UPDATE with CASE). NULL stays NULL.
BEGIN TRANSACTION;
UPDATE Emp SET Salary = CASE WHEN Salary < 50000 THEN Salary * 1.15 ELSE Salary * 1.05 END;
SELECT FirstName, Salary FROM Emp;
ROLLBACK TRANSACTION;

-- Q80. Fill a missing value: set Arjun's salary to 40000 only where it is NULL.
BEGIN TRANSACTION;
UPDATE Emp SET Salary = 40000 WHERE FirstName = 'Arjun' AND Salary IS NULL;
SELECT FirstName, Salary FROM Emp WHERE FirstName = 'Arjun';
ROLLBACK TRANSACTION;

-- Q81. Delete the inactive employee.
BEGIN TRANSACTION;
DELETE FROM Emp WHERE IsActive = 0;
SELECT COUNT(*) FROM Emp;                            -- 14
ROLLBACK TRANSACTION;

-- Q82. Delete everyone hired before 2019, then undo.
BEGIN TRANSACTION;
DELETE FROM Emp WHERE HireDate < '2019-01-01';       -- removes Priya and Tina
SELECT COUNT(*) FROM Emp;                            -- 13
ROLLBACK TRANSACTION;

-- Q83. Delete without WHERE, count the rows left, undo. (This is why you always use WHERE.)
BEGIN TRANSACTION;
DELETE FROM Emp;
SELECT COUNT(*) FROM Emp;                            -- 0
ROLLBACK TRANSACTION;
SELECT COUNT(*) FROM Emp;                            -- 15 again

-- Q84. SAVE TRANSACTION: raise HR salaries, delete Sales staff, undo only the delete, keep the raise.
BEGIN TRANSACTION;
UPDATE Emp SET Salary = Salary * 1.08 WHERE DeptID = 1;
SAVE TRANSACTION after_raise;
DELETE FROM Emp WHERE DeptID = 4;
ROLLBACK TRANSACTION after_raise;
SELECT COUNT(*) FROM Emp;                            -- 15 (delete undone)
COMMIT TRANSACTION;                                  -- raise is now permanent
-- Undo the permanent raise so your data matches the answers above:
UPDATE Emp SET Salary = ROUND(Salary / 1.08, 0) WHERE DeptID = 1;
SELECT FirstName, Salary FROM Emp WHERE DeptID = 1;  -- 55000, 51000, NULL

-- =====================================================================
-- PART 8: CONSTRAINT TESTS (each statement below SHOULD fail)
-- Remove the leading "-- " to run one, read the error, then comment it again.
-- =====================================================================

-- Q85. Negative salary.
-- INSERT INTO Emp (FirstName, LastName, Email, Salary) VALUES ('A','B','a@b.com', -1);
--   Msg 547: The INSERT statement conflicted with the CHECK constraint "CK__Emp__Salary__...".

-- Q86. Department that does not exist.
-- INSERT INTO Emp (FirstName, LastName, Email, DeptID) VALUES ('A','B','a@b.com', 99);
--   Msg 547: The INSERT statement conflicted with the FOREIGN KEY constraint.

-- Q87. Duplicate primary key. EmpID is an IDENTITY column, so you must switch IDENTITY_INSERT on.
-- SET IDENTITY_INSERT Emp ON;
-- INSERT INTO Emp (EmpID, FirstName, LastName, Email) VALUES (1, 'A', 'B', 'a@b.com');
-- SET IDENTITY_INSERT Emp OFF;       -- run this even after the error
--   Msg 2627: Violation of PRIMARY KEY constraint. Cannot insert duplicate key.
--   Without IDENTITY_INSERT you would get Msg 544 instead.

-- Q88. Missing NOT NULL column (Email).
-- INSERT INTO Emp (FirstName, LastName) VALUES ('A', 'B');
--   Msg 515: Cannot insert the value NULL into column 'Email'; column does not allow nulls.

-- Q89. Rating outside 1 to 5 in Porn.
-- INSERT INTO Porn (StarName, SId, PhoneNo, Rating) VALUES ('X', 1, '123', 9);
--   Msg 547: conflicted with the CHECK constraint "chk_rating".

-- Q90. Link an employee to a Porn row that does not exist.
-- UPDATE Emp SET PId = 99 WHERE EmpID = 1;
--   Msg 547: The UPDATE statement conflicted with the FOREIGN KEY constraint "fk_emp_porn".

-- Q91. Delete a parent row that still has children.
-- DELETE FROM Departments WHERE DeptID = 1;
--   Msg 547: The DELETE statement conflicted with the REFERENCE constraint.
-- DELETE FROM Departments WHERE DeptID = 6;   -- works: Legal has no employees
-- (undo by re-inserting: INSERT INTO Departments (DeptName, Location) VALUES ('Legal', 'Chennai');
--  it will get a new DeptID, not 6, because of IDENTITY)

-- Q92. Add a CHECK constraint, test it, and drop it.
ALTER TABLE Emp ADD CONSTRAINT chk_sal_max CHECK (Salary <= 500000);
GO
-- INSERT INTO Emp (FirstName, LastName, Email, Salary) VALUES ('A','B','a@b.com', 900000);   -- fails
ALTER TABLE Emp DROP CONSTRAINT chk_sal_max;
GO

-- Q93. Add a UNIQUE constraint on Email, then drop it.
ALTER TABLE Emp ADD CONSTRAINT uq_emp_email UNIQUE (Email);
GO
ALTER TABLE Emp DROP CONSTRAINT uq_emp_email;          -- DROP CONSTRAINT, not DROP INDEX
GO

-- =====================================================================
-- PART 9: DDL (change structure)
-- =====================================================================

-- Q94. Create a Projects table with an auto-numbered key.
CREATE TABLE Projects (
    ProjectID   INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName VARCHAR(60) NOT NULL,
    StartDate   DATE,
    Budget      DECIMAL(12,2)
);
GO

-- Q95. Add a column, change its type, rename it, then drop it.
-- Run each batch separately (the GO lines split them), because a new column
-- cannot be used in the same batch that creates it.
ALTER TABLE Projects ADD Client VARCHAR(30);                   -- no COLUMN keyword in ADD
GO
ALTER TABLE Projects ALTER COLUMN Client VARCHAR(80);          -- replaces MODIFY COLUMN
GO
EXEC sp_rename 'Projects.Client', 'ClientName', 'COLUMN';      -- replaces RENAME COLUMN
GO
ALTER TABLE Projects DROP COLUMN ClientName;
GO
EXEC sp_help 'Projects';                                       -- replaces DESCRIBE
GO

-- Q96. Rename a table and rename it back.
EXEC sp_rename 'Projects', 'Projects2';
EXEC sp_rename 'Projects2', 'Projects';
GO

-- Q97. Copy a table (data only, then structure only).
SELECT * INTO EmpCopy FROM Emp;                        -- data copied, keys and constraints NOT copied
SELECT * INTO EmpShell FROM Emp WHERE 1 = 0;           -- structure only (no CREATE TABLE ... LIKE)
SELECT COUNT(*) FROM EmpCopy;                          -- 15
SELECT COUNT(*) FROM EmpShell;                         -- 0
GO

-- Q98. Show the difference between DELETE, TRUNCATE and DROP on the copy.
DELETE FROM EmpCopy;                                   -- rows gone, table stays (WHERE allowed, can rollback)
TRUNCATE TABLE EmpCopy;                                -- all rows gone fast, identity reset, no WHERE
DROP TABLE EmpCopy;                                    -- table itself gone
DROP TABLE EmpShell;
GO

-- Q99. Show the structure and the CREATE statement of a table.
EXEC sp_help 'Emp';                                    -- replaces DESCRIBE
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Emp';
-- SHOW CREATE TABLE: in SSMS right-click Emp > Script Table as > CREATE To > New Query Editor Window
SELECT name FROM sys.tables;                           -- replaces SHOW TABLES

-- Q100. Check IDENTITY behaviour.
INSERT INTO Projects (ProjectName) VALUES ('P1'), ('P2');   -- ids 1, 2
DELETE FROM Projects;
INSERT INTO Projects (ProjectName) VALUES ('P3');           -- id 3 (DELETE does not reset)
TRUNCATE TABLE Projects;
INSERT INTO Projects (ProjectName) VALUES ('P4');           -- id 1 (TRUNCATE resets)
SELECT * FROM Projects;
DROP TABLE Projects;
GO

-- =====================================================================
-- PART 10: MIXED CHALLENGES (combine several ideas)
-- =====================================================================

-- Q101. Top 3 earners: full name and annual salary.
SELECT TOP 3 CONCAT(FirstName, ' ', LastName) AS [Full Name], Salary * 12 AS [Annual Salary]
FROM Emp ORDER BY Salary DESC;                       -- Tina 972000, Karan 900000, Priya 864000

-- Q102. Employees with a 5-letter first name and no salary.
SELECT * FROM Emp WHERE LEN(FirstName) = 5 AND Salary IS NULL;   -- Arjun

-- Q103. Departments 1 and 3, hired after 2020, salary 45000 to 60000.
SELECT FirstName, DeptID, HireDate, Salary FROM Emp
WHERE DeptID IN (1, 3) AND HireDate > '2020-12-31' AND Salary BETWEEN 45000 AND 60000;
-- 4 rows: Asha (1), Sneha, Meera, Asha (15)

-- Q104. Distinct hire years, newest first.
SELECT DISTINCT YEAR(HireDate) AS HireYear FROM Emp ORDER BY HireYear DESC;   -- 8 rows: 2024 down to 2017

-- Q105. Employees whose last name starts with a vowel.
SELECT * FROM Emp WHERE LastName LIKE '[AEIOU]%';    -- 1 row: Iyer

-- Q106. The 4th to 6th highest-paid employees.
SELECT FirstName, Salary FROM Emp ORDER BY Salary DESC
OFFSET 3 ROWS FETCH NEXT 3 ROWS ONLY;                -- Vikram 68000, Neha 64000, Ravi 62000

-- Q107. Name, salary band (CASE) and years of service, sorted by service.
SELECT CONCAT(FirstName, ' ', LastName) AS FullName,
       CASE WHEN Salary IS NULL THEN 'Unknown'
            WHEN Salary < 50000 THEN 'Low'
            WHEN Salary <= 65000 THEN 'Mid'
            ELSE 'High' END AS Band,
       y.Years
FROM Emp
CROSS APPLY (SELECT DATEDIFF(YEAR, HireDate, GETDATE())
                    - IIF(DATEADD(YEAR, DATEDIFF(YEAR, HireDate, GETDATE()), HireDate)
                          > CAST(GETDATE() AS DATE), 1, 0) AS Years) AS y
ORDER BY y.Years DESC;

-- Q108. Label employees Senior (4+ years of service) or Junior with IIF().
SELECT FirstName, IIF(y.Years >= 4, 'Senior', 'Junior') AS Level
FROM Emp
CROSS APPLY (SELECT DATEDIFF(YEAR, HireDate, GETDATE())
                    - IIF(DATEADD(YEAR, DATEDIFF(YEAR, HireDate, GETDATE()), HireDate)
                          > CAST(GETDATE() AS DATE), 1, 0) AS Years) AS y;

-- =====================================================================
-- PART 11: BONUS PREVIEW OF LEVEL 2 (aggregates and joins)
-- =====================================================================

-- Q109. Count, total, average, highest and lowest salary.
SELECT COUNT(*) AS Total,
       SUM(Salary) AS TotalSalary,                   -- 836000
       ROUND(AVG(Salary), 2) AS AvgSalary,           -- 59714.29 (14 values; NULL ignored)
       MAX(Salary) AS Highest,                       -- 81000
       MIN(Salary) AS Lowest                         -- 45000
FROM Emp;

-- Q110. Employees and average salary per department.
SELECT DeptID, COUNT(*) AS Employees, ROUND(AVG(Salary), 2) AS AvgSalary
FROM Emp
GROUP BY DeptID;
-- DeptID 1: 3 / 53000.00   2: 4 / 72500.00   3: 3 / 54333.33
--        4: 2 / 56500.00   5: 2 / 58500.00   NULL: 1 / 47000.00

-- Q111. Only departments with more than 2 employees.
SELECT DeptID, COUNT(*) AS Employees FROM Emp
GROUP BY DeptID HAVING COUNT(*) > 2;                 -- departments 1, 2, 3

-- Q112. Find duplicate names.
SELECT FirstName, LastName, COUNT(*) AS Times FROM Emp
GROUP BY FirstName, LastName HAVING COUNT(*) > 1;    -- Asha Patil, 2

-- Q113. Employees who earn more than the average salary.
SELECT FirstName, Salary FROM Emp
WHERE Salary > (SELECT AVG(Salary) FROM Emp);        -- 6 rows: Ravi, Karan, Vikram, Priya, Neha, Tina

-- Q114. Employee name with department name (INNER JOIN).
SELECT e.FirstName, d.DeptName
FROM Emp e INNER JOIN Departments d ON e.DeptID = d.DeptID;     -- 14 rows (Manoj has no department)

-- Q115. All employees, even those without a department (LEFT JOIN).
SELECT e.FirstName, d.DeptName
FROM Emp e LEFT JOIN Departments d ON e.DeptID = d.DeptID;      -- 15 rows (Manoj shows NULL)

-- Q116. Departments with no employees.
SELECT d.DeptName
FROM Departments d LEFT JOIN Emp e ON d.DeptID = e.DeptID
WHERE e.EmpID IS NULL;                               -- Legal

-- Q117. Employee name with the linked Porn star name and rating.
SELECT e.FirstName, p.StarName, p.Rating
FROM Emp e INNER JOIN Porn p ON e.PId = p.PId;       -- 8 rows

-- Q118. Number of employees per department name, including Legal with 0.
SELECT d.DeptName, COUNT(e.EmpID) AS Employees
FROM Departments d LEFT JOIN Emp e ON d.DeptID = e.DeptID
GROUP BY d.DeptName;
-- HR 3, IT 4, Finance 3, Sales 2, Marketing 2, Legal 0

-- Q119. Highest-paid employee in each department (name included).
SELECT e.FirstName, e.DeptID, e.Salary
FROM Emp e
WHERE e.Salary = (SELECT MAX(Salary) FROM Emp WHERE DeptID = e.DeptID);
-- Asha(55000, dept 1), Tina(81000, dept 2), Anita(59000, dept 3), Vikram(68000, dept 4),
-- Neha(64000, dept 5)

-- Q120. Total salary budget per location.
SELECT d.Location, SUM(e.Salary) AS Budget
FROM Departments d INNER JOIN Emp e ON d.DeptID = e.DeptID
GROUP BY d.Location;
-- Pune 269000 (HR 55000+51000 plus Finance 48000+59000+56000), Mumbai 290000,
-- Delhi 113000, Bengaluru 117000. Arjun's NULL salary is ignored by SUM.

-- =====================================================================
-- PART 12: CONCEPT QUESTIONS (answers in the comments)
-- =====================================================================
-- Q121. Primary key vs foreign key?
--   Primary key uniquely identifies a row (no NULL, no duplicates). A foreign key
--   is a column that must match a primary key in another table; it links the tables.
-- Q122. DELETE vs TRUNCATE vs DROP?
--   DELETE removes chosen rows, supports WHERE, can be rolled back inside a transaction.
--   TRUNCATE removes all rows, no WHERE, resets IDENTITY, and (unlike MySQL) CAN be rolled back
--   inside a transaction in SQL Server. It cannot be used on a table that a foreign key references.
--   DROP removes the whole table (structure and data).
-- Q123. Why DECIMAL for money?  It is exact; FLOAT and REAL store approximations.
-- Q124. CHAR vs VARCHAR vs NVARCHAR?  CHAR is fixed length (padded); VARCHAR uses only the
--       space needed; NVARCHAR stores Unicode (2 bytes per character) for any language.
-- Q125. Why use IS NULL instead of = NULL?  NULL means unknown; comparing with = gives unknown, not true.
-- Q126. DDL, DML, DCL, TCL examples?
--   DDL: CREATE, ALTER, DROP, TRUNCATE.  DML: INSERT, UPDATE, DELETE, SELECT.
--   DCL: GRANT, REVOKE, DENY.  TCL: BEGIN TRANSACTION, COMMIT, ROLLBACK, SAVE TRANSACTION.
-- Q127. WHERE vs HAVING?  WHERE filters rows before grouping; HAVING filters groups after.
-- Q128. What does BETWEEN 10 AND 20 include?  Both 10 and 20.
-- Q129. What does LIKE '%a_' match?  Text whose second-to-last character is a.
-- Q130. SQL Server has no Safe Updates mode. How do you protect yourself from a missing WHERE?
--       Write the WHERE first, run a SELECT with the same WHERE to preview the rows,
--       and wrap the change in BEGIN TRANSACTION so you can ROLLBACK (check @@ROWCOUNT before COMMIT).