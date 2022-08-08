-- 1 SQL Server Data Types
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-data-types/

-- https://www.sqlservertutorial.net/wp-content/uploads/SQL-Server-Data-Types.png


-- 2 SQL Server BIT
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-bit/

-- SQL Server BIT data type is an integer data type that can take a value of 0, 1, or NULL.
-- SQL Server optimizes storage of BIT columns. If a table has 8 or fewer bit columns, SQL Server stores them as 1 byte. If a table has 9 up to 16 bit columns, SQL Server stores them as 2 bytes, and so on.
-- Convierte cualquier numero mayor a 0 EN 1, AL IGUAL QUE UN TRUE CONVIERTE EN 1
-- CONVIERTE UN FALSE EN 0

-- 3 SQL Server INT
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-int/

Data type	Range	                                                                Storage
BIGINT	    -263 (-9,223,372,036,854,775,808) to 263-1 (9,223,372,036,854,775,807)	8 Bytes
INT	        -231 (-2,147,483,648) to 231-1 (2,147,483,647)	                        4 Bytes
SMALLINT	-215 (-32,768) to 215-1 (32,767)	                                    2 Bytes
TINYINT	    0 to 255	                                                            1 Byte

SELECT 2147483647 / 3 AS r1, 
	   2147483649 / 3 AS r2;

    --    CHANGE FROM INT TO DECIMAL

-- 4 SQL Server Decimal
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-decimal/



-- DECIMAL(p,s)
-- p is the precision which is the maximum total number of decimal digits that will be stored, both to the left and to the right of the decimal point. The precision has a range from 1 to 38. The default precision is 38.
-- s is the scale which is the number of decimal digits that will be stored to the right of the decimal point. The scale has a range from 0 to p (precision). The scale can be specified only if the precision is specified. By default, the scale is zero.
Precision	Storage bytes
1 – 9	    5
10-19	    9
20-28	    13
29-38	    17

The NUMERIC and DECIMAL are synonyms, therefore, you can use them interchangeably.

DECIMAL(10,2)
NUMERIC(10,2)

DECIMAL(10,2)
DEC(10,2)


CREATE TABLE test.sql_server_decimal (
    dec_col DECIMAL (4, 2),
    num_col NUMERIC (4, 2)
);

-- ok
INSERT INTO test.sql_server_decimal (dec_col, num_col)
VALUES
    (10.05, 20.05);

--error 
INSERT INTO test.sql_server_decimal (dec_col, num_col)
VALUES
    (99.999, 12.345);
-- Arithmetic overflow error converting numeric to data type numeric.
-- The statement has been terminated

-- 5-SQL Server CHAR Data Type
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-char/

When you insert a string value into a CHAR column. If the length of the string value is less than the length specified in the column, SQL Server will add trailing spaces to the string value to the length declared in the column. However, when you select this string value, SQL Server removes the trailing spaces before returning it.

On the other hand, if you insert a value whose length exceeds the column length, SQL Server issues an error message.

Note that the ISO synonym for  CHAR is CHARACTER so you can use them interchangeably.

CREATE TABLE test.sql_server_char (
    val CHAR(3)
);

-- bien 
INSERT INTO test.sql_server_char (val)
VALUES
    ('ABC');
--error
INSERT INTO test.sql_server_char (val)
VALUES
    ('XYZ1');

-- String or binary data would be truncated.
-- The statement has been terminated.


SELECT
    val,
    LEN(val) len,
    DATALENGTH(val) data_length
FROM
    sql_server_char;

-- len es la long del campo insertado, datalength es la longitud permitido de la columna

-- 6 SQL Server NCHAR

--  https://www.sqlservertutorial.net/sql-server-basics/sql-server-nchar/

In this syntax, n specifies the string length that ranges from 1 to 4,000.
The ISO synonyms for NCHAR are NATIONAL CHAR and NATIONAL CHARACTER, therefore, you can use them interchangeably.

CHAR                                    NCHAR
Store only non-Unicode characters.	    Store Unicode characters in the form of UNICODE UCS-2 characters.

Need 1 byte to store a character	    Need 2 bytes to store a character.

The storage size equals the size        The storage size equals double the size specified 
specified in the column definition      in the column definition or variable declaration.
or variable declaration.	

Store up to 8000 characters.	        Store up to 4000 characters.

