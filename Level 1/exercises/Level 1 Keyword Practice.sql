-- =====================================================================
-- SSMS (T-SQL) keyword practice on PracticeDB
-- Converted from the MySQL Workbench version.
-- Run the setup script (Departments + Emp + Porn) first.
-- Run section by section: select the lines, press F5 (or Ctrl+E).
-- Table name is Emp (not Employees). Email is NOT NULL in Emp.
-- Needs SQL Server 2017+ (CONCAT_WS, DROP TABLE IF EXISTS).
-- =====================================================================
USE PracticeDB;
GO

-- ---------------------------------------------------------------------
-- 1. IDENTITY  (replaces AUTO_INCREMENT)
-- ---------------------------------------------------------------------
CREATE TABLE Demo (
    DemoID INT IDENTITY(1,1) PRIMARY KEY,
    Note   VARCHAR(50)
);
INSERT INTO Demo (Note) VALUES ('a'), ('b'), ('c');
SELECT SCOPE_IDENTITY() AS LastId;        -- LAST id of the batch (3), unlike MySQL
SELECT * FROM Demo;

DBCC CHECKIDENT ('Demo', RESEED, 99);     -- next id will be 100
INSERT INTO Demo (Note) VALUES ('d');
SELECT * FROM Demo;

DELETE FROM Demo;                         -- counter is NOT reset
INSERT INTO Demo (Note) VALUES ('e');
SELECT * FROM Demo;                       -- id 101

TRUNCATE TABLE Demo;                      -- counter IS reset
INSERT INTO Demo (Note) VALUES ('f');
SELECT * FROM Demo;                       -- id 1

-- Bonus: insert an explicit value into an identity column
-- SET IDENTITY_INSERT Demo ON;
-- INSERT INTO Demo (DemoID, Note) VALUES (500, 'manual');   -- column list is required
-- SET IDENTITY_INSERT Demo OFF;

-- ---------------------------------------------------------------------
-- 2. TOP  (replaces LIMIT)
-- ---------------------------------------------------------------------
SELECT TOP 3 * FROM Emp;
SELECT TOP 3 FirstName, Salary FROM Emp ORDER BY Salary DESC;
SELECT TOP 3 WITH TIES FirstName, Salary FROM Emp ORDER BY Salary DESC;  -- includes ties

-- ---------------------------------------------------------------------
-- 3. OFFSET ... FETCH  (pagination; ORDER BY is required)
-- ---------------------------------------------------------------------
SELECT * FROM Emp ORDER BY EmpID OFFSET 3 ROWS FETCH NEXT 3 ROWS ONLY;   -- rows 4-6
-- There is no short form like LIMIT 3, 3 in SQL Server.

-- ---------------------------------------------------------------------
-- 4. BIT  (replaces BOOLEAN, TRUE, FALSE; use 1 and 0)
-- ---------------------------------------------------------------------
SELECT FirstName, IsActive FROM Emp WHERE IsActive = 1;
UPDATE Emp SET IsActive = 0 WHERE EmpID = 8;
SELECT FirstName, IsActive FROM Emp WHERE IsActive = 0;
UPDATE Emp SET IsActive = 1 WHERE EmpID = 8;        -- put it back

-- ---------------------------------------------------------------------
-- 5. GETDATE(), SYSDATETIME()  (replaces NOW, CURDATE, CURTIME)
-- ---------------------------------------------------------------------
SELECT GETDATE()                    AS NowValue,
       SYSDATETIME()                AS NowPrecise,
       CAST(GETDATE() AS DATE)      AS TodayDate,
       CAST(GETDATE() AS TIME)      AS TimeNow;

-- ---------------------------------------------------------------------
-- 6. DEFAULT (CAST(GETDATE() AS DATE))
-- ---------------------------------------------------------------------
INSERT INTO Emp (FirstName, LastName, Email, Salary, DeptID)
VALUES ('Test', 'User', 'test@corp.com', 40000, 1);   -- HireDate and IsActive use defaults
SELECT EmpID, FirstName, HireDate, IsActive FROM Emp WHERE FirstName = 'Test';
DELETE FROM Emp WHERE FirstName = 'Test';

