-- Project Task
-- CRUD (CREATE, READ, UPDATE, DELETE) OPERATIONS

-- TASK 1: Create a New Book Record 
-- "'978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- TASK 2: Update an Existing Member's Address

UPDATE members
SET member_address = 'Laxmi Nagar'
WHERE member_id = 'C101';

-- TASK 3:  Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS136' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = 'IS136';

-- TASK 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';

-- TASK 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT issued_emp_id, 
       COUNT(issued_id) as total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;

-- CTAS (CREATE TABLE AS SELECT)

-- TASK 6: Create Summary Tables: Used CTAS to generate new tables based on query results 
-- each book and total book_issued_cnt**

CREATE TABLE books_cnts 
AS 
SELECT b.isbn,
	COUNT(ist.issued_id) as no_issued
FROM books b 
JOIN issued_status ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn;

SELECT * FROM books_cnts;

-- TASK 7: Retrieve All Books in a Specific Category e.g 'Classic'

SElECT * FROM books
WHERE category = 'Classic';

-- TASK 8: Find Total Rental Income by Category

SELECT b.category, 
       SUM(b.rental_price) as rental_income
FROM books b 
JOIN issued_status ist
GROUP BY b.category;

-- TASK 9: List Members Who Registered in the Last 180 Days

SELECT * FROM members
WHERE reg_date >= curdate() - INTERVAL 180 DAY ;

-- TASK 10: List Employees with Their Branch Manager's Name and their branch details:

SELECT e1.emp_id,
       e1.emp_name,
       e2.emp_name as manager,
       b.*
	FROM employees e1
JOIN branch b
ON b.branch_id = e1.branch_id
JOIN employees e2
ON b.manager_id = e2.emp_id;

-- TASK 11: Create a Table of Books with Rental Price Above a Certain Threshold 7 USD:

CREATE TABLE expensive_books
AS 
SELECT * FROM books
WHERE rental_price > 7.00;

SELECT * FROM expensive_books;

-- TASK 12: Retrieve the List of Books Not Yet Returned

SELECT * 
FROM issued_status ist
LEFT JOIN return_status rst
ON ist.issued_id = rst.issued_id
WHERE return_date IS NULL;

-- TASK 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 50-day return period). 
-- Display the member's_id, member's name, book title, issue date, and days overdue.

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

-- TASK 14: BRANCH PERFORMANCE REPORT
-- Create a query that generates a performance report for each branch, showing the number of books issued,
-- the number of books returned, and the total revenue generated from book rentals.

select * from branch;
select * from issued_status;
select * from employees;
select * from books;
select * from return_status;

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

-- TASK 15: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
-- containing members who have issued at least one book in the last 2 months.

SELECT * FROM MEMBERS;
SELECT * FROM issued_status;

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

-- TASK 16:  Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. 
-- Display the employee name, number of books processed, and their branch.

SELECT * FROM EMPLOYEES;
SELECT * FROM BRANCH;
SELECT * FROM issued_status;

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













 




