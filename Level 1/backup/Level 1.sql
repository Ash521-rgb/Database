-- Create the database only if it doesn't exist (avoids the "database exists" error)
IF DB_ID('PracticeDB') IS NULL
    CREATE DATABASE PracticeDB;
GO

USE PracticeDB;
GO

-- Departments
CREATE TABLE Departments (
    DeptID    INT IDENTITY(1,1) PRIMARY KEY,
    DeptName  VARCHAR(50) NOT NULL,
    Location  VARCHAR(50)
);
GO

-- Employees (typo "Empoloyees" fixed, so no rename is needed)
CREATE TABLE Emp (
    EmpID     INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName  VARCHAR(50) NOT NULL,
    Email     VARCHAR(50) NOT NULL,
    Salary    DECIMAL(10,2) CHECK (Salary >= 0),
    DeptID    INT,
    HireDate  DATE DEFAULT (CAST(GETDATE() AS DATE)),
    IsActive  BIT DEFAULT 1,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);
GO

-- Porn table
CREATE TABLE Porn (
    PId      INT IDENTITY(1,1) PRIMARY KEY,
    StarName VARCHAR(50) NOT NULL,
    SId      INT,
    PhoneNo  VARCHAR(15),
    Rating   TINYINT,
    CONSTRAINT chk_rating CHECK (Rating BETWEEN 1 AND 5)
);
GO

-- Add the PId column to Emp (your original ALTER wasn't shown), then the foreign key
ALTER TABLE Emp ADD PId INT;
GO

ALTER TABLE Emp
    ADD CONSTRAINT fk_emp_porn FOREIGN KEY (PId) REFERENCES Porn(PId);
drop table Empoloyees ;

#check comit Android @hrishikesh-rajput