-- =====================================================================
-- MySQL Workbench keyword practice on PracticeDB
-- Run the setup script (Departments + Employees) first.
-- Run section by section: select the lines, press Ctrl+Shift+Enter.
-- Needs MySQL 8.0.16+ (for CHECK / DROP CHECK).
-- =====================================================================
USE PracticeDB;

-- ---------------------------------------------------------------------
-- 1. AUTO_INCREMENT
-- ---------------------------------------------------------------------
CREATE TABLE Demo (
    DemoID INT AUTO_INCREMENT PRIMARY KEY,
    Note   VARCHAR(50)
);
INSERT INTO Demo (Note) VALUES ('a'), ('b'), ('c');
SELECT LAST_INSERT_ID();                 -- first id of the batch (1)
SELECT * FROM Demo;

ALTER TABLE Demo AUTO_INCREMENT = 100;   -- next id will be 100
INSERT INTO Demo (Note) VALUES ('d');
SELECT * FROM Demo;

DELETE FROM Demo;                        -- counter is NOT reset
INSERT INTO Demo (Note) VALUES ('e');
SELECT * FROM Demo;                      -- id 101

TRUNCATE TABLE Demo;                     -- counter IS reset
INSERT INTO Demo (Note) VALUES ('f');
SELECT * FROM Demo;                      -- id 1

-- ---------------------------------------------------------------------
-- 2. LIMIT  (replaces TOP)
-- ---------------------------------------------------------------------
SELECT * FROM Employees LIMIT 3;
SELECT FirstName, Salary FROM Employees ORDER BY Salary DESC LIMIT 3;

-- ---------------------------------------------------------------------
-- 3. LIMIT ... OFFSET  (pagination)
-- ---------------------------------------------------------------------
SELECT * FROM Employees ORDER BY EmpID LIMIT 3 OFFSET 3;   -- rows 4-6
SELECT * FROM Employees ORDER BY EmpID LIMIT 3, 3;         -- same, short form (offset, count)

-- ---------------------------------------------------------------------
-- 4. BOOLEAN, TRUE, FALSE
-- ---------------------------------------------------------------------
SELECT FirstName, IsActive FROM Employees WHERE IsActive = TRUE;
UPDATE Employees SET IsActive = FALSE WHERE EmpID = 8;
SELECT FirstName, IsActive FROM Employees WHERE IsActive = FALSE;
UPDATE Employees SET IsActive = TRUE WHERE EmpID = 8;      -- put it back

-- ---------------------------------------------------------------------
-- 5. NOW(), CURDATE()
-- ---------------------------------------------------------------------
SELECT NOW(), CURDATE(), CURTIME();

-- ---------------------------------------------------------------------
-- 6. DEFAULT (CURRENT_DATE)
-- ---------------------------------------------------------------------
INSERT INTO Employees (FirstName, LastName, Salary, DeptID)
VALUES ('Test', 'User', 40000, 1);          -- HireDate and IsActive use defaults
SELECT EmpID, FirstName, HireDate, IsActive FROM Employees WHERE FirstName = 'Test';
DELETE FROM Employees WHERE FirstName = 'Test' AND EmpID > 0;

-- ---------------------------------------------------------------------
-- 7. CONCAT  (+ only adds numbers in MySQL)
-- ---------------------------------------------------------------------
SELECT CONCAT(FirstName, ' ', LastName) AS FullName FROM Employees;
SELECT CONCAT(FirstName, ' ', Email) AS NameEmail FROM Employees;   -- any NULL makes the result NULL
SELECT CONCAT_WS(' | ', FirstName, LastName, Email) FROM Employees; -- skips NULLs

-- ---------------------------------------------------------------------
-- 8. Alias with spaces: backticks
-- ---------------------------------------------------------------------
SELECT FirstName AS `First Name`,
       Salary * 12 AS `Annual Salary`
FROM Employees;

-- ---------------------------------------------------------------------
-- 9. CHAR_LENGTH  (also compare LENGTH = bytes)
-- ---------------------------------------------------------------------
SELECT LastName, CHAR_LENGTH(LastName) AS Chars, LENGTH(LastName) AS Bytes FROM Employees;

-- ---------------------------------------------------------------------
-- 10. LOCATE  (+ SUBSTRING to get the email domain)
-- ---------------------------------------------------------------------
SELECT Email,
       LOCATE('@', Email) AS AtPosition,
       SUBSTRING(Email, LOCATE('@', Email) + 1) AS Domain