-- ---------------------------------------------------------------------
-- 7. CONCAT  (+ also works for strings in SQL Server)
-- ---------------------------------------------------------------------
SELECT CONCAT(FirstName, ' ', LastName) AS FullName FROM Emp;
SELECT FirstName + ' ' + LastName       AS FullName FROM Emp;       -- NULL makes the result NULL
SELECT CONCAT(FirstName, ' ', Salary)   AS NameSalary FROM Emp;     -- CONCAT treats NULL as '' (differs from MySQL)
SELECT FirstName + ' ' + CAST(Salary AS VARCHAR(20)) FROM Emp;      -- + needs a manual CAST for numbers
SELECT CONCAT_WS(' | ', FirstName, LastName, Email) FROM Emp;       -- skips NULLs

-- ---------------------------------------------------------------------
-- 8. Alias with spaces: square brackets
-- ---------------------------------------------------------------------
SELECT FirstName AS [First Name],
       Salary * 12 AS [Annual Salary]
FROM Emp;

-- ---------------------------------------------------------------------
-- 9. LEN and DATALENGTH  (replaces CHAR_LENGTH / LENGTH)
-- ---------------------------------------------------------------------
SELECT LastName, LEN(LastName) AS Chars, DATALENGTH(LastName) AS Bytes FROM Emp;
-- LEN ignores trailing spaces; DATALENGTH counts them.

-- ---------------------------------------------------------------------
-- 10. CHARINDEX  (replaces LOCATE; argument order is (find, text))
-- ---------------------------------------------------------------------
SELECT Email,
       CHARINDEX('@', Email) AS AtPosition,
       SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS Domain   -- length is required
FROM Emp
WHERE Email IS NOT NULL;

-- ---------------------------------------------------------------------
-- 11. ISNULL and COALESCE  (replaces IFNULL)
-- ---------------------------------------------------------------------
SELECT FirstName,
       ISNULL(Salary, 0)             AS SalaryOrZero,
       COALESCE(Email, 'no-email')   AS EmailOrText
FROM Emp;

-- ---------------------------------------------------------------------
-- 12. DATEDIFF  (replaces TIMESTAMPDIFF; counts boundaries crossed)
-- ---------------------------------------------------------------------
SELECT FirstName, HireDate,
       DATEDIFF(YEAR,  HireDate, GETDATE()) AS YearsBoundaries,    -- 2024-12-31 to 2025-01-01 = 1 year!
       DATEDIFF(MONTH, HireDate, GETDATE()) AS MonthsBoundaries,
       DATEDIFF(YEAR, HireDate, GETDATE())
         - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, HireDate, GETDATE()), HireDate) > GETDATE()
                THEN 1 ELSE 0 END           AS FullYearsOfService  -- matches MySQL TIMESTAMPDIFF
FROM Emp
ORDER BY FullYearsOfService DESC;

-- ---------------------------------------------------------------------
-- 13. DATEADD  (replaces DATE_ADD and DATE_SUB; subtract with a negative number)
-- ---------------------------------------------------------------------
SELECT FirstName, HireDate
FROM Emp
WHERE HireDate >= DATEADD(YEAR, -3, CAST(GETDATE() AS DATE));      -- hired in last 3 years

SELECT FirstName, HireDate,
       DATEADD(YEAR, 1, HireDate) AS FirstAnniversary
FROM Emp;

-- ---------------------------------------------------------------------
-- 14. DATENAME  (replaces MONTHNAME / DAYNAME)
-- ---------------------------------------------------------------------
SELECT FirstName, HireDate,
       DATENAME(MONTH, HireDate)   AS HireMonth,
       DATENAME(WEEKDAY, HireDate) AS HireDay
FROM Emp;

-- ---------------------------------------------------------------------
-- 15. FORMAT  (replaces DATE_FORMAT; uses .NET patterns, MM = month, mm = minute)
-- ---------------------------------------------------------------------
SELECT FirstName,
       FORMAT(HireDate, 'dd-MMM-yyyy') AS Pretty,        -- 15-Mar-2021
       FORMAT(HireDate, 'dd/MM/yyyy')  AS DDMMYYYY,      -- 15/03/2021
       CONVERT(VARCHAR(10), HireDate, 103) AS DDMMYYYY2  -- older style, faster on big tables
FROM Emp;

