--- 1 https://www.sqlservertutorial.net/sql-server-basics/sql-server-select/
--- agrupo por filas
SELECT
    city,
    COUNT (*)
FROM
    sales.customers
WHERE
    state = 'CA'
GROUP BY
    city
ORDER BY
    city;
------

-- FILTRADO DE GRUPOS

SELECT
    city,
    COUNT (*)
FROM
    sales.customers
WHERE
    state = 'CA'
GROUP BY
    city
HAVING
    COUNT (*) > 10
ORDER BY
    city;


---- 

-- 2 https://www.sqlservertutorial.net/sql-server-basics/sql-server-order-by/
-- ORDER DE VARIAS COLUMNAS

SELECT
    city,
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    city,
    first_name;

-- ORDENAR COLUMNAS EN DIFERENTES ORDENES
SELECT
    city,
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    city DESC,
    first_name ASC;

-- ORDENAR EN BASE A UNA EXPRESION

SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    LEN(first_name) DESC;

-- ORDENA CARDINALMENTE

SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    1,
    2;

--1 ES first_name 2 ES last_name

-- 3 https://www.sqlservertutorial.net/sql-server-basics/sql-server-offset-fetch/

--OFFSET FETCH LIMITA EL NUMERO DE FILAS DEL SELECT

-- PARA TOMAR TODO MENOS LOS 10 PRIMEROS RESULTADOS
SELECT
    product_name,
    list_price
FROM
    production.products
ORDER BY
    list_price,
    product_name 
OFFSET 10 ROWS;


--PARA NO TOMAR LOS 10 PRIMEROS PRODUCTOS Y TOMAR LOS SIGUIENTES 10 
SELECT
    product_name,
    list_price
FROM
    production.products
ORDER BY
    list_price,
    product_name 
OFFSET 10 ROWS 
FETCH NEXT 10 ROWS ONLY;



-- CONSEGUIR LOS 10 PRIMEROS PRODUCTOS MAS CAROS 
SELECT
    product_name,
    list_price
FROM
    production.products
ORDER BY
    list_price DESC,
    product_name 
OFFSET 0 ROWS 
FETCH FIRST 10 ROWS ONLY;


-- 4 https://www.sqlservertutorial.net/sql-server-basics/sql-server-select-top/
-- SELECT TOP NORMAL

SELECT TOP 10
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;


-- SELECT TOP CON PORCENTAJE (SIG EJEMPLO DEVUELVE EL 1 % DEL TOTAL SI SON 321 DEVUEKVE 4)

SELECT TOP 1 PERCENT
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;

-- SELECT TOP CON TIES DEVUELVE LOS PRIMEROS 3 VALORES Y  3 VALORES ADICIONALES QUE TENGAN EL MISMO VALOR DE PRICES DEL ULTIMO DEL TOP

SELECT TOP 3 WITH TIES
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;


-- 5 https://www.sqlservertutorial.net/sql-server-basics/sql-server-select-distinct/
-- SELECT DISTINCT BASIC, TB DEVUELVE NULLS

SELECT DISTINCT
    city
FROM
    sales.customers
ORDER BY
    city;


-- SELECT DISTINCT DE DISTINTAS COLUMNAS

SELECT
    city,
    state
FROM
    sales.customers
ORDER BY 
    city, 
    state;

-- QUERYS CON DISTINCT Y CON GROUP BY, DEVUELVEN LOS MISMOS VVALORES, SE DIFERENCIAS QUE CUANDO TENGO FUNCIONE4S
--DE AGREGACION EN UNA O VARIAS COLUMNAS SE DEBE USAR GROUP BY
SELECT 
	city, 
	state, 
	zip_code
FROM 
	sales.customers
GROUP BY 
	city, state, zip_code
ORDER BY
	city, state, zip_code


SELECT
    city,
    state
FROM
    sales.customers
ORDER BY 
    city, 
    state;

-- FUNCIONES DE AGREGACION 
-- https://www.sqlservertutorial.net/sql-server-aggregate-functions/