FROM Employees
WHERE Email IS NOT NULL;

-- ---------------------------------------------------------------------
-- 11. IFNULL and COALESCE
-- ---------------------------------------------------------------------
SELECT FirstName,
       IFNULL(Salary, 0)               AS SalaryOrZero,
       COALESCE(Email, 'no-email')     AS EmailOrText
FROM Employees;

-- ---------------------------------------------------------------------
-- 12. TIMESTAMPDIFF
-- ---------------------------------------------------------------------
SELECT FirstName, HireDate,
       TIMESTAMPDIFF(YEAR,  HireDate, CURDATE()) AS YearsOfService,
       TIMESTAMPDIFF(MONTH, HireDate, CURDATE()) AS MonthsOfService
FROM Employees
ORDER BY YearsOfService DESC;

-- ---------------------------------------------------------------------
-- 13. DATE_SUB and DATE_ADD with INTERVAL
-- ---------------------------------------------------------------------
SELECT FirstName, HireDate
FROM Employees
WHERE HireDate >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR);     -- hired in last 3 years

SELECT FirstName, HireDate,
       DATE_ADD(HireDate, INTERVAL 1 YEAR) AS FirstAnniversary
FROM Employees;

-- ---------------------------------------------------------------------
-- 14. MONTHNAME
-- ---------------------------------------------------------------------
SELECT FirstName, HireDate, MONTHNAME(HireDate) AS HireMonth, DAYNAME(HireDate) AS HireDay
FROM Employees;

-- ---------------------------------------------------------------------
-- 15. DATE_FORMAT
-- ---------------------------------------------------------------------
SELECT FirstName,
       DATE_FORMAT(HireDate, '%d-%b-%Y') AS Pretty,        -- 15-Mar-2021
       DATE_FORMAT(HireDate, '%d/%m/%Y') AS DDMMYYYY       -- 15/03/2021
FROM Employees;

-- ---------------------------------------------------------------------
-- 16. LAST_DAY
-- ---------------------------------------------------------------------
SELECT FirstName, HireDate, LAST_DAY(HireDate) AS MonthEnd FROM Employees;

-- ---------------------------------------------------------------------
-- 17. CAST  (no TRY_CAST in MySQL)
-- ---------------------------------------------------------------------
SELECT Salary, CAST(Salary AS SIGNED) AS SalaryInt FROM Employees;
SELECT CAST('abc' AS SIGNED);       -- gives 0 and a warning, not an error
SHOW WARNINGS;
SELECT CAST('2024-05-01' AS DATE);

-- ---------------------------------------------------------------------
-- 18. IF()  (and CASE for more than two outcomes)
-- ---------------------------------------------------------------------
SELECT FirstName, Salary,
       IF(Salary > 60000, 'Yes', 'No') AS HighEarner,
       IF(IsActive, 'Active', 'Inactive') AS Status
FROM Employees;

SELECT FirstName, Salary,
       CASE
           WHEN Salary IS NULL   THEN 'Unknown'
           WHEN Salary < 50000   THEN 'Low'
           WHEN Salary <= 65000  THEN 'Mid'
           ELSE 'High'
       END AS SalaryBand
FROM Employees;

-- ---------------------------------------------------------------------
-- 19. RENAME COLUMN (plus ADD / MODIFY / DROP COLUMN, RENAME TABLE)
-- ---------------------------------------------------------------------
ALTER TABLE Employees ADD COLUMN Phone VARCHAR(15);
ALTER TABLE Employees RENAME COLUMN Phone TO Mobile;
ALTER TABLE Employees MODIFY COLUMN Mobile VARCHAR(20);
DESCRIBE Employees;
ALTER TABLE Employees DROP COLUMN Mobile;

RENAME TABLE Demo TO DemoRenamed;
RENAME TABLE DemoRenamed TO Demo;

-- ---------------------------------------------------------------------
-- 20. CREATE TABLE ... AS SELECT  (copy a table)
-- ---------------------------------------------------------------------
CREATE TABLE EmpBackup AS SELECT * FROM Employees;     -- data copied, keys NOT copied
SELECT COUNT(*) FROM EmpBackup;
CREATE TABLE EmpStructure LIKE Employees;              -- structure and keys, no data
DROP TABLE EmpBackup;
DROP TABLE EmpStructure;

