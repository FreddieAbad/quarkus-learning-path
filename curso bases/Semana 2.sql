-- SQL Server UNION
-- 1 https://www.sqlservertutorial.net/sql-server-basics/sql-server-union/
-- The number and the order of the columns must be the same in both queries.
-- The data types of the corresponding columns must be the same or compatible
-- By default, the UNION operator removes all duplicate rows from the result sets. However, if you want to retain the duplicate rows, you need to specify the ALL keyword is explicitly as shown below:
-- UNION vs. JOIN
-- The join such as INNER JOIN or LEFT JOIN combines columns from two tables while the UNION combines rows from two queries.
-- In other words, join appends the result sets horizontally while union appends the result set vertically.
-- The following picture illustrates the main difference between UNION and JOIN:
 
--  dos tablas de 1 x 3 resulta en union una tabla de 1x6
--  dos tablas de 1 x 3 resulta en inner join una tabla de 2x3

SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION
SELECT
    first_name,
    last_name
FROM
    sales.customers;

SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION ALL
SELECT
    first_name,
    last_name
FROM
    sales.customers;

SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION ALL
SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    first_name,
    last_name;

-- 2 INTERSECT
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-intersect/
-- The SQL Server INTERSECT combines result sets of two or more queries and returns distinct rows that are output by both queries.
-- The INNER JOIN will return duplicates, if id is duplicated in either table. INTERSECT removes duplicates. The INNER JOIN will never return NULL, but INTERSECT will return NULL.


SELECT
    city
FROM
    sales.customers
INTERSECT
SELECT
    city
FROM
    sales.stores
ORDER BY
    city;


-- 3 EXCEPT
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-except/
-- The SQL Server EXCEPT compares the result sets of two queries and returns the distinct rows from the first query that are not output by the second query. In other words, the EXCEPT subtracts the result set of a query from another.

-- EXCEPT is set operator that eliminates duplicates. LEFT JOIN is a type of join, that can actually produce duplicates. It is not unusual in SQL that two different things produce the same result set for a given set of input data.


SELECT
    product_id
FROM
    production.products
EXCEPT
SELECT
    product_id
FROM
    sales.order_items
ORDER BY 
	product_id;

-- 4 CTE https://www.sqlservertutorial.net/sql-server-basics/sql-server-cte/
-- CTE stands for common table expression. A CTE allows you to define a temporary named result set that available temporarily in the execution scope of a statement such as SELECT, INSERT, UPDATE, DELETE, or MERGE.


WITH cte_sales_amounts (staff, sales, year) AS (
    SELECT    
        first_name + ' ' + last_name, 
        SUM(quantity * list_price * (1 - discount)),
        YEAR(order_date)
    FROM    
        sales.orders o
    INNER JOIN sales.order_items i ON i.order_id = o.order_id
    INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
    GROUP BY 
        first_name + ' ' + last_name,
        year(order_date)
)

SELECT
    staff, 
    sales
FROM 
    cte_sales_amounts
WHERE
    year = 2018;

--
WITH cte_category_counts (
    category_id, 
    category_name, 
    product_count
)
AS (
    SELECT 
        c.category_id, 
        c.category_name, 
        COUNT(p.product_id)
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
    GROUP BY 
        c.category_id, 
        c.category_name
),
cte_category_sales(category_id, sales) AS (
    SELECT    
        p.category_id, 
        SUM(i.quantity * i.list_price * (1 - i.discount))
    FROM    
        sales.order_items i
        INNER JOIN production.products p 
            ON p.product_id = i.product_id
        INNER JOIN sales.orders o 
            ON o.order_id = i.order_id
    WHERE order_status = 4 -- completed
    GROUP BY 
        p.category_id
) 

SELECT 
    c.category_id, 
    c.category_name, 
    c.product_count, 
    s.sales
FROM
    cte_category_counts c
    INNER JOIN cte_category_sales s 
        ON s.category_id = c.category_id
ORDER BY 
    c.category_name;

-- 5 RECURSIVE CTE

-- A recursive common table expression (CTE) is a CTE that references itself. By doing so, the CTE repeatedly executes, returns subsets of data, until it returns the complete result set.
-- A recursive CTE is useful in querying hierarchical data such as organization charts where one employee reports to a manager or multi-level bill of materials when a product consists of many components, and each component itself also consists of many other components.



WITH cte_numbers(n, weekday) 
AS (
    SELECT 
        0, 
        DATENAME(DW, 0)
    UNION ALL
    SELECT    
        n + 1, 
        DATENAME(DW, n + 1)
    FROM    
        cte_numbers
    WHERE n < 6
)
SELECT 
    weekday
