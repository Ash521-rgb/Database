-- =====================================================================
-- Sample data for Departments, Emp, Porn  (MySQL Workbench)
-- Run your CREATE TABLE statements first, then this file.
-- =====================================================================

-- 0. FIX: your Emp table has no PId column, so add the column BEFORE the foreign key
ALTER TABLE Emp ADD COLUMN PId INT;
ALTER TABLE Emp
    ADD CONSTRAINT fk_emp_porn FOREIGN KEY (PId) REFERENCES Porn(PId);

-- 1. Departments (Legal has no employees on purpose, for join practice later)
INSERT INTO Departments (DeptName, Location) VALUES
('HR',        'Pune'),
('IT',        'Mumbai'),
('Finance',   'Pune'),
('Sales',     'Delhi'),
('Marketing', 'Bengaluru'),
('Legal',     'Chennai');

-- 2. Porn table (parent of Emp.PId, so insert before Emp)
INSERT INTO Porn (StarName, SId, PhoneNo, Rating) VALUES
('Star One',   101, '9876543210', 4),
('Star Two',   102, '9123456780', 5),
('Star Three', 103, '9988776655', 3),
('Star Four',  104, '9090909090', 2),
('Star Five',  105, '9811122233', 1);

-- 3. Emp (Email is NOT NULL in your table, so every row has one)
--    Includes: a NULL salary, a NULL DeptID, an inactive employee,
--    and a duplicate name (Asha Patil) for duplicate-finding practice.
INSERT INTO Emp (FirstName, LastName, Email, Salary, DeptID, HireDate, IsActive, PId) VALUES
('Asha',   'Patil',     'asha@corp.com',     55000, 1,    '2021-03-15', TRUE,  1),
('Ravi',   'Kumar',     'ravi@corp.com',     62000, 2,    '2020-07-01', TRUE,  2),
('Meera',  'Joshi',     'meera@corp.com',    48000, 3,    '2022-01-10', TRUE,  NULL),
('Karan',  'Shah',      'karan@corp.com',    75000, 2,    '2019-11-20', TRUE,  1),
('Sneha',  'Rao',       'sneha@corp.com',    51000, 1,    '2023-05-05', TRUE,  NULL),
('Vikram', 'Desai',     'vikram@corp.com',   68000, 4,    '2021-09-12', TRUE,  3),
('Anita',  'Nair',      'anita@corp.com',    59000, 3,    '2020-02-28', TRUE,  2),
('Rohit',  'Jain',      'rohit@corp.com',    45000, 4,    '2023-08-18', FALSE, NULL),
('Priya',  'Iyer',      'priya@corp.com',    72000, 2,    '2018-06-30', TRUE,  4),
('Arjun',  'Mehta',     'arjun@corp.com',    NULL,  1,    '2024-01-08', TRUE,  NULL),
('Neha',   'Kulkarni',  'neha@corp.com',     64000, 5,    '2022-04-19', TRUE,  5),
('Sameer', 'Pawar',     'sameer@corp.com',   53000, 5,    '2021-12-01', TRUE,  NULL),
('Tina',   'Fernandes', 'tina@corp.com',     81000, 2,    '2017-10-10', TRUE,  3),
('Manoj',  'Gupta',     'manoj@corp.com',    47000, NULL, '2024-03-03', TRUE,  NULL),
('Asha',   'Patil',     'asha.p@corp.com',   56000, 3,    '2022-09-09', TRUE,  NULL);

-- 4. Check the data
SELECT * FROM Departments;
SELECT * FROM Porn;
SELECT * FROM Emp;
SELECT COUNT(*) AS TotalEmp FROM Emp;       -- 15

-- =====================================================================
-- Operations to practise (write these yourself, then check the results)
-- =====================================================================
-- SELECT: employees in IT; salary above 60000; names starting with 'A'
-- ORDER BY / LIMIT: top 5 salaries; page 2 with 4 rows per page
-- NULLs: employees with no salary; employees with no department
-- UPDATE: raise IT salaries by 10% (use WHERE DeptID = 2)
-- DELETE: remove the inactive employee (use WHERE EmpID = 8)
-- Functions: CONCAT full name, TIMESTAMPDIFF years of service, DATE_FORMAT hire date
-- Constraint tests: insert Salary -1 (CHECK fails); insert DeptID 99 (FK fails);
--                   insert PId 99 (FK fails); insert Rating 9 into Porn (CHECK fails)
-- Transaction: START TRANSACTION; DELETE FROM Emp; ROLLBACK;