-- ---------------------------------------------------------------------
-- 21. START TRANSACTION, SAVEPOINT, ROLLBACK, COMMIT
-- ---------------------------------------------------------------------
SET SQL_SAFE_UPDATES = 1;               -- Workbench default; keep it on

START TRANSACTION;
UPDATE Employees SET Salary = Salary * 1.10 WHERE DeptID = 2;
SAVEPOINT sp1;
DELETE FROM Employees WHERE EmpID = 8;
SELECT COUNT(*) FROM Employees;         -- one row fewer
ROLLBACK TO SAVEPOINT sp1;              -- undoes only the delete
SELECT COUNT(*) FROM Employees;         -- back to full count
ROLLBACK;                               -- undoes the raise too
SELECT FirstName, Salary FROM Employees WHERE DeptID = 2;   -- original salaries

START TRANSACTION;
UPDATE Employees SET Salary = Salary + 1000 WHERE EmpID = 1;
COMMIT;                                 -- permanent now
UPDATE Employees SET Salary = Salary - 1000 WHERE EmpID = 1;   -- manual undo

-- Safe Updates demo: this fails with error 1175 (Email is not a key column)
-- UPDATE Employees SET Email = 'x@corp.com' WHERE Email IS NULL;
-- Fix: use the primary key
UPDATE Employees SET Email = 'meera@corp.com' WHERE EmpID = 3;
UPDATE Employees SET Email = NULL WHERE EmpID = 3;             -- revert

-- ---------------------------------------------------------------------
-- 22. Unicode: utf8mb4
-- ---------------------------------------------------------------------
CREATE TABLE UniDemo (
    ID   INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
);
INSERT INTO UniDemo (Name) VALUES ('Asha'), ('आशा पाटील');
SELECT Name, CHAR_LENGTH(Name) AS Chars, LENGTH(Name) AS Bytes FROM UniDemo;
SHOW CHARACTER SET LIKE 'utf8mb4';
DROP TABLE UniDemo;

-- ---------------------------------------------------------------------
-- 23. DROP CHECK / DROP INDEX / DROP FOREIGN KEY
-- ---------------------------------------------------------------------
-- CHECK
ALTER TABLE Employees ADD CONSTRAINT chk_salary_max CHECK (Salary <= 500000);
-- INSERT INTO Employees (FirstName, LastName, Salary, DeptID) VALUES ('Big','Pay',900000,1);  -- fails
ALTER TABLE Employees DROP CHECK chk_salary_max;

-- UNIQUE (stored as an index; MySQL allows many NULLs in a unique column)
ALTER TABLE Employees ADD CONSTRAINT uq_email UNIQUE (Email);
SHOW INDEX FROM Employees;
ALTER TABLE Employees DROP INDEX uq_email;

-- FOREIGN KEY
CREATE TABLE Projects (
    ProjectID   INT AUTO_INCREMENT PRIMARY KEY,
    ProjectName VARCHAR(60) NOT NULL,
    DeptID      INT,
    CONSTRAINT fk_proj_dept FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);
INSERT INTO Projects (ProjectName, DeptID) VALUES ('Payroll Revamp', 3);
-- INSERT INTO Projects (ProjectName, DeptID) VALUES ('Ghost', 99);   -- fails: no dept 99
ALTER TABLE Projects DROP FOREIGN KEY fk_proj_dept;
INSERT INTO Projects (ProjectName, DeptID) VALUES ('Ghost', 99);       -- now allowed
DROP TABLE Projects;

-- ---------------------------------------------------------------------
-- Cleanup
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS Demo;

-- ---------------------------------------------------------------------
-- Mini challenges (write these yourself, no hints)
-- ---------------------------------------------------------------------
-- A. Top 3 highest-paid employees: full name (CONCAT), annual salary, alias with backticks.
-- B. Page 2 of employees sorted by hire date, 4 per page.
-- C. Employee name, years of service (TIMESTAMPDIFF), hire date as 'Mar 2021' (DATE_FORMAT).
-- D. Hired in the last 5 years (DATE_SUB), salary shown as 0 when NULL (IFNULL).
-- E. Email domain only (LOCATE + SUBSTRING), with 'unknown' when missing (COALESCE).
-- F. Label each employee 'Senior' if service >= 4 years else 'Junior' using IF().
-- G. In a transaction: raise HR salaries by 8%, SAVEPOINT, delete Sales staff, rollback to savepoint, commit.
-- H. Add a named CHECK on Salary, test it, then DROP CHECK.