FROM 
    cte_numbers;


-- 6 pivot
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-pivot/
-- convert rows to columns.
SELECT * FROM   
(
    SELECT 
        category_name, 
        product_id
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;

-- Generating column values

DECLARE 
    @columns NVARCHAR(MAX) = '';

SELECT 
    @columns += QUOTENAME(category_name) + ','
FROM 
    production.categories
ORDER BY 
    category_name;

SET @columns = LEFT(@columns, LEN(@columns) - 1);

PRINT @columns;

-- dinamic pivot
DECLARE 
    @columns NVARCHAR(MAX) = '', 
    @sql     NVARCHAR(MAX) = '';

-- select the category names
SELECT 
    @columns+=QUOTENAME(category_name) + ','
FROM 
    production.categories
ORDER BY 
    category_name;

-- remove the last comma
SET @columns = LEFT(@columns, LEN(@columns) - 1);

-- construct dynamic SQL
SET @sql ='
SELECT * FROM   
(
    SELECT 
        category_name, 
        model_year,
        product_id 
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN ('+ @columns +')
) AS pivot_table;';

-- execute the dynamic SQL
EXECUTE sp_executesql @sql;



-- 9 isnert
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-insert/

INSERT INTO sales.promotions (
    promotion_name,
    discount,
    start_date,
    expired_date
)
VALUES
    (
        '2018 Summer Promotion',
        0.15,
        '20180601',
        '20180901'
    );

-- 2) Insert and return inserted values
INSERT INTO sales.promotions (
    promotion_name,
    discount,
    start_date,
    expired_date
) OUTPUT inserted.promotion_id
VALUES
    (
        '2018 Fall Promotion',
        0.15,
        '20181001',
        '20181101'
    );

INSERT INTO sales.promotions (
    promotion_name,
    discount,
    start_date,
    expired_date
) OUTPUT inserted.promotion_id,
 inserted.promotion_name,
 inserted.discount,
 inserted.start_date,
 inserted.expired_date
VALUES
    (
        '2018 Winter Promotion',
        0.2,
        '20181201',
        '20190101'
    );
-- een casos de insert valores id
SET IDENTITY_INSERT sales.promotions ON;

INSERT INTO sales.promotions (
    promotion_id,
    promotion_name,
    discount,
    start_date,
    expired_date
)
VALUES
    (
        4,
        '2019 Spring Promotion',
        0.25,
        '20190201',
        '20190301'
    );


SET IDENTITY_INSERT sales.promotions OFF;


-- 8 insert multiple rows
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-insert-multiple-rows/
INSERT INTO 
	sales.promotions ( 
		promotion_name, discount, start_date, expired_date
	)
OUTPUT inserted.promotion_id
VALUES
	('2020 Summer Promotion',0.25,'20200601','20200901'),
	('2020 Fall Promotion',0.10,'20201001','20201101'),
	('2020 Winter Promotion', 0.25,'20201201','20210101');



-- 9 INSERT INTO SELECT
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-insert-into-select/
-- insert all rows from another table
INSERT INTO sales.addresses (street, city, state, zip_code) 
SELECT
    street,
    city,
    state,
    zip_code
FROM
    sales.customers
ORDER BY
    first_name,
    last_name; 

-- insert select top
INSERT TOP (10) 
INTO sales.addresses (street, city, state, zip_code) 
SELECT
    street,
    city,
    state,
    zip_code
FROM
    sales.customers
ORDER BY
    first_name,
    last_name;

INSERT TOP (10) PERCENT  
INTO sales.addresses (street, city, state, zip_code) 
SELECT
    street,
    city,
    state,
    zip_code
FROM
    sales.customers
ORDER BY
    first_name,
    last_name;

-- 10 update
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-update/
--u'pdate a single column in all rows
UPDATE sales.taxes
SET updated_at = GETDATE();


UPDATE sales.taxes
SET max_local_tax_rate += 0.02,
    avg_local_tax_rate += 0.01
WHERE
    max_local_tax_rate = 0.01;

-- 11 update join
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-update-join/
-- update con inner join
UPDATE
    sales.commissions
SET
    sales.commissions.commission = 
        c.base_amount * t.percentage
FROM 
    sales.commissions c
    INNER JOIN sales.targets t
        ON c.target_id = t.target_id;

-- update con left join
UPDATE 
    sales.commissions
SET  
    sales.commissions.commission = 
        c.base_amount  * COALESCE(t.percentage,0.1)
FROM  
    sales.commissions c
    LEFT JOIN sales.targets t 
        ON c.target_id = t.target_id;

-- 12 delete
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-delete/