CREATE TABLE test.sql_server_nchar (
    val NCHAR(1) NOT NULL
);
-- BIEN
INSERT INTO test.sql_server_nchar (val)
VALUES
    (N'あ');

-- MAL 
INSERT INTO test.sql_server_nchar (val)
VALUES
    (N'いえ'); 

-- 7 - SQL Server VARCHAR
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-varchar/
-- The ISO synonyms of VARCHAR are CHARVARYING or CHARACTERVARYING, therefore, you can use them interchangeably.
-- In this syntax, max defines the maximum storage size which is 231-1 bytes (2 GB).

ALTER TABLE test.sql_server_varchar 
ALTER COLUMN val VARCHAR (10) NOT NULL;

-- ok
INSERT INTO test.sql_server_varchar (val)
VALUES
    ('SQL Server');

-- MAL
INSERT INTO test.sql_server_varchar (val)
VALUES
    ('SQL Server VARCHAR');

-- String or binary data would be truncated.
-- The statement has been terminated.

-- 8 - SQL Server NVARCHAR
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-nvarchar/
In this syntax, n defines the string length that ranges from 1 to 4,000. If you don’t specify the string length, its default value is 1.
In this syntax, max is the maximum storage size in bytes which is 2^31-1 bytes (2 GB).

The ISO synonyms of NVARCHAR are NATIONAL CHAR VARYING or NATIONAL CHARACTER VARYING, so you can use them interchangeably in the variable declaration or column data definition.

	
                VARCHAR                     NVARCHAR
Character 	    Variable-length, 	        Variable-length, both Unicode and 
Data Type       non-Unicode characters      non-Unicode characters such as Japanese, Korean, and Chinese.

Maximum Length	Up to 8,000 characters	    Up to 4,000 characters

Character Size	Takes up 1 byte 	        Takes up 2 bytes per Unicode/Non-Unicode character
                per character

Storage Size	Actual Length (in bytes)	2 times Actual Length (in bytes)

Usage	        Used when data length is    Due to storage only, used only if you need Unicode 
                variable or variable        support such as the Japanese Kanji or Korean Hangul characters.  
                length columns and if 
                actual data is always way 
                less than capacity


ALTER TABLE test.sql_server_Nvarchar 
ALTER COLUMN val NVARCHAR (10) NOT NULL;
-- OK
INSERT INTO test.sql_server_varchar (val)
VALUES
    (N'こんにちは');


    -- MAL
    INSERT INTO test.sql_server_nvarchar (val)
VALUES
    (N'ありがとうございました');
String or binary data would be truncated.
The statement has been terminated.


-- 9 -SQL Server DATETIME2
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-datetime2/
The DATETIME2 has two components: date and time.

The date has a range from January 01, 01 (0001-01-01) to December 31, 9999 (9999-12-31)
The time has a range from 00:00:00 to 23:59:59.9999999.
The storage size of a DATETIME2 value depends on the fractional seconds precision. It requires 6 bytes for the precision that is less than 3, 7 bytes for the precision that is between 3 and 4, and 8 bytes for all other precisions.

The default string literal format of the DATETIME2 is as follows:

YYYY-MM-DD hh:mm:ss[.fractional seconds]

INSERT INTO production.product_colors (color_name, created_at)
VALUES
    ('Green', '2018-06-23 07:30:20');

-- 10 - SQL Server DATE
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-date/


Unlike the DATETIME2 data type, the DATE data type has only the date component. The range of a DATE value is from January 1, 1 CE (0001-01-01) through December 31, 9999 CE (9999-12-31).

--11 SQL Server TIME
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-time/

-- The SQL Server TIME data type defines a time of a day based on 24-hour clock. The syntax of the TIME data type is as follows:

-- The fractional second scale specifies the number of digits for the fractional part of the seconds. The fractional second scale ranges from 0 to 7. By default, the fractional second scale is 7 if you don’t explicitly specify it.

hh:mm:ss[.nnnnnnn]

--12 SQL Server DATETIMEOFFSET

-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-datetimeoffset/
The DATETIMEOFFSET allows you to manipulate any single point in time, which is a datetime value, along with an offset that specifies how much that datetime differs from UTC.

00:00:00 through 23:59:59.9999999

INSERT INTO messages(message,created_at)
VALUES('DATETIMEOFFSET demo',
        CAST('2019-02-28 01:45:00.0000000 -08:00' AS DATETIMEOFFSET));