Aggregate function	Description
AVG	The AVG() aggregate function calculates the average of non-NULL values in a set.
CHECKSUM_AGG	The CHECKSUM_AGG() function calculates a checksum value based on a group of rows.
COUNT	The COUNT() aggregate function returns the number of rows in a group, including rows with NULL values.
COUNT_BIG	The COUNT_BIG() aggregate function returns the number of rows (with BIGINT data type) in a group, including rows with NULL values.
MAX	The MAX() aggregate function returns the highest value (maximum) in a set of non-NULL values.
MIN	The MIN() aggregate function returns the lowest value (minimum) in a set of non-NULL values.
STDEV	The STDEV() function returns the statistical standard deviation of all values provided in the
expression based on a sample of the data population.
STDEVP	The STDEVP() function also returns the standard deviation for all values in the provided
expression, but does so based on the entire data population.
SUM	The SUM() aggregate function returns the summation of all non-NULL values a set.
VAR	The VAR() function returns the statistical variance of values in an expression based on a sample of the specified population.
VARP	The VARP() function returns the statistical variance of values in an expression but does
so based on the entire data population.


SELECT
    CAST(ROUND(AVG(list_price),2) AS DEC(10,2))
    avg_product_price
FROM
    production.products;

-- 6 SELECT WHERE 

-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-where/

-- 7 AND
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-and/
	    TRUE	FALSE	UNKNOWN
TRUE	TRUE	FALSE	UNKNOWN
FALSE	FALSE	FALSE	FALSE
UNKNOWN	UNKNOWN	FALSE	UNKNOWN

-- 8 OR
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-or/
        TRUE	FALSE	UNKNOWN
TRUE	TRUE	TRUE	TRUE
FALSE	TRUE	FALSE	UNKNOWN
UNKNOWN	TRUE	UNKNOWN	UNKNOWN

-- 9 IN
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-in/
-- SACA LOS PRODUCTOS QUE PRECIO ES UNO DE LOS TRES VALORES 
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price IN (89.99, 109.99, 159.99)
ORDER BY
    list_price;
-- ES EQUIVALENTTE A DECIR
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price = 89.99 OR list_price = 109.99 OR list_price = 159.99
ORDER BY
    list_price;

-- SACA LOS PRODUCTOS CON PRECIO DISTITNO A LOS DE LA LISTA

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price NOT IN (89.99, 109.99, 159.99)
ORDER BY
    list_price;

-- SUBQUERYS

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    product_id IN (
        SELECT
            product_id
        FROM
            production.stocks
        WHERE
            store_id = 1 AND quantity >= 30
    )
ORDER BY
    product_name;


-- BETWEEN https://www.sqlservertutorial.net/sql-server-basics/sql-server-between/

-- LIKE https://www.sqlservertutorial.net/sql-server-basics/sql-server-like/

-- CUANDO SE TIENE PATRONES
-- EJM CUANTO SE TIENE CUSTOMERS DONDE APELLIDO EL SEGUNDO VALOR ES U, DESPUES DEL SEG VALOR ES INDEPENDIENTE EL CONTENET

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '_u%'
ORDER BY
    first_name; 

-- CUANDO QUIERO CUSTOMERS DONDE APELLIDO, EMPIECE CON Y O Z
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '[YZ]%'
ORDER BY
    last_name;

-- CUANDO QUIERO CUSTOMERS DONDE PRIMER LETRA ESTA ENTRE A Y C
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '[A-C]%'
ORDER BY
    first_name;

-- CUANDO QUIERO CUSTOMERS DONDE PRIMER LETRA NO ESTA ENTRE A Y X

SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE '[^A-X]%'
ORDER BY
    last_name;

-- CUANDO HAGO SELECT Y QUIERO QUE ME DEVUELVA COMMENT CON '30%' ADENTRO
SELECT 
   feedback_id, 
   comment
FROM 
   sales.feedbacks
WHERE 
   comment LIKE '%30!%%' ESCAPE '!';


-- ALIAS https://www.sqlservertutorial.net/sql-server-basics/sql-server-alias/
-- ASIGNAR VALOR A COLUMNAS Y HACER REFERENCIA EN ORDER
SELECT
    category_name 'Product Category'
FROM
    production.categories
ORDER BY
    category_name;  


SELECT
    category_name 'Product Category'
FROM
    production.categories
ORDER BY
    'Product Category';
-- ALIAS CUANDO APLICO JOINS
SELECT
    c.customer_id,
    first_name,
    last_name,
    order_id
FROM
    sales.customers c
INNER JOIN sales.orders o ON o.customer_id = c.customer_id;