DELETE TOP 10 FROM target_table;  
DELETE TOP 10 PERCENT FROM target_table;
--2) Delete the percent of random rows example

DELETE TOP (5) PERCENT
FROM production.product_history;

-- 3) Delete some rows with a condition example

DELETE
FROM
    production.product_history
WHERE
    model_year = 2017;

-- 13 merge
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-merge/
-- mezclar insert update delete 
-- If you use the INSERT, UPDATE, and DELETE statement individually, you have to construct three separate statements to update the data to the target table with the matching rows from the source table.

MERGE target_table USING source_table
ON merge_condition
WHEN MATCHED
    THEN update_statement
WHEN NOT MATCHED
    THEN insert_statement
WHEN NOT MATCHED BY SOURCE
    THEN DELETE;


-- Second, the merge_condition determines how the rows from the source table are matched to the rows from the target table. It is similar to the join condition in the join clause. Typically, you use the key columns either primary key or unique key for matching.

-- MATCHED: these are the rows that match the merge condition. In the diagram, they are shown as blue. For the matching rows, you need to update the rows columns in the target table with values from the source table.
-- NOT MATCHED: these are the rows from the source table that does not have any matching rows in the target table. In the diagram, they are shown as orange. In this case, you need to add the rows from the source table to the target table. Note that NOT MATCHED is also known as NOT MATCHED BY TARGET.
-- NOT MATCHED BY SOURCE: these are the rows in the target table that does not match any rows in the source table. They are shown as green in the diagram. If you want to synchronize the target table with the data from the source table, then you will need to use this match condition to delete rows from the target table.
MERGE sales.category t 
    USING sales.category_staging s
ON (s.category_id = t.category_id)
WHEN MATCHED
    THEN UPDATE SET 
        t.category_name = s.category_name,
        t.amount = s.amount
WHEN NOT MATCHED BY TARGET 
    THEN INSERT (category_id, category_name, amount)
         VALUES (s.category_id, s.category_name, s.amount)
WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;

-- 14 transaction
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-transaction/
-- A transaction is a single unit of work that typically contains multiple T-SQL statements.
-- If a transaction is successful, the changes are committed to the database. However, if a transaction has an error, the changes have to be rolled back.
-- When executing a single statement such as INSERT, UPDATE, and DELETE, SQL Server uses the autocommit transaction. In this case, each statement is a transaction.

BEGIN TRANSACTION;
-- Then, execute one or more statements including INSERT, UPDATE, and DELETE.

COMMIT;
ROLLBACK;

BEGIN TRANSACTION;

INSERT INTO invoices (customer_id, total)
VALUES (100, 0);

INSERT INTO invoice_items (id, invoice_id, item_name, amount, tax)
VALUES (10, 1, 'Keyboard', 70, 0.08),
       (20, 1, 'Mouse', 50, 0.08);

UPDATE invoices
SET total = (SELECT
  SUM(amount * (1 + tax))
FROM invoice_items
WHERE invoice_id = 1);

COMMIT;

--Use the BEGIN TRANSACTION statement to start a transaction explicitly.
-- Use the COMMIT statement to commit the transaction and ROLLBACK statement to roll back the transactio

-- 15 SQL Server CREATE DATABASE
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-create-database/
-- lists all databases in the SQL Server
SELECT 
    name
FROM 
    master.sys.databases
ORDER BY 
    name;
    ---
or EXEC sp_databases;

-- 16 drop database
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-drop-database/
DROP DATABASE IF EXISTS TestDb;

-- 17 create schema
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-create-schema/
-- The CREATE SCHEMA statement allows you to create a new schema in the current database.


CREATE SCHEMA customer_services;
GO

-- list schemas
SELECT 
    s.name AS schema_name, 
    u.name AS schema_owner
FROM 
    sys.schemas s
INNER JOIN sys.sysusers u ON u.uid = s.principal_id
ORDER BY 
    s.name;

-- 18 alter schema
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-alter-schema/
ALTER SCHEMA sales TRANSFER OBJECT::dbo.offices;  

-- 19 drop schema
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-drop-schema/
DROP SCHEMA logistics;
DROP SCHEMA IF EXISTS logistics;


-- 20 create table
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-create-table/

-- First, specify the name of the database in which the table is created. The database_name must be the name of an existing database. If you don’t specify it, the database_name defaults to the current database.
-- Second, specify the schema to which the new table belongs.
-- Third, specify the name of the new table.
-- Fourth, each table should have a primary key which consists of one or more columns. Typically, you list the primary key columns first and then other columns. If the primary key contains only one column, you can use the PRIMARY KEY keywords after the column name. If the primary key consists of two or more columns, you need to specify the PRIMARY KEY constraint as a table constraint. Each column has an associated data type specified after its name in the statement. A column may have one or more column constraints such as NOT NULL and UNIQUE.
-- Fifth, a table may have some constraints specified in the table constraints section such as FOREIGN KEY, PRIMARY KEY, UNIQUE and CHECK.

