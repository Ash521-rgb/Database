# SQL Keyword Glossary (MySQL Workbench)

Every keyword and function used in your practice files, with its meaning and a small example on your `Emp`, `Departments` and `Porn` tables. SQL is not case-sensitive for keywords (`select` = `SELECT`), but writing keywords in capitals makes queries easier to read.

---

## 1. Basic ideas

| Term | Meaning |
|---|---|
| Database | A container that holds related tables. |
| Table | Data arranged in rows and columns about one subject (for example `Emp`). |
| Row (record) | One entry in a table, such as one employee. |
| Column (field) | One attribute of every row, with a fixed data type, such as `Salary`. |
| Primary key | A column whose values uniquely identify each row. It cannot be NULL or repeated. |
| Foreign key | A column that must match a primary key in another table. It links tables together. |
| NULL | "Unknown or missing". It is not zero and not an empty string. |
| Query | A SQL statement that asks the database for data. |
| Schema | In MySQL, another word for a database. Also the overall design of tables and links. |
| Alias | A temporary name given to a column or table inside one query. |
| Subquery | A query written inside another query, usually in parentheses. |
| Transaction | A group of statements that succeed or fail together. |

## 2. Command families

| Family | Full name | Purpose | Commands |
|---|---|---|---|
| DDL | Data Definition Language | Change the structure | `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `RENAME` |
| DML | Data Manipulation Language | Change the data | `INSERT`, `UPDATE`, `DELETE` |
| DQL | Data Query Language | Read the data | `SELECT` |
| DCL | Data Control Language | Permissions | `GRANT`, `REVOKE` |
| TCL | Transaction Control Language | Control transactions | `START TRANSACTION`, `COMMIT`, `ROLLBACK`, `SAVEPOINT` |

---

## 3. Database and table commands (DDL)

| Keyword | Meaning | Example |
|---|---|---|
| `CREATE DATABASE` | Makes a new database. | `CREATE DATABASE PracticeDB;` |
| `USE` | Chooses which database the next statements run on. | `USE PracticeDB;` |
| `CREATE TABLE` | Makes a new table with its columns. | `CREATE TABLE Demo (ID INT);` |
| `CREATE TABLE ... AS SELECT` | Makes a table from a query result: data is copied, keys are not. | `CREATE TABLE Backup AS SELECT * FROM Emp;` |
| `CREATE TABLE ... LIKE` | Makes an empty table with the same structure and keys as another. | `CREATE TABLE Shell LIKE Emp;` |
| `DROP TABLE` | Deletes the whole table, structure and data. | `DROP TABLE Demo;` |
| `DROP TABLE IF EXISTS` | Same, but does not give an error if the table is missing. | `DROP TABLE IF EXISTS Demo;` |
| `TRUNCATE TABLE` | Removes all rows quickly, keeps the table, and resets `AUTO_INCREMENT`. No `WHERE`. | `TRUNCATE TABLE Demo;` |
| `ALTER TABLE` | Changes an existing table. Used with the options below. | `ALTER TABLE Emp ...;` |
| `ADD COLUMN` | Adds a column. | `ALTER TABLE Emp ADD COLUMN Phone VARCHAR(15);` |
| `MODIFY COLUMN` | Changes a column's type or rules. | `ALTER TABLE Emp MODIFY COLUMN Phone VARCHAR(20);` |
| `RENAME COLUMN ... TO` | Renames a column. | `ALTER TABLE Emp RENAME COLUMN Phone TO Mobile;` |
| `DROP COLUMN` | Removes a column and its data. | `ALTER TABLE Emp DROP COLUMN Mobile;` |
| `ADD CONSTRAINT` | Adds a named rule to a table. | `ALTER TABLE Emp ADD CONSTRAINT uq_email UNIQUE (Email);` |
| `RENAME TABLE ... TO` | Renames a table. | `RENAME TABLE Employees TO Emp;` |
| `CREATE INDEX` | Builds a lookup structure on a column to speed up searches. | `CREATE INDEX idx_pid ON Emp(PId);` |
| `DROP INDEX` | Removes an index (also how a UNIQUE constraint is removed). | `ALTER TABLE Emp DROP INDEX uq_email;` |

## 4. Constraints and column options

| Keyword | Meaning | Example |
|---|---|---|
| `PRIMARY KEY` | Unique, not-null identifier for each row. One per table. | `EmpID INT PRIMARY KEY` |
| `FOREIGN KEY` | Declares which column links to another table. | `FOREIGN KEY (DeptID) ...` |
| `REFERENCES` | Names the parent table and column a foreign key points to. | `REFERENCES Departments(DeptID)` |
| `UNIQUE` | No two rows may have the same value (several NULLs are allowed in MySQL). | `DeptName VARCHAR(50) UNIQUE` |
| `NOT NULL` | The column must always have a value. | `FirstName VARCHAR(50) NOT NULL` |
| `CHECK` | A condition every row must satisfy. | `CHECK (Salary >= 0)` |
| `DEFAULT` | The value used when you do not supply one. | `IsActive BOOLEAN DEFAULT TRUE` |
| `AUTO_INCREMENT` | The database numbers new rows automatically (1, 2, 3, ...). | `EmpID INT AUTO_INCREMENT` |
| `CONSTRAINT name` | Gives a rule a name so you can drop it later. | `CONSTRAINT chk_rating CHECK (...)` |
| `DROP CHECK` | Removes a named CHECK constraint. | `ALTER TABLE Emp DROP CHECK chk_sal_max;` |
| `DROP FOREIGN KEY` | Removes a named foreign key. | `ALTER TABLE Projects DROP FOREIGN KEY fk_proj_dept;` |
| `CHARACTER SET` | The set of characters a text column can store. | `CHARACTER SET utf8mb4` |
| `utf8mb4` | The full Unicode character set (supports Hindi, Marathi, emoji). Default in MySQL 8. | |
| `COLLATE` | The rules for comparing and sorting text (for example case-insensitive). | `COLLATE utf8mb4_unicode_ci` |

## 5. Data types

| Type | Meaning |
|---|---|
| `INT` | Whole number up to about 2.1 billion. |
| `TINYINT` | Very small whole number (-128 to 127). |
| `DECIMAL(p,s)` | Exact number: `p` total digits, `s` after the decimal point. `DECIMAL(10,2)` fits 12345678.90. Use for money. |
| `VARCHAR(n)` | Text of variable length up to `n` characters. |
| `CHAR(n)` | Text of fixed length, padded with spaces. |
| `DATE` | A date: `2021-03-15`. |
| `DATETIME` | A date and time: `2021-03-15 14:30:00`. |
| `BOOLEAN` | True or false. MySQL stores it as `TINYINT(1)`: 1 = true, 0 = false. |
| `TRUE`, `FALSE` | The values 1 and 0. |

---

## 6. Changing data (DML)

| Keyword | Meaning | Example |
|---|---|---|
| `INSERT INTO ... VALUES` | Adds one or more rows. | `INSERT INTO Departments (DeptName) VALUES ('Ops');` |
| `INSERT INTO ... SELECT` | Adds rows copied from a query result. | `INSERT INTO Backup SELECT * FROM Emp;` |
| `UPDATE ... SET` | Changes values in existing rows. Always add `WHERE`. | `UPDATE Emp SET Salary = 58000 WHERE EmpID = 1;` |
| `DELETE FROM` | Removes rows. Always add `WHERE`. | `DELETE FROM Emp WHERE EmpID = 8;` |
| `LAST_INSERT_ID()` | Returns the last auto-generated id. | `SELECT LAST_INSERT_ID();` |

## 7. Reading data: SELECT and its clauses

| Keyword | Meaning | Example |
|---|---|---|
| `SELECT` | Chooses which columns or expressions to show. | `SELECT FirstName FROM Emp;` |
| `*` | All columns. | `SELECT * FROM Emp;` |
| `FROM` | Names the table to read. | `FROM Emp` |
| `DISTINCT` | Removes duplicate rows from the result. | `SELECT DISTINCT DeptID FROM Emp;` |
| `AS` | Gives a column or table an alias. | `Salary * 12 AS Annual` |
| Backticks `` ` ` `` | Wrap names that contain spaces or reserved words. | ``AS `Annual Salary` `` |
| `WHERE` | Keeps only rows that meet a condition, before grouping. | `WHERE DeptID = 2` |
| `ORDER BY` | Sorts the result. | `ORDER BY Salary DESC` |
| `ASC` | Ascending order (smallest first). The default. | |
| `DESC` | Descending order (largest first). | |
| `LIMIT n` | Returns at most `n` rows. | `LIMIT 3` |
| `OFFSET n` | Skips the first `n` rows (used for pagination). | `LIMIT 4 OFFSET 4` |
| `LIMIT a, b` | Short form: skip `a` rows, return `b` rows. | `LIMIT 4, 4` |
| `GROUP BY` | Collapses rows with the same value into groups, for aggregates. | `GROUP BY DeptID` |
| `HAVING` | Filters groups after grouping (`WHERE` cannot use aggregates). | `HAVING COUNT(*) > 2` |
| `JOIN ... ON` | Combines rows from two tables where the `ON` condition matches. | `Emp e JOIN Departments d ON e.DeptID = d.DeptID` |
| `INNER JOIN` | Keeps only rows that match in both tables. | |
| `LEFT JOIN` | Keeps all rows from the left table; unmatched right columns become NULL. | |
| `UNION` | Stacks the results of two queries and removes duplicates. | |

## 8. Operators and conditions

| Operator | Meaning | Example |
|---|---|---|
| `=` | Equal to. | `DeptID = 2` |
| `<>` or `!=` | Not equal to. | `Salary <> 55000` |
| `>`, `<`, `>=`, `<=` | Greater, less, greater or equal, less or equal. | `Salary >= 60000` |
| `AND` | Both conditions must be true. Runs before `OR`. | `DeptID = 2 AND Salary > 65000` |
| `OR` | At least one condition must be true. | `DeptID = 1 OR DeptID = 4` |
| `NOT` | Reverses a condition. | `NOT DeptID = 1` |
| `IN (...)` | Matches any value in a list. | `DeptID IN (1, 3)` |
| `NOT IN (...)` | Matches none of the values (NULLs are dropped). | `DeptID NOT IN (1, 3)` |
| `BETWEEN a AND b` | Within a range, including both ends. | `Salary BETWEEN 50000 AND 60000` |
| `LIKE` | Pattern match on text. | `FirstName LIKE 'A%'` |
| `%` | In `LIKE`: any number of characters (including none). | `'%an%'` |
| `_` | In `LIKE`: exactly one character. | `'_a%'` |
| `REGEXP` | Match with a regular expression. | `FirstName REGEXP '^[ARP]'` |
| `IS NULL` | The value is missing. | `Salary IS NULL` |
| `IS NOT NULL` | The value is present. | `PId IS NOT NULL` |
| `+ - * /` | Arithmetic. (`+` does not join text in MySQL; use `CONCAT`.) | `Salary * 12` |
| `( )` | Parentheses control evaluation order. | `A AND (B OR C)` |
| `--` | Comment to the end of the line (needs a space after the dashes). | `-- note` |

---

## 9. Conditional, NULL and conversion functions

| Function | Meaning | Example and result |
|---|---|---|
| `CASE WHEN ... THEN ... ELSE ... END` | If-else logic inside a query; handles many branches. | `CASE WHEN Salary < 50000 THEN 'Low' ELSE 'OK' END` |
| `IF(cond, a, b)` | Returns `a` if the condition is true, otherwise `b`. | `IF(Salary > 60000, 'Yes', 'No')` |
| `IFNULL(x, y)` | Returns `y` when `x` is NULL. | `IFNULL(Salary, 0)` |
| `COALESCE(a, b, c, ...)` | Returns the first value that is not NULL. | `COALESCE(DeptID, 0)` |
| `NULLIF(a, b)` | Returns NULL if `a` equals `b`, otherwise `a`. | `NULLIF(10, 10)` gives NULL |
| `CAST(x AS type)` | Converts a value to another type. | `CAST(Salary AS SIGNED)` |
| `SIGNED` | The whole-number type used in `CAST`. | |

## 10. String functions

| Function | Meaning | Example and result |
|---|---|---|
| `CONCAT(a, b, ...)` | Joins text. Any NULL makes the result NULL. | `CONCAT('Asha',' ','Patil')` gives Asha Patil |
| `CONCAT_WS(sep, a, b, ...)` | Joins with a separator and skips NULLs. | `CONCAT_WS('-', 'a', 'b')` gives a-b |
| `UPPER(x)` / `LOWER(x)` | Converts to capitals / small letters. | `UPPER('asha')` gives ASHA |
| `CHAR_LENGTH(x)` | Number of characters. | `CHAR_LENGTH('Asha')` gives 4 |
| `LENGTH(x)` | Number of bytes (differs from characters for non-English text). | |
| `LEFT(x, n)` / `RIGHT(x, n)` | First / last `n` characters. | `LEFT('Patil', 2)` gives Pa |
| `SUBSTRING(x, start, len)` | Part of a string, positions start at 1. | `SUBSTRING('Patil', 2, 3)` gives ati |
| `SUBSTRING_INDEX(x, d, n)` | Text before the `n`th delimiter (negative `n` counts from the right). | `SUBSTRING_INDEX('a@b.com','@',-1)` gives b.com |
| `LOCATE(find, x)` | Position of text inside a string (0 if not found). | `LOCATE('@','a@b.com')` gives 2 |
| `REPLACE(x, old, new)` | Replaces every occurrence of `old` with `new`. | `REPLACE('a@corp.com','corp','co')` |
| `TRIM(x)` | Removes spaces from both ends. | `TRIM('  hi  ')` gives hi |
| `REVERSE(x)` | Reverses the characters. | `REVERSE('abc')` gives cba |

## 11. Numeric functions

| Function | Meaning | Example and result |
|---|---|---|
| `ROUND(x, d)` | Rounds to `d` decimals; negative `d` rounds to tens, hundreds, thousands. | `ROUND(55432, -3)` gives 55000 |
| `CEILING(x)` | Rounds up to a whole number. | `CEILING(2.1)` gives 3 |
| `FLOOR(x)` | Rounds down to a whole number. | `FLOOR(2.9)` gives 2 |
| `ABS(x)` | Removes the minus sign. | `ABS(-15)` gives 15 |
| `MOD(a, b)` | Remainder of `a / b`. | `MOD(17, 5)` gives 2 |
| `POWER(a, b)` | `a` raised to the power `b`. | `POWER(2, 10)` gives 1024 |

## 12. Date and time functions

| Function | Meaning | Example and result |
|---|---|---|
| `NOW()` | Current date and time. | `2026-10-09 14:30:00` |
| `CURDATE()` / `CURRENT_DATE` | Today's date. | `2026-10-09` |
| `CURTIME()` | Current time. | |
| `YEAR(d)`, `MONTH(d)`, `DAY(d)` | Extracts that part of a date. | `YEAR('2021-03-15')` gives 2021 |
| `MONTHNAME(d)`, `DAYNAME(d)` | Month or weekday name. | `MONTHNAME('2021-03-15')` gives March |
| `TIMESTAMPDIFF(unit, a, b)` | Whole units between two dates (YEAR, MONTH, DAY, ...). | `TIMESTAMPDIFF(YEAR, HireDate, CURDATE())` |
| `DATEDIFF(a, b)` | Days between two dates (`a` minus `b`). | `DATEDIFF(CURDATE(), HireDate)` |
| `DATE_ADD(d, INTERVAL n unit)` | Adds time to a date. | `DATE_ADD(HireDate, INTERVAL 1 YEAR)` |
| `DATE_SUB(d, INTERVAL n unit)` | Subtracts time from a date. | `DATE_SUB(CURDATE(), INTERVAL 3 YEAR)` |
| `INTERVAL n unit` | A length of time (DAY, MONTH, YEAR, ...) used inside date functions. | |
| `LAST_DAY(d)` | Last date of that date's month. | `LAST_DAY('2024-02-10')` gives 2024-02-29 |
| `DATE_FORMAT(d, format)` | Shows a date in your chosen format. | `DATE_FORMAT(HireDate, '%d-%b-%Y')` gives 15-Mar-2021 |

Common `DATE_FORMAT` codes: `%d` day (01-31), `%m` month number, `%b` short month name (Mar), `%M` full month name (March), `%Y` four-digit year, `%y` two-digit year, `%H:%i:%s` hours, minutes, seconds.

## 13. Aggregate functions (summarise many rows into one)

| Function | Meaning | Note |
|---|---|---|
| `COUNT(*)` | Number of rows. | Counts rows with NULLs too. |
| `COUNT(col)` | Number of rows where `col` is not NULL. | |
| `SUM(col)` | Total of the values. | Ignores NULL. |
| `AVG(col)` | Average. | Ignores NULL (so the divisor can be smaller than the row count). |
| `MAX(col)` / `MIN(col)` | Largest / smallest value. | Ignores NULL. |

---

## 14. Transactions, safety and permissions

| Keyword | Meaning | Example |
|---|---|---|
| `START TRANSACTION` | Begins a transaction: changes stay pending. | `START TRANSACTION;` |
| `COMMIT` | Makes the pending changes permanent. | `COMMIT;` |
| `ROLLBACK` | Cancels all pending changes since the transaction began. | `ROLLBACK;` |
| `SAVEPOINT name` | Marks a point inside a transaction you can return to. | `SAVEPOINT sp1;` |
| `ROLLBACK TO SAVEPOINT name` | Undoes only the changes after that point. | `ROLLBACK TO SAVEPOINT sp1;` |
| `SET SQL_SAFE_UPDATES` | Workbench safety switch. `1` blocks `UPDATE`/`DELETE` that do not use a key column (error 1175); `0` allows them. | `SET SQL_SAFE_UPDATES = 0;` |
| `GRANT` | Gives a user permission. | `GRANT SELECT ON PracticeDB.Emp TO 'user1'@'localhost';` |
| `REVOKE` | Takes a permission back. | `REVOKE SELECT ON PracticeDB.Emp FROM 'user1'@'localhost';` |

Note: `CREATE`, `ALTER`, `DROP`, `TRUNCATE` and `RENAME` commit automatically in MySQL, so you cannot roll them back.

## 15. Inspection commands

| Command | Meaning |
|---|---|
| `SHOW DATABASES;` | Lists all databases. |
| `SHOW TABLES;` | Lists tables in the current database. |
| `DESCRIBE Emp;` | Shows columns, types, keys and defaults. |
| `SHOW CREATE TABLE Emp;` | Shows the full `CREATE TABLE` statement. |
| `SHOW INDEX FROM Emp;` | Lists indexes and keys. |
| `SHOW WARNINGS;` | Shows warnings from the last statement (for example a bad `CAST`). |
| `SHOW CHARACTER SET;` | Lists supported character sets. |
| `SELECT VERSION();` | Shows your MySQL version. |
