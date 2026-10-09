create database PracticeDB ;
use PracticeDB;    #1007.can't create database 'practicedb':database exits

create table Departments(
DEPTID INT AUTO_INCREMENT PRIMARY KEY,
DEPTNAME VARCHAR(50) NOT NULL,
LOCATION VARCHAR(50)
);

create table Empoloyees(
EmpID INT AUTO_INCREMENT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Email VARCHAR(50) NOT NULL,
Salary DECIMAL(10,2) CHECK(salary>=0),
DeptID INT,
HireDate DATE DEFAULT (CURRENT_DATE),
ISACTIVE BOOLEAN default TRUE,
FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
); 

select * from pORN;
rename table Empoloyees to Emp;

CREATE TABLE Porn (
    PId      INT AUTO_INCREMENT PRIMARY KEY,
    StarName VARCHAR(50) NOT NULL,
    SId      INT,
    PhoneNo  VARCHAR(15),
    Rating   TINYINT,
    CONSTRAINT chk_rating CHECK (Rating BETWEEN 1 AND 5)
);

-- Emp.PId already exists from your ALTER, so just add the key
ALTER TABLE Emp
    ADD CONSTRAINT fk_emp_porn FOREIGN KEY (PId) REFERENCES Porn(PId);
drop table Empoloyees ;