-- 13 guid
--  https://www.sqlservertutorial.net/sql-server-basics/sql-server-guid/
All things in our world are numbered e.g., books have ISBNs, cars have VINs, and people have social security numbers (SSN).
 globally unique identifier or GUID is a broader version of this type of ID numbers.

A GUID is guaranteed to be unique across tables, databases, and even servers.
GUID
------------------------------------
3297F0F2-35D3-4231-919D-1CFCF4035975

(1 row affected)


Using SQL Server GUID as primary key
Sometimes, it prefers using GUID values for the primary key column of a table than using integers.

Using GUID as the primary key of a table brings the following advantages:

GUID values are globally unique across tables, databases, and even servers. Therefore, it allows you to merge data from different servers with ease.
GUID values do not expose the information so they are safer to use in public interface such as a URL. For example, if you have the URL https://www.example.com/customer/100/ URL, it is not so difficult to find that there will have customers with id 101, 102, and so on. However, with GUID, it is not possible: https://www.example.com/customer/F4AB02B7-9D55-483D-9081-CC4E3851E851/
Besides these advantages, storing GUID in the primary key column of a table has the following disadvantages:

GUID values (16 bytes) takes more storage than INT (4 bytes) or even BIGINT(8 bytes)
GUID values make it difficult to troubleshoot and debug, comparing WHERE id = 100 with WHERE id = 'F4AB02B7-9D55-483D-9081-CC4E3851E851'.

-- 14 SQL Server PRIMARY KEY
--https://www.sqlservertutorial.net/sql-server-basics/sql-server-primary-key/

A primary key is a column or a group of columns that uniquely identifies each row in a table. You create a primary key for a table by using the PRIMARY KEY constraint.

If the primary key consists of only one column, you can define use PRIMARY KEY constraint as a column constraint:
Each table can contain only one primary key. All columns that participate in the primary key must be defined as NOT NULL. SQL Server automatically sets the NOT NULL constraint for all the primary key columns if the NOT NULL constraint is not specified for these columns.

CREATE TABLE sales.activities (
    activity_id INT PRIMARY KEY IDENTITY,
    activity_name VARCHAR (255) NOT NULL,
    activity_date DATE NOT NULL
);
The IDENTITY property is used for the activity_id column to automatically generate unique integer values.

-- 15 SQL Server FOREIGN KEY
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-foreign-key/
-- The foreign key constraint ensures referential integrity. It means that you can only insert a row into the child table if there is a corresponding row in the parent table.
-- If you delete one or more rows in the parent table, you can set one of the following actions:

-- ON DELETE NO ACTION: SQL Server raises an error and rolls back the delete action on the row in the parent table.
-- ON DELETE CASCADE: SQL Server deletes the rows in the child table that is corresponding to the row deleted from the parent table.
-- ON DELETE SET NULL: SQL Server sets the rows in the child table to NULL if the corresponding rows in the parent table are deleted. To execute this action, the foreign key columns must be nullable.
-- ON DELETE SET DEFAULT SQL Server sets the rows in the child table to their default values if the corresponding rows in the parent table are deleted. To execute this action, the foreign key columns must have default definitions. Note that a nullable column has a default value of NULL if no default value specified.
-- By default, SQL Server appliesON DELETE NO ACTION if you don’t explicitly specify any action.

-- ON UPDATE NO ACTION: SQL Server raises an error and rolls back the update action on the row in the parent table.
-- ON UPDATE CASCADE: SQL Server updates the corresponding rows in the child table when the rows in the parent table are updated.
-- ON UPDATE SET NULL: SQL Server sets the rows in the child table to NULL when the corresponding row in the parent table is updated. Note that the foreign key columns must be nullable for this action to execute.
-- ON UPDATE SET DEFAULT: SQL Server sets the default values for the rows in the child table that have the corresponding rows in the parent table updated.

FOREIGN KEY (foreign_key_columns)
    REFERENCES parent_table(parent_key_columns)
    ON UPDATE action 
    ON DELETE action;

DROP TABLE vendors;

CREATE TABLE procurement.vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
        CONSTRAINT fk_group FOREIGN KEY (group_id) 
        REFERENCES procurement.vendor_groups(group_id)
);

-- 16 SQL Server NOT NULL Constraint
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-not-null-constraint/
The SQL Server NOT NULL constraints simply specify that a column must not assume the NULL.
-- de null a not null
ALTER TABLE table_name
ALTER COLUMN column_name data_type NOT NULL;


