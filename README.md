# Library Management using SQL Project 

## Project Overview

**Project Title**: Library Management System  
**Database**: `library_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/roshnipalesha/Library_management/blob/main/ERD%20Diagram.png)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_db;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = 'Laxmi Nagar'
WHERE member_id = 'C101';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS136' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE   issued_id =   'IS136';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT
    issued_emp_id,
    COUNT(issued_id) as total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE books_cnts 
AS 
SELECT b.isbn,
       COUNT(ist.issued_id) as no_issued
FROM books b 
JOIN issued_status ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT b.category, 
       SUM(b.rental_price) as rental_income
FROM books b 
JOIN issued_status ist
GROUP BY b.category;
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
SELECT * FROM members
WHERE reg_date >= curdate() - INTERVAL 180 DAY ;
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT e1.emp_id,
       e1.emp_name,
       e2.emp_name as manager,
       b.*
	FROM employees e1
JOIN branch b
ON b.branch_id = e1.branch_id
JOIN employees e2
ON b.manager_id = e2.emp_id;
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT * 
FROM issued_status ist
LEFT JOIN return_status rst
ON ist.issued_id = rst.issued_id
WHERE return_date IS NULL;
```

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.(50 DAYS)

```sql
SELECT * FROM BOOKS;
SELECT * FROM issued_status;
select * from members;
select * from return_status;

SELECT m.member_id,
       m.member_name,
       b.book_title,
       ist.issued_date,
       datediff( IFNULL(rst.return_date, curdate()) , ist.issued_date) as overdue_duration
FROM books b 
JOIN issued_status ist 
ON b.isbn = ist.issued_book_isbn
JOIN members m 
ON ist.issued_member_id = m.member_id
LEFT JOIN return_status rst
ON rst.issued_id = ist.issued_id
WHERE datediff( IFNULL(rst.return_date, curdate()) , ist.issued_date) > 50
ORDER BY 1;
```

**Task 14: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
CREATE TABLE branch_reports
AS
SELECT 
	b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as book_issued,
    COUNT(rst.return_id) as book_returned,
    SUM(bk.rental_price) as total_revenue
FROM issued_status ist
JOIN employees e
ON ist.issued_emp_id = e.emp_id
JOIN branch b
ON e.branch_id = b.branch_id
LEFT JOIN return_status rst
ON ist.issued_id = rst.issued_id
JOIN books bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1,2;

SELECT * FROM branch_reports;
```

**Task 15: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

CREATE TABLE active_members
AS
SELECT 
		member_id, 
        member_name
FROM members
WHERE member_id IN ( SELECT 
	                  DISTINCT issued_member_id
				   FROM issued_status
                   WHERE issued_date <= CURDATE() - INTERVAL 2 MONTH );

SELECT * FROM active_members;

```


**Task 16: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT 
	e.emp_name,
    COUNT(ist.issued_id) as no_books_processed,
    b.branch_address
FROM employees e 
JOIN branch b
ON e.branch_id = b.branch_id
JOIN issued_status ist
ON e.emp_id = ist.issued_emp_id
GROUP BY 1,3
ORDER BY COUNT(ist.issued_id) DESC
LIMIT 3;
```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## Author - Roshni Palesha
