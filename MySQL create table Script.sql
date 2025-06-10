Use library_project;
-- LIBRARY MANAGEMENT SYSTEM PROJECT

-- BRANCH TABLE
DROP TABLE IF EXISTS branch;
     CREATE TABLE branch
    ( branch_id VARCHAR(10) PRIMARY KEY,
       manager_id VARCHAR(10),
	   branch_address VARCHAR(55),
	   contact_no VARCHAR(10)
    );
    
    ALTER TABLE branch
    MODIFY COLUMN contact_no VARCHAR(15);
  
-- EMPLOYEES TABLE
  CREATE TABLE employees
  ( emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(25),
    salary INT,
    branch_id VARCHAR(25)              -- 4FK
    );
      
	ALTER TABLE EMPLOYEES
    ADD COLUMN position VARCHAR(15);
      
-- BOOKS TABLE
    DROP TABLE IF EXISTS books;
    CREATE TABLE books
    ( isbn VARCHAR(20)  PRIMARY KEY,
      book_title VARCHAR(75),
      category VARCHAR(10),
      rental_price FLOAT,
      status VARCHAR(15),
      author VARCHAR(35),
      publisher VARCHAR(55)
      );
      
      ALTER TABLE books
      MODIFY COLUMN category VARCHAR(20);
      
-- MEMBERS TABLE
      DROP TABLE IF EXISTS members;
      CREATE TABLE members
      ( member_id VARCHAR(20) PRIMARY KEY,
        member_name VARCHAR(25),
        member_address VARCHAR(75),
        reg_date DATE
        );
        
-- ISSUED_STATUS
         DROP TABLE IF EXISTS issued_status;
        CREATE TABLE issued_status
        ( issued_id VARCHAR(10) PRIMARY KEY,
		  issued_member_id VARCHAR(10),         -- 1FK
          issued_book_name VARCHAR(75),
          issued_date DATE,
          issued_book_isbn VARCHAR(25),         -- 2FK
          issued_emp_id VARCHAR(10)             -- 3FK
         );      
         
         
-- RETURN STATUS
         CREATE TABLE return_status
         ( return_id VARCHAR(10) PRIMARY KEY,
		   issued_id VARCHAR(10),                -- 5FK
           return_book_name VARCHAR(75),
           return_date DATE,
           return_book_isbn VARCHAR(20)          
           );
           
-- FOREIGN KEY

-- 1Fk issued_status(issued_member_id) from members(member_id)
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

-- 2Fk issued_status(issued_book_isbn) from books(isbn)
ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

-- 3Fk issued_status(issued_emp_id) from employees(emp_id)
ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

-- 4Fk employees(branch_id) from branch(branch_id)
ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);


-- 5FK
ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

-- IMPORTED TABLE DATA THROUGH CSV FILES.
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;