UPDATE hr.persons
SET phone = "(408) 123 4567"
WHER phone IS NULL;

-- de no null a null
ALTER TABLE table_name
ALTER COLUMN column_name data_type NULL;

-- 17 SQL Server UNIQUE Constraint
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-unique-constraint/
SQL Server UNIQUE constraints allow you to ensure that the data stored in a column, or a group of columns, is unique among the rows in a table.

The following statement creates a table whose data in the email column is unique among the rows in the hr.persons table:

CREATE SCHEMA hr;
GO

CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE
);

In this syntax, you define the UNIQUE constraint as a column constraint. You can also define the UNIQUE constraint as a table constraint, like this:

CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    UNIQUE(email)
);

Behind the scenes, SQL Server automatically creates a UNIQUE index to enforce the uniqueness of data stored in the columns that participate in the UNIQUE constraint. Therefore, if you attempt to insert a duplicate row, SQL Server rejects the change and returns an error message stating that the UNIQUE constraint has been violated.

CREATE TABLE hr.persons (
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    CONSTRAINT unique_email UNIQUE(email)
);

-- The following are the benefits of assigning a UNIQUE constraint a specific name:

-- It easier to classify the error message.
-- You can reference the constraint name when you want to modify it.

-- UNIQUE constraint vs. PRIMARY KEY constraint
-- Although both UNIQUE and PRIMARY KEY constraints enforce the uniqueness of data, you should use the UNIQUE constraint instead of PRIMARY KEY constraint when you want to enforce the uniqueness of a column, or a group of columns, that are not the primary key columns.

-- Different from PRIMARY KEY constraints, UNIQUE constraints allow NULL. Moreover, UNIQUE constraints treat the NULL as a regular value, therefore, it only allows one NULL per column.

-- UNIQUE constraints for a group of columns
CREATE TABLE table_name (
    key_column data_type PRIMARY KEY,
    column1 data_type,
    column2 data_type,
    column3 data_type,
    ...,
    UNIQUE (column1,column2)
);

ALTER TABLE table_name
ADD CONSTRAINT constraint_name 
UNIQUE(column1, column2,...);

ALTER TABLE hr.persons
DROP CONSTRAINT unique_phone;

Modify UNIQUE constraints
SQL Server does not have any direct statement to modify a UNIQUE constraint, therefore, you need to drop the constraint first and recreate it if you want to change the constraint.

In this tutorial, you have learned how to use the SQL Server UNIQUE constraint to make sure that the data contained in a column or a group of columns is unique.

-- 18 SQL Server CHECK Constraint
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-check-constraint/
The CHECK constraint allows you to specify the values in a column that must satisfy a Boolean expression.

CREATE SCHEMA test;
GO

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0)
);
For example, to require positive unit prices, you can use:

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CONSTRAINT positive_price CHECK(unit_price > 0)
);


INSERT INTO test.products(product_name, unit_price)
VALUES ('Awesome Free Bike', 0);

The INSERT statement conflicted with the CHECK constraint "positive_price". The conflict occurred in database "BikeStores", table "test.products", column 'unit_price'.

SQL Server CHECK constraint and NULL
The CHECK constraints reject values that cause the Boolean expression evaluates to FALSE.

Because NULL evaluates to UNKNOWN, it can be used in the expression to bypass a constraint.
INSERT INTO test.products(product_name, unit_price)
VALUES ('Another Awesome Bike', NULL);


CHECK constraint referring to multiple columns

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0),
    discounted_price DEC(10,2) CHECK(discounted_price > 0),
    CHECK(discounted_price < unit_price)
);

The first two constraints for unit_price and discounted_price should look familiar.

The third constraint uses a new syntax which is not attached to a particular column. Instead, it appears as a separate line item in the comma-separated column list.

The first two column constraints are column constraints, whereas the third one is a table constraint.

Note that you can write column constraints as table constraints. However, you cannot write table constraints as column constraints. For example, you can rewrite the above statement as follows:

CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0),
    CHECK(discounted_price > unit_price)
);

ALTER TABLE test.products
ADD CONSTRAINT positive_price CHECK(unit_price > 0);

ALTER TABLE table_name
DROP CONSTRAINT constraint_name;

-- Disable CHECK constraints for insert or update

ALTER TABLE table_name
NOCHECK CONSTRAINT constraint_name;
ALTER TABLE test.products
NO CHECK CONSTRAINT valid_price;