CREATE TABLE sales.visits (
    visit_id INT PRIMARY KEY IDENTITY (1, 1),
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    visited_at DATETIME,
    phone VARCHAR(20),
    store_id INT NOT NULL,
    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id)
);


-- 21 identity
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-identity/
-- IDENTITY[(seed,increment)]
-- The seed is the value of the first row loaded into the table.
-- The increment is the incremental value added to the identity value of the previous row.

-- The default value of seed and increment is 1 i.e., (1,1). It means that the first row, which was loaded into the table, will have the value of one, the second row will have the value of 2 and so on.
-- IDENTITY property to create an identity column for a table.

CREATE TABLE hr.person (
    person_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL
);


-- 22 sequeneces
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-sequence/
-- In SQL Server, a sequence is a user-defined schema-bound object that generates a sequence of numbers according to a specified specification. A sequence of numeric values can be in ascending or descending order at a defined interval and may cycle if requested.

CREATE SEQUENCE item_counter
    AS INT
    START WITH 10
    INCREMENT BY 10;

-- Sequence vs. Identity columns
-- Sequences, different from the identity columns, are not associated with a table. The relationship between the sequence and the table is controlled by applications. In addition, a sequence can be shared across multiple tables.

-- Property/Feature	Identity	Sequence Object
-- Allow specifying minimum and/or maximum increment values	No	Yes
-- Allow resetting the increment value	No	Yes
-- Allow caching increment value generating	No	Yes
-- Allow specifying starting increment value	Yes	Yes
-- Allow specifying increment value	Yes	Yes
-- Allow using in multiple tables	No	Yes

-- When to use sequences
-- You use a sequence object instead of an identity column in the following cases:

-- The application requires a number before inserting values into the table.
-- The application requires sharing a sequence of numbers across multiple tables or multiple columns within the same table.
-- The application requires to restart the number when a specified value is reached.
-- The application requires multiple numbers to be assigned at the same time. Note that you can call the stored procedure sp_sequence_get_range to retrieve several numbers in a sequence at once.
-- The application needs to change the specification of the sequence like maximum value.

-- get info de sequences
SELECT 
    * 
FROM 
    sys.sequences;


-- 23 alter table add column
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-alter-table-add-column/

-- The following ALTER TABLE ADD statement appends a new column to a table:

ALTER TABLE table_name
ADD column_name data_type column_constraint;

-- To add a new column named description to the sales.quotations table, you use the following statement:

ALTER TABLE sales.quotations 
ADD description VARCHAR (255) NOT NULL;


-- 24 alter table alter column
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-alter-table-alter-column/

ALTER TABLE t1 ALTER COLUMN c VARCHAR (2);
ALTER TABLE t1 ALTER COLUMN c INT;

ALTER TABLE t2 ALTER COLUMN c VARCHAR (50);
ALTER TABLE t3 ALTER COLUMN c VARCHAR (20) NOT NULL;

-- 25 alter table drop column
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-alter-table-drop-column/

ALTER TABLE sales.price_lists
DROP COLUMN note;
ALTER TABLE sales.price_lists
DROP CONSTRAINT ck_positive_price;
ALTER TABLE sales.price_lists
DROP COLUMN discount, surcharge;

-- 26 SQL Server Computed Columns
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-computed-columns/

ALTER TABLE persons
ADD full_name AS (first_name + ' ' + last_name);




-- Persisted computed columns
-- Computed columns can be persisted. It means that SQL Server physically stores the data of the computed columns on disk.
-- When you change data in the table, SQL Server computes the result based on the expression of the computed columns and stores the results in these persisted columns physically. When you query the data from the persisted computed columns, SQL Server just needs to retrieve data without doing any calculation. This avoids calculation overhead with the cost of extra storage.
-- columnas creadas dinamicamente en base a otras columnas
ALTER TABLE persons
ADD full_name AS (first_name + ' ' + last_name) PERSISTED;


ALTER TABLE persons
ADD age_in_years 
    AS (CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112))-CONVERT(CHAR(8),dob,112))/10000;


-- 27 drop table
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-drop-table/

DROP TABLE IF EXISTS sales.revenues;

-- 28 trucnate table
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-truncate-table/
-- Sometimes, you want to delete all rows from a table. In this case, you typically use the DELETE statement without a WHERE clause.