-- ---------------------------------------------------------------------
-- 16. EOMONTH  (replaces LAST_DAY)
-- ---------------------------------------------------------------------
SELECT FirstName, HireDate, EOMONTH(HireDate) AS MonthEnd FROM Emp;

-- ---------------------------------------------------------------------
-- 17. CAST and TRY_CAST  (TRY_CAST exists here, unlike MySQL)
-- ---------------------------------------------------------------------
SELECT Salary, CAST(Salary AS INT) AS SalaryInt FROM Emp;          -- truncates decimals
-- SELECT CAST('abc' AS INT);       -- ERROR: conversion failed (MySQL only warned)
SELECT TRY_CAST('abc' AS INT) AS SafeResult;                       -- NULL, no error
SELECT CAST('2024-05-01' AS DATE);
SELECT TRY_CONVERT(DATE, '2024-13-45') AS BadDate;                 -- NULL

-- ---------------------------------------------------------------------
-- 18. IIF()  (and CASE for more than two outcomes)
-- ---------------------------------------------------------------------
SELECT FirstName, Salary,
       IIF(Salary > 60000, 'Yes', 'No')          AS HighEarner,
       IIF(IsActive = 1, 'Active', 'Inactive')   AS Status      -- BIT needs "= 1"
FROM Emp;

SELECT FirstName, Salary,
       CASE
           WHEN Salary IS NULL   THEN 'Unknown'
           WHEN Salary < 50000   THEN 'Low'
           WHEN Salary <= 65000  THEN 'Mid'
           ELSE 'High'
       END AS SalaryBand
FROM Emp;

-- ---------------------------------------------------------------------
-- 19. ADD / sp_rename / ALTER COLUMN / DROP COLUMN
-- ---------------------------------------------------------------------
ALTER TABLE Emp ADD Phone VARCHAR(15);                  -- no COLUMN keyword in ADD
GO
EXEC sp_rename 'Emp.Phone', 'Mobile', 'COLUMN';         -- replaces RENAME COLUMN
GO
ALTER TABLE Emp ALTER COLUMN Mobile VARCHAR(20);        -- replaces MODIFY COLUMN
GO
EXEC sp_help 'Emp';                                     -- replaces DESCRIBE
GO
ALTER TABLE Emp DROP COLUMN Mobile;
GO

EXEC sp_rename 'Demo', 'DemoRenamed';                   -- replaces RENAME TABLE
EXEC sp_rename 'DemoRenamed', 'Demo';
GO

-- ---------------------------------------------------------------------
-- 20. SELECT ... INTO  (replaces CREATE TABLE ... AS SELECT)
-- ---------------------------------------------------------------------
SELECT * INTO EmpBackup FROM Emp;                       -- data copied, keys NOT copied
SELECT COUNT(*) FROM EmpBackup;
SELECT * INTO EmpStructure FROM Emp WHERE 1 = 0;        -- structure only (no LIKE in SQL Server)
DROP TABLE EmpBackup;
DROP TABLE EmpStructure;
GO

-- ---------------------------------------------------------------------
-- 21. BEGIN TRANSACTION, SAVE TRANSACTION, ROLLBACK, COMMIT
-- ---------------------------------------------------------------------
-- No Safe Updates mode in SSMS: an UPDATE or DELETE without WHERE runs on every row.
-- Always check your WHERE clause, or wrap it in a transaction first.

BEGIN TRANSACTION;
UPDATE Emp SET Salary = Salary * 1.10 WHERE DeptID = 2;
SAVE TRANSACTION sp1;                                   -- replaces SAVEPOINT
DELETE FROM Emp WHERE EmpID = 8;
SELECT COUNT(*) FROM Emp;                               -- one row fewer
ROLLBACK TRANSACTION sp1;                               -- undoes only the delete
SELECT COUNT(*) FROM Emp;                               -- back to full count
ROLLBACK TRANSACTION;                                   -- undoes the raise too
SELECT FirstName, Salary FROM Emp WHERE DeptID = 2;     -- original salaries
SELECT @@TRANCOUNT AS OpenTransactions;                 -- 0 means nothing is left open

BEGIN TRANSACTION;
UPDATE Emp SET Salary = Salary + 1000 WHERE EmpID = 1;
COMMIT TRANSACTION;                                     -- permanent now
UPDATE Emp SET Salary = Salary - 1000 WHERE EmpID = 1;  -- manual undo