-- JOINS https://www.sqlservertutorial.net/sql-server-basics/sql-server-joins/
-- INNER JOIN, SACO LOS DATOS DE LA INTERSECCION ENTRE TABLA A Y B
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-inner-join/
SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    INNER JOIN hr.employees e 
        ON e.fullname = c.fullname;


-- LEFT JOIN , SI TENGO TABLA A Y B, SACO LOS DATOS DE LA TABLA A, INCLUIDO LA INTERSECCION CON B, PERO SIN LO QUE NO ES A
--https://www.sqlservertutorial.net/sql-server-basics/sql-server-left-join/
SELECT  
	c.id candidate_id,
	c.fullname candidate_name,
	e.id employee_id,
	e.fullname employee_name
FROM 
	hr.candidates c
	LEFT JOIN hr.employees e 
		ON e.fullname = c.fullname;

-- SACO LOS DATOS DE TRES TABLAS, PRODUCTOS, ORDERITEMS E ORDERS
SELECT
    p.product_name,
    o.order_id,
    i.item_id,
    o.order_date
FROM
    production.products p
	LEFT JOIN sales.order_items i
		ON i.product_id = p.product_id
	LEFT JOIN sales.orders o
		ON o.order_id = i.order_id
ORDER BY
    order_id;


-- SI QUIERO TODO LO QUE SEA A Y NO B, EXCLUYENDO LA INTERSECCION

SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    LEFT JOIN hr.employees e 
        ON e.fullname = c.fullname
WHERE 
    e.id IS NULL;

-- RIGHT JOIN , SI TENGO TABLA A Y B, SACO LOS DATOS DE LA TABLA B, INCLUIDO LA INTERSECCION CON A, PERO SIN LO QUE NO ES B
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-right-join/
SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    RIGHT JOIN hr.employees e 
        ON e.fullname = c.fullname;

-- SI QUIERO TODO LO QUE SEA B Y NO A, EXCLUYENDO LA INTERSECCION
SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    RIGHT JOIN hr.employees e 
        ON e.fullname = c.fullname
WHERE
    c.id IS NULL;


-- FULL JOIN, SACO LA DATA DE LAS DOS TABLAS INCLUIDO INTERESECCION
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-full-outer-join/
SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    FULL JOIN hr.employees e 
        ON e.fullname = c.fullname;

-- SI QUIERO DATA DE LAS DOS TABLAS EXCLUYENDO INTERSECCION

SELECT  
    c.id candidate_id,
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM 
    hr.candidates c
    FULL JOIN hr.employees e 
        ON e.fullname = c.fullname
WHERE
    c.id IS NULL OR
    e.id IS NULL;


-- SELF JOIN 
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-self-join/
-- CUANDO QUIERO CRUZAR DATOS DE UNA SOLA TABLA QUE SE REFERENCIA A SI MISMA, EJM
-- TENGO TABLA EMPLEADOS DONDE TIENE COLUMNA ID_JEFE, EL CUAL ESTA EN LA MISMA TABLA


-- CON INNER JOIN, PERO SE PIERDE REGISTROS PADRES
SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    sales.staffs e
INNER JOIN sales.staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager;
-- CON LEFT JOIN SE RECUPERA REGISTROS PADRES

SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    sales.staffs e
LEFT JOIN sales.staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager;


-- SELF JOINED: The following statement uses the self join to find the customers located in the same city.
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-self-join/
-- The following condition makes sure that the statement doesn’t compare the same customer:
-- And the following condition matches the city of the two customers:

SELECT
    c1.city,
    c1.first_name + ' ' + c1.last_name customer_1,
    c2.first_name + ' ' + c2.last_name customer_2
FROM
    sales.customers c1
INNER JOIN sales.customers c2 ON c1.customer_id > c2.customer_id
AND c1.city = c2.city
ORDER BY
    city,
    customer_1,
    customer_2;

-- Note that if you change the greater than ( > ) operator by the not equal to (<>) operator, you will get more rows:
SELECT
    c1.city,
    c1.first_name + ' ' + c1.last_name customer_1,
    c2.first_name + ' ' + c2.last_name customer_2
FROM
    sales.customers c1
INNER JOIN sales.customers c2 ON c1.customer_id <> c2.customer_id
AND c1.city = c2.city
ORDER BY
    city,
    customer_1,
    customer_2;

-- GROUP BY
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-group-by/
-- As you can see clearly from the output, the customer with the id one placed one order in 2016 and two orders in 2018. The customer with id two placed two orders in 2017 and one order in 2018.
SELECT
    customer_id,
    YEAR (order_date) order_year
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
ORDER BY
    customer_id;