-- 19 SQL Server CASE
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-case/



SQL Server CASE expression evaluates a list of conditions and returns one of the multiple specified results. The CASE expression has two formats: simple CASE expression and searched CASE expression. Both of CASE expression formats support an optional ELSE statement.

SELECT    
    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
    END AS order_status, 
    COUNT(order_id) order_count
FROM    
    sales.orders
WHERE 
    YEAR(order_date) = 2018
GROUP BY 
    order_status;


SELECT    
    SUM(CASE
            WHEN order_status = 1
            THEN 1
            ELSE 0
        END) AS 'Pending', 
    SUM(CASE
            WHEN order_status = 2
            THEN 1
            ELSE 0
        END) AS 'Processing', 
    SUM(CASE
            WHEN order_status = 3
            THEN 1
            ELSE 0
        END) AS 'Rejected', 
    SUM(CASE
            WHEN order_status = 4
            THEN 1
            ELSE 0
        END) AS 'Completed', 
    COUNT(*) AS Total
FROM    
    sales.orders
WHERE 
    YEAR(order_date) = 2018;


First, the condition in the WHERE clause includes sales order in 2018.
Second, the CASE expression returns either 1 or 0 based on the order status.
Third, the SUM() function adds up the number of order for each order status.
Fourth, the COUNT() function returns the total orders.

The following statement uses the searched CASE expression to classify sales order by order value:


SELECT    
    o.order_id, 
    SUM(quantity * list_price) order_value,
    CASE
        WHEN SUM(quantity * list_price) <= 500 
            THEN 'Very Low'
        WHEN SUM(quantity * list_price) > 500 AND 
            SUM(quantity * list_price) <= 1000 
            THEN 'Low'
        WHEN SUM(quantity * list_price) > 1000 AND 
            SUM(quantity * list_price) <= 5000 
            THEN 'Medium'
        WHEN SUM(quantity * list_price) > 5000 AND 
            SUM(quantity * list_price) <= 10000 
            THEN 'High'
        WHEN SUM(quantity * list_price) > 10000 
            THEN 'Very High'
    END order_priority
FROM    
    sales.orders o
INNER JOIN sales.order_items i ON i.order_id = o.order_id
WHERE 
    YEAR(order_date) = 2018
GROUP BY 
    o.order_id;

-- 20 - SQL Server COALESCE
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-coalesce/

The SQL Server COALESCE expression accepts a number of arguments, evaluates them in sequence, and returns the first non-null argument.

The COALESCE expression returns the first non-null expression. If all expressions evaluate to NULL, then the COALESCE expression return NULL;

Because the COALESCE is an expression, you can use it in any clause that accepts an expression such as SELECT, WHERE, GROUP BY, and HAVING.

The following example uses the COALESCE expression to return the string 'Hi' because it is the first non-null argument:


SELECT 
    COALESCE(NULL, 'Hi', 'Hello', NULL) result;
return hi

SELECT 
    COALESCE(NULL, NULL, 100, 200) result;
return 100

SELECT 
    first_name, 
    last_name, 
    COALESCE(phone,'N/A') phone, 
    email
FROM 
    sales.customers
ORDER BY 
    first_name, 
    last_name;


SELECT
    staff_id,
    COALESCE(
        hourly_rate*22*8, 
        weekly_rate*4, 
        monthly_rate
    ) monthly_salary
FROM
    salaries;


-- COALESCE vs. CASE expression
-- The COALESCE expression is a syntactic sugar of the CASE expression.
-- Note that the query optimizer may use the CASE expression to rewrite the COALESCE expression.

COALESCE(e1,e2,e3)

CASE
    WHEN e1 IS NOT NULL THEN e1
    WHEN e2 IS NOT NULL THEN e2
    ELSE e3
END


-- 21 SQL Server NULLIF
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-nullif/


The NULLIF expression accepts two arguments and returns NULL if two arguments are equal. Otherwise, it returns the first expression.

It is recommended that you not use the time-dependent functions such as RAND() function in the NULLIF function. Because this may cause the function to be evaluated twice and to yield different results from the two function calls.

SELECT 
    NULLIF(10, 10) result;
result
------
NULL

(1 row affected)

SELECT 
    NULLIF('Hi', 'Hello') result;

result
------
Hello

(1 row affected)

Using NULLIF expression to translate a blank string to NULL

