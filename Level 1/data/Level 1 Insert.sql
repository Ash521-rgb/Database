USE PracticeDB;
GO

-- 0. Add PId + FK only if they don't already exist
IF COL_LENGTH('Emp', 'PId') IS NULL
    ALTER TABLE Emp ADD PId INT;
GO

IF OBJECT_ID('fk_emp_porn', 'F') IS NULL
    ALTER TABLE Emp
        ADD CONSTRAINT fk_emp_porn FOREIGN KEY (PId) REFERENCES Porn(PId);
GO

-- 1. Departments (Legal has no employees on purpose, for join practice)
INSERT INTO Departments (DeptName, Location) VALUES
('HR',        'Pune'),
('IT',        'Mumbai'),
('Finance',   'Pune'),
('Sales',     'Delhi'),
('Marketing', 'Bengaluru'),
('Legal',     'Chennai');
GO

-- 2. Porn (parent of Emp.PId, so insert before Emp)
INSERT INTO Porn (StarName, SId, PhoneNo, Rating) VALUES
('Star One',   101, '9876543210', 4),
('Star Two',   102, '9123456780', 5),
('Star Three', 103, '9988776655', 3),
('Star Four',  104, '9090909090', 2),
('Star Five',  105, '9811122233', 1);
GO

-- 3. Emp
INSERT INTO Emp (FirstName, LastName, Email, Salary, DeptID, HireDate, IsActive, PId) VALUES
('Asha',   'Patil',     'asha@corp.com',   55000, 1,    '2021-03-15', 1, 1),
('Ravi',   'Kumar',     'ravi@corp.com',   62000, 2,    '2020-07-01', 1, 2),
('Meera',  'Joshi',     'meera@corp.com',  48000, 3,    '2022-01-10', 1, NULL),
('Karan',  'Shah',      'karan@corp.com',  75000, 2,    '2019-11-20', 1, 1),
('Sneha',  'Rao',       'sneha@corp.com',  51000, 1,    '2023-05-05', 1, NULL),
('Vikram', 'Desai',     'vikram@corp.com', 68000, 4,    '2021-09-12', 1, 3),
('Anita',  'Nair',      'anita@corp.com',  59000, 3,    '2020-02-28', 1, 2),
('Rohit',  'Jain',      'rohit@corp.com',  45000, 4,    '2023-08-18', 0, NULL),
('Priya',  'Iyer',      'priya@corp.com',  72000, 2,    '2018-06-30', 1, 4),
('Arjun',  'Mehta',     'arjun@corp.com',  NULL,  1,    '2024-01-08', 1, NULL),
('Neha',   'Kulkarni',  'neha@corp.com',   64000, 5,    '2022-04-19', 1, 5),
('Sameer', 'Pawar',     'sameer@corp.com', 53000, 5,    '2021-12-01', 1, NULL),
('Tina',   'Fernandes', 'tina@corp.com',   81000, 2,    '2017-10-10', 1, 3),
('Manoj',  'Gupta',     'manoj@corp.com',  47000, NULL, '2024-03-03', 1, NULL),
('Asha',   'Patil',     'asha.p@corp.com', 56000, 3,    '2022-09-09', 1, NULL);
GO

-- 4. Check the data
SELECT * FROM Departments;
SELECT * FROM Porn;
SELECT * FROM Emp;
SELECT COUNT(*) AS TotalEmp FROM Emp;   -- 15
GO