-- Email is NOT NULL in Emp, so the "set Email to NULL" demo from the MySQL file is skipped.
-- Instead, see what happens when a statement fails inside a transaction:
SET XACT_ABORT ON;                                      -- any error rolls back the whole transaction
BEGIN TRANSACTION;
UPDATE Emp SET Salary = 50000 WHERE EmpID = 1;
-- UPDATE Emp SET Salary = -5 WHERE EmpID = 2;          -- uncomment to see CHECK fail and roll back all
COMMIT TRANSACTION;
SET XACT_ABORT OFF;
UPDATE Emp SET Salary = 55000 WHERE EmpID = 1;          -- restore original

-- ---------------------------------------------------------------------
-- 22. Unicode: NVARCHAR and the N prefix  (replaces utf8mb4)
-- ---------------------------------------------------------------------
CREATE TABLE UniDemo (
    ID   INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50)
);
INSERT INTO UniDemo (Name) VALUES (N'Asha'), (N'आशा पाटील');   -- N prefix is required, or you get ????
SELECT Name, LEN(Name) AS Chars, DATALENGTH(Name) AS Bytes FROM UniDemo;   -- 2 bytes per char
SELECT SERVERPROPERTY('Collation') AS ServerCollation;                     -- replaces SHOW CHARACTER SET
DROP TABLE UniDemo;
GO

-- ---------------------------------------------------------------------
-- 23. DROP CONSTRAINT  (one syntax for CHECK, UNIQUE and FOREIGN KEY)
-- ---------------------------------------------------------------------
-- CHECK
ALTER TABLE Emp ADD CONSTRAINT chk_salary_max CHECK (Salary <= 500000);
-- INSERT INTO Emp (FirstName, LastName, Email, Salary, DeptID) VALUES ('Big','Pay','big@corp.com',900000,1);  -- fails
ALTER TABLE Emp DROP CONSTRAINT chk_salary_max;
GO

-- UNIQUE (SQL Server allows only ONE NULL in a unique column; MySQL allows many)
ALTER TABLE Emp ADD CONSTRAINT uq_email UNIQUE (Email);
EXEC sp_helpindex 'Emp';                                -- replaces SHOW INDEX
ALTER TABLE Emp DROP CONSTRAINT uq_email;
GO

-- FOREIGN KEY
CREATE TABLE Projects (
    ProjectID   INT IDENTITY(1,1) PRIMARY KEY,
    ProjectName VARCHAR(60) NOT NULL,
    DeptID      INT,
    CONSTRAINT fk_proj_dept FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);
GO
INSERT INTO Projects (ProjectName, DeptID) VALUES ('Payroll Revamp', 3);
-- INSERT INTO Projects (ProjectName, DeptID) VALUES ('Ghost', 99);   -- fails: no dept 99
ALTER TABLE Projects DROP CONSTRAINT fk_proj_dept;      -- replaces DROP FOREIGN KEY
INSERT INTO Projects (ProjectName, DeptID) VALUES ('Ghost', 99);       -- now allowed
DROP TABLE Projects;
GO

-- ---------------------------------------------------------------------
-- Cleanup
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS Demo;
GO

-- ---------------------------------------------------------------------
-- Mini challenges (write these yourself, no hints)
-- ---------------------------------------------------------------------
-- A. Top 3 highest-paid employees: full name (CONCAT), annual salary, alias with [brackets].
-- B. Page 2 of employees sorted by hire date, 4 per page (OFFSET/FETCH).
-- C. Employee name, years of service (DATEDIFF), hire date as 'Mar 2021' (FORMAT).
-- D. Hired in the last 5 years (DATEADD), salary shown as 0 when NULL (ISNULL).
-- E. Email domain only (CHARINDEX + SUBSTRING), with 'unknown' when missing (COALESCE).
-- F. Label each employee 'Senior' if service >= 4 years else 'Junior' using IIF().
-- G. In a transaction: raise HR salaries by 8%, SAVE TRANSACTION, delete Sales staff,
--    rollback to the savepoint, commit.
-- H. Add a named CHECK on Salary, test it, then DROP CONSTRAINT.