SELECT    
    lead_id, 
    first_name, 
    last_name, 
    phone, 
    email
FROM    
    sales.leads
WHERE 
    NULLIF(phone,'') IS NULL;

NULLIF and CASE expression
This expression that uses NULLIF:

-- equivalent 
SELECT 
    NULLIF(a,b)



CASE 
    WHEN a=b THEN NULL 
    ELSE a 
END



---
DECLARE @a int = 10, @b int = 20;
SELECT
    CASE
        WHEN @a = @b THEN null
        ELSE 
            @a
    END AS result;
----
DECLARE @a int = 10, @b int = 20;
SELECT
    NULLIF(@a,@b) AS result;


--  22 Find Duplicates From a Table in SQL Server
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-find-duplicates/


use the GROUP BY clause or ROW_NUMBER()
To find the duplicate values in a table, you follow these steps:

First, define criteria for duplicates: values in a single column or multiple columns.
Second, write a query to search for duplicates.


SELECT 
    a, 
    b, 
    COUNT(*) occurrences
FROM t1
GROUP BY
    a, 
    b
HAVING 
    COUNT(*) > 1;

-- Using ROW_NUMBER() function to find duplicates in a table

WITH cte AS (
    SELECT 
        a, 
        b, 
        ROW_NUMBER() OVER (
            PARTITION BY a,b
            ORDER BY a,b) rownum
    FROM 
        t1
) 
SELECT 
  * 
FROM 
    cte 
WHERE 
    rownum > 1;


First, the ROW_NUMBER() distributes rows of the t1 table into partitions by values in the a and b columns. The duplicate rows will have repeated values in the a and b columns, but different row numbers as shown in the following picture:


-- 23 Delete Duplicates From a Table in SQL Server
-- https://www.sqlservertutorial.net/sql-server-basics/delete-duplicates-sql-server/    

WITH cte AS (
    SELECT 
        contact_id, 
        first_name, 
        last_name, 
        email, 
        ROW_NUMBER() OVER (
            PARTITION BY 
                first_name, 
                last_name, 
                email
            ORDER BY 
                first_name, 
                last_name, 
                email
        ) row_num
     FROM 
        sales.contacts
)
DELETE FROM cte
WHERE row_num > 1;


-- SQL Server Views
-- https://www.sqlservertutorial.net/sql-server-views/

When you use the SELECT statement to query data from one or more tables, you get a result set.

CREATE VIEW sales.product_info
AS
SELECT
    product_name, 
    brand_name, 
    list_price
FROM
    production.products p
INNER JOIN production.brands b 
        ON b.brand_id = p.brand_id;

SELECT * FROM sales.product_info;

By definition, views do not store data except for indexed views.

A view may consist of columns from multiple tables using joins or just a subset of columns of a single table. This makes views useful for abstracting or hiding complex queries.

Advantages of views

Security
    You can restrict users to access directly to a table and allow them to access a subset of data via views.
    For example, you can allow users to access customer name, phone, email via a view but restrict them to access the bank account and other sensitive information.

Simplicity
    A relational database may have many tables with complex relationships e.g., one-to-one and one-to-many that make it difficult to navigate.
    However, you can simplify the complex queries with joins and conditions using a set of views.

Consistency
    Sometimes, you need to write a complex formula or logic in every query.
    To make it consistent, you can hide the complex queries logic and calculations in views.
    Once views are defined, you can reference the logic from the views rather than rewriting it in separate queries.

SQL Server CREATE VIEW

CREATE VIEW sales.daily_sales
AS
SELECT
    year(order_date) AS y,
    month(order_date) AS m,
    day(order_date) AS d,
    p.product_id,
    product_name,
    quantity * i.list_price AS sales
FROM
    sales.orders AS o
INNER JOIN sales.order_items AS i
    ON o.order_id = i.order_id
INNER JOIN production.products AS p
    ON p.product_id = i.product_id;

REDEFINE
CREATE OR ALTER sales.daily_sales (
    year,
    month,
    day,
    customer_name,
    product_id,
    product_name
    sales
)
AS
SELECT
    year(order_date),
    month(order_date),
    day(order_date),
    concat(
        first_name,
        ' ',
        last_name
    ),
    p.product_id,
    product_name,
    quantity * i.list_price
FROM
    sales.orders AS o
    INNER JOIN
        sales.order_items AS i
    ON o.order_id = i.order_id
    INNER JOIN
        production.products AS p
    ON p.product_id = i.product_id
    INNER JOIN sales.customers AS c
    ON c.customer_id = o.customer_id;