DELETE FROM sales.customer_groups;
TRUNCATE TABLE sales.customer_groups;

-- TRUNCATE TABLE vs. DELETE
-- The TRUNCATE TABLE has the following advantages over the DELETE statement:

-- 1) Use less transaction log
-- The DELETE statement removes rows one at a time and inserts an entry in the transaction log for each removed row. On the other hand, the TRUNCATE TABLE statement deletes the data by deallocating the data pages used to store the table data and inserts only the page deallocations in the transaction logs.

-- 2) Use fewer locks
-- When the DELETE statement is executed using a row lock, each row in the table is locked for removal. The TRUNCATE TABLE locks the table and pages, not each row.

-- 3) Identity reset
-- If the table to be truncated has an identity column, the counter for that column is reset to the seed value when data is deleted by the TRUNCATE TABLE statement but not the DELETE statement.

-- In this tutorial, you have learned how to use the TRUNCATE TABLE statement to delete all rows from a table faster and more efficiently.


-- 29 select into
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-select-into/
-- The SELECT INTO statement creates a new table and inserts rows from the query into it.

SELECT 
    *
INTO 
    marketing.customers
FROM 
    sales.customers;

SELECT    
    customer_id, 
    first_name, 
    last_name, 
    email
INTO 
    TestDb.dbo.customers
FROM    
    sales.customers
WHERE 
    state = 'CA';


--30 rename table
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-rename-table/
-- cambiar nombre de tabla
SQL Server does not have any statement that directly renames a table. However, it does provide you with a stored procedure named sp_rename that allows you to change the name of a table.

EXEC sp_rename 'old_table_name', 'new_table_name'
EXEC sp_rename 'sales.contr', 'contracts';


--31 temporary tables
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-temporary-tables/
-- The temporary tables are useful for storing the immediate result sets that are accessed multiple times.

-- -- se puede crear con un select into 
-- The name of the temporary table starts with a hash symbol (#). 
-- As you can see clearly from the picture, the temporary table also consists of a sequence of numbers as a postfix. This is a unique identifier for the temporary table. Because multiple database connections can create temporary tables with the same name, SQL Server automatically appends this unique number at the end of the temporary table name to differentiate between the temporary tables.



SELECT
    product_name,
    list_price
INTO #trek_products --- temporary table
FROM
    production.products
WHERE
    brand_id = 9;


-- Create temporary tables using CREATE TABLE statement
CREATE TABLE #haro_products (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);
INSERT INTO #haro_products
SELECT
    product_name,
    list_price
FROM 
    production.products
WHERE
    brand_id = 2;


SELECT
    *
FROM
    #haro_products;


-- Global temporary tables
-- Sometimes, you may want to create a temporary table that is accessible across connections. In this case, you can use global temporary tables.

CREATE TABLE ##heller_products (
    product_name VARCHAR(MAX),
    list_price DEC(10,2)
);

INSERT INTO ##heller_products
SELECT
    product_name,
    list_price
FROM 
    production.products
WHERE
    brand_id = 3;



DROP TABLE ##table_name;

-- 32 SQL Server Synonym
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-synonym/
a synonym is an alias or alternative name for a database object such as a table, view, stored procedure, user-defined function, and sequence. A synonym provides you with many benefits if you use it properly.

CREATE SYNONYM orders FOR sales.orders;
-- Listing all synonyms of a database


SELECT 
    name, 
    base_object_name, 
    type
FROM 
    sys.synonyms
ORDER BY 
    name;

-- Removing a synonym

DROP SYNONYM [ IF EXISTS ] [schema.] synonym_name  
DROP SYNONYM IF EXISTS orders;



-- When to use synonyms
-- You will find some situations which you can effectively use synonyms.

-- 1) Simplify object names
-- If you refer to an object from another database (even from a remote server), you can create a synonym in your database and reference to this object as it is in your database.

-- 2) Enable seamless object name changes
-- When you want to rename a table or any other object such as a view, stored procedure, user-defined function, or a sequence, the existing database objects that reference to this table need to be manually modified to reflect the new name. In addition, all current applications that use this table need to be changed and possibly to be recompiled. To avoid all of these hard work, you can rename the table and create a synonym for it to keep existing applications function properly.



-- Benefits of synonyms
-- Synonym provides the following benefit if you use them properly:

-- Provide a layer of abstraction over the base objects.
-- Shorten the lengthy name e.g., a very_long_database_name.with_schema.and_object_name with a simplified alias.
-- Allow backward compatibility for the existing applications when you rename database objects such as tables, views, stored procedures, user-defined functions, and sequences.
-- In this tutorial, you have learned how to about the SQL Server synonyms and how to use them effectively in your applications.