--
SELECT
    customer_id,
    YEAR (order_date) order_year
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;

--Functionally speaking, the GROUP BY clause in the above query produced the same result as the following query that uses the DISTINCT clause:

SELECT
    city,
    COUNT (customer_id) customer_count
FROM
    sales.customers
GROUP BY
    city
ORDER BY
    city;

SELECT
    city,
    state,
    COUNT (customer_id) customer_count
FROM
    sales.customers
GROUP BY
    state,
    city
ORDER BY
    city,
    state;

--- HAVING 
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-having/
-- The HAVING clause is often used with the GROUP BY clause to filter groups based on a specified list of conditions. The following illustrates the HAVING clause syntax:
-- The following statement uses the HAVING clause to find the customers who placed at least two orders per year:


SELECT
    customer_id,
    YEAR (order_date),
    COUNT (order_id) order_count
FROM
    sales.orders
GROUP BY
    customer_id,
    YEAR (order_date)
HAVING
    COUNT (order_id) >= 2
ORDER BY
    customer_id;


-- SUBQUERY https://www.sqlservertutorial.net/sql-server-basics/sql-server-subquery/
-- SE PUEDE USAR
-- In place of an expression
-- With IN or NOT IN
-- With ANY or ALL
-- With EXISTS or NOT EXISTS
-- In UPDATE, DELETE, orINSERT statement
-- In the FROM clause
SELECT
    order_id,
    order_date,
    customer_id
FROM
    sales.orders
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            sales.customers
        WHERE
            city = 'New York'
    )
ORDER BY
    order_date DESC;


-- SUBQUERY ANIDADAS
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > (
        SELECT
            AVG (list_price)
        FROM
            production.products
        WHERE
            brand_id IN (
                SELECT
                    brand_id
                FROM
                    production.brands
                WHERE
                    brand_name = 'Strider'
                OR brand_name = 'Trek'
            )
    )
ORDER BY
    list_price;


-- SUBQUERY CORRELACIONADA
-- The following example finds the products whose list price is equal to the highest list price of the products within the same category:


SELECT
    product_name,
    list_price,
    category_id
FROM
    production.products p1
WHERE
    list_price IN (
        SELECT
            MAX (p2.list_price)
        FROM
            production.products p2
        WHERE
            p2.category_id = p1.category_id
        GROUP BY
            p2.category_id
    )
ORDER BY
    category_id,
    product_name;

-- EXIST
-- https://www.sqlservertutorial.net/sql-server-basics/sql-server-exists/
--The EXISTS operator is a logical operator that allows you to check whether a subquery returns any row. The EXISTS operator returns TRUE if the subquery returns one or more rows.
-- The following example returns all rows from the  customers table:
-- In this example, the subquery returned a result set that contains NULL which causes the EXISTS operator to evaluate to TRUE. Therefore, the whole query returns all rows from the customers table.



SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    EXISTS (SELECT NULL)
ORDER BY
    first_name,
    last_name;

-- The following example finds all customers who have placed more than two orders:


SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE
    EXISTS (
        SELECT
            COUNT (*)
        FROM
            sales.orders o
        WHERE
            customer_id = c.customer_id
        GROUP BY
            customer_id
        HAVING
            COUNT (*) > 2
    )
ORDER BY
    first_name,
    last_name;


--EXIST PUIEDE OBTENER MISMO RESULTADO DE IN
-- The following statement uses the IN operator to find the orders of the customers from San Jose:
-- The EXISTS operator returns TRUE or FALSE while the JOIN clause returns rows from another table.
-- You use the EXISTS operator to test if a subquery returns any row and short circuits as soon as it does. On the other hand, you use JOIN to extend the result set by combining it with the columns from related tables.
-- In practice, you use the EXISTS when you need to check the existence of rows from related tables without returning data from them.

SELECT
    *
FROM
    sales.orders
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            sales.customers
        WHERE
            city = 'San Jose'
    )
ORDER BY
    customer_id,
    order_date;

SELECT
    *
FROM
    sales.orders o
WHERE
    EXISTS (
        SELECT
            customer_id
        FROM
            sales.customers c
        WHERE
            o.customer_id = c.customer_id
        AND city = 'San Jose'
    )
ORDER BY
    o.customer_id,
    order_date;