CREATE VIEW sales.staff_sales (
        first_name, 
        last_name,
        year, 
        amount
)
AS 
    SELECT 
        first_name,
        last_name,
        YEAR(order_date),
        SUM(list_price * quantity) amount
    FROM
        sales.order_items i
    INNER JOIN sales.orders o
        ON i.order_id = o.order_id
    INNER JOIN sales.staffs s
        ON s.staff_id = o.staff_id
    GROUP BY 
        first_name, 
        last_name, 
        YEAR(order_date);

SQL Server Rename View

EXEC sp_rename 
    @objname = 'sales.product_catalog',
    @newname = 'product_list';

SQL Server List Views
SELECT 
	OBJECT_SCHEMA_NAME(v.object_id) schema_name,
	v.name
FROM 
	sys.views as v;



Creating a stored procedure to show views in SQL Server Database

CREATE PROC usp_list_views(
	@schema_name AS VARCHAR(MAX)  = NULL,
	@view_name AS VARCHAR(MAX) = NULL
)
AS
SELECT 
	OBJECT_SCHEMA_NAME(v.object_id) schema_name,
	v.name view_name
FROM 
	sys.views as v
WHERE 
	(@schema_name IS NULL OR 
	OBJECT_SCHEMA_NAME(v.object_id) LIKE '%' + @schema_name + '%') AND
	(@view_name IS NULL OR
	v.name LIKE '%' + @view_name + '%');


How to Get Information About a View in SQL Server

SELECT
    definition,
    uses_ansi_nulls,
    uses_quoted_identifier,
    is_schema_bound
FROM
    sys.sql_modules
WHERE
    object_id
    = object_id(
            'sales.daily_sales'
        );



SQL Server DROP VIEW


DROP VIEW [IF EXISTS] 
    schema_name.view_name1, 
    schema_name.view_name2,
    ...;


DROP VIEW IF EXISTS 
    sales.staff_sales, 
    sales.product_catalogs;

SQL Server Indexed View


Regular SQL Server views are the saved queries that provide some benefits such as query simplicity, business logic consistency, and security. However, they do not improve the underlying query performance.

Unlike regular views, indexed views are materialized views that stores data physically like a table hence may provide some the performance benefit if they are used appropriately.

First, create a view that uses the WITH SCHEMABINDING option which binds the view to the schema of the underlying tables.
Second, create a unique clustered index on the view. This materializes the view.

Because of the WITH SCHEMABINDING option, if you want to change the structure of the underlying tables which affect the indexed view’s definition, you must drop the indexed view first before applying the changes.

In addition, SQL Server requires all object references in an indexed view to include the two-part naming
convention i.e., schema.object, and all referenced objects are in the same database.

When the data of the underlying tables changes, the data in the indexed view is also automatically updated. This causes a write overhead for the referenced tables. It means that when you write to the underlying table, SQL Server also has to write to the index of the view. Therefore, you should only create an indexed view against the tables that have in-frequent data updates.


CREATE VIEW product_master
WITH SCHEMABINDING
AS 
SELECT
    product_id,
    product_name,
    model_year,
    list_price,
    brand_name,
    category_name
FROM
    production.products p
INNER JOIN production.brands b 
    ON b.brand_id = p.brand_id
INNER JOIN production.categories c 
    ON c.category_id = p.category_id;

Before creating a unique clustered index for the view, let’s examine the query I/O cost statistics by querying data from a regular view and using the SET STATISTICS IO command:

SET STATISTICS IO ON
GO

SELECT 
    * 
FROM
    production.product_master
ORDER BY
    product_name;
GO 

Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Workfile'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'products'. Scan count 1, logical reads 5, physical reads 1, read-ahead reads 3, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'categories'. Scan count 1, logical reads 2, physical reads 1, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'brands'. Scan count 1, logical reads 2, physical reads 1, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.



CREATE UNIQUE CLUSTERED INDEX 
    ucidx_product_id 
ON production.product_master(product_id);


Note that this feature is only available on SQL Server Enterprise Edition. If you use the SQL Server Standard or Developer Edition, you must use the WITH (NOEXPAND) table hint directly in the FROM clause of the query which you want to use the view like the following query:


SELECT * 
FROM production.product_master 
   WITH (NOEXPAND)
ORDER BY product_name;


