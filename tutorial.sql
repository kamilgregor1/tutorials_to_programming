# GENERAL

## Every command in SQL is terminated with ';'
## SQL is not case sensitive, it's a custom to write reserved words (SELECT, FROM, WHERE) in all caps
## SQL is not space and paragraph break sensitive, it's a custom to start every clause of a statement on a new line
## In SQL, order of clauses in a statements matters (e.g. in SELECT, GROUP BY must follow after WHERE)

## SQL data is stored on a server, if data is loaded from an external source, input files must be located on the server
## When using a local server, it's possible to load data located in a dedicated folder (usually "C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/"). This folder cannot be changed dynamically and is specified in the my.ini file

## '*' stand for 'everything' (e.g. every record in a table)

## A database consists of tables. Tables consist of records (~rows) and fields (~columns)
## Every field has a data type. Common data types:
## - textual:
##  - char(size) - a character string (up to 8,000 characters). The 'size' argument specifies a maximum size and also how many bytes will be used to store the value. Even if a shorter string is entered, the specified number of byes will still be used 
##  - varchar(size) - a character string (up to 8,000 characters). The 'size' argument specifies a maximum size. Is a shorter string is entered, it will use less bytes to store it
##  - text - a long character string (up to billions of characters)
## - numeric:
##  - int - an integer
##  - tinyint - a short integer (0 to 255), suitable for numerical codes. Other versions of int are available (smallint, bigint etc.)
##  - numeric(precision, scale) - a number. The 'precision' argument specifies a total maximum number of digits that will be stored (both to the left and to the right of the decimal point). The 'scale' parameter specifies a number of decimal places that will be stored. 58.145 has a precision of 5 and a scale of 3
##  - money - a monetary value
## - temporal
##  - datetime - date and time in the 'YYYY-MM-DD HH:MM:SS' format
##  - date - date in the 'YYYY-MM-DD' format
##  - year - date in the 'YYYY' format
##  - timestamp - a unique date and time value that will change every time a record is created or modified

## Fields and/or tables may be defined so that they contain constraints. All constraints are optional but it's strongly advised to use the PRIMARY KEY constraint
## Common constraints:
## - NOT NULL - normally, if data is inserted but no value is specified, NULL value is inserted. If this contraint is placed, an attempt to insert the NULL value will result in an error
## - DEFAULT - if data is inserted but no value is specified, the default value will be inserted
## - UNIQUE - an attempt to insert a value that already exists in the field will result in an error
## - PRIMARY KEY - a combination of NOT NULL and UNIQUE. A table can have multiple primary keys (collectively called composite keys)
## - FOREIGN KEY - a column that is a primery key in another table
## - CHECK - followed by a logical expression (e.g. 'age int CHECK (age >= 20)'. An attempt to insert values for which the expression is false wil result in an error

# DATABASE NORMALIZATION

## A process of organizing tables and fields in databases so that its size is reduced and dependencies between fields make sense

## A database can be in one of the forms of database normalization if it matches certain criteria. The forms and the criteria are:
## - The first normal form (1NF):
##  - There are no repeating groups of data
##  - Every table has a primary key
## - The second formal form (2NF):
##  - The database is in the first normal form
##  - There are no partial dependencies of any of the fields on the primary key (partial dependency = a primary key consists of two fields and there are fields in the table that are dependent on only one of those)
## - The third normal form (3NF)
##  - The database is in the second normal form
##  - All fields are dependent on the primary key and not on some other field

## There are additional forms (up to 6NF)

## An example when the first rule of 1NF is violated:
## There is a table with customers' orders where every record is one order and there are fields 'customer name', 'customer address' etc.
## The rule is violated because if the same customer makes multiple orders, values in the 'customer name', 'customer address' fields repeat, which is unneccessary.
## The correct way would be to create two separate tables, one for data on a customer and one for data on orders

## An example when the second rule of 2NF is violated:
## There is a table with data on what customers purchased with a composite primary key consisting of 'customer ID' and 'product ID' and there are fields in the table describing only customers (e.g. 'name') and/or only products (e.g. 'brand')
## The rule is violated because such fields are partially dependent - they are dependent only on an identifier of a customer or an product but not on both
## (This table is also poorly constructed because the primary key will only remain unique if no customer ever buys the same product twice. But this has nothing to do with 2NF.)
## The correct way would be to create three separate tables, one for data on customers, one for data on products and one on data about individual purchases that includes a customer ID, a product ID and optionally other info about a purchase (e.g. time) 

## An example when the second rule of 3NF is violated:
## There is a table on customers with a primary key 'customer id' that contains fields 'zip code', 'city' and 'country'
## The rule is violated because 'city' and 'country' are dependent on 'zip'.
## The correct way would be to create two separate tables, one for data on customers that contains 'zip code' and one for zip codes that contains 'city' and 'country' and has 'zip code' as a primary key

# CREATE, USE, ALTER AND DROP, CREATING AND USING DATABASES AND TABLES

## create a database called 'test_database'

CREATE DATABASE test_database;

## use the 'test_database' database (= all the following commands will apply to this database)

USE test_database;

## delete a database

DROP DATABASE test_database;

## create a table 'test_table1' with columns 'id', 'name', 'date_of_birth', 'age' and 'height', the 'id' column is the PRIMARY KEY

CREATE TABLE test_table1(
id int PRIMARY KEY,
given_name varchar(20),
family_name varchar(20),
date_of_birth date,
age int,
height numeric(5,2),
sex char(1)
);

## create a table with constrains

CREATE TABLE test_table2(
id int,
given_name varchar(20) DEFAULT "missing",
family_name varchar(20),
date_of_birth date NOT NULL UNIQUE,
age int DEFAULT 20,
height numeric(5,2),
sex char(1),
PRIMARY KEY (id, sex)
);

## alter an existing table (change the 'DEFAULT' constraint in the 'age' column to 10)

ALTER TABLE test_table2
MODIFY age int DEFAULT 10;

## rename a column

alter table test_table1
change column sex gender char(1);

## change a data type of a column

alter table test_table1
modify column sex varchar(1);

## add a constraint to multiple columns

ALTER TABLE test_table2
ADD CONSTRAINT new_constraint UNIQUE(height, sex);

## drop the 'DEFAULT' constraint of the 'age' column

ALTER TABLE test_table2
ALTER COLUMN age DROP DEFAULT;

## change column name

ALTER TABLE test_table2
CHANGE age new_age int;

## add a column

ALTER TABLE test_table2
ADD COLUMN weight numeric(6, 2);

## add a column between the first and the second column

ALTER TABLE test_table2
ADD COLUMN title varchar(10)
AFTER id;

## delete a table

DROP TABLE test_table1;

## truncate a table (truncate table deletes all records but keeps the table in a database empty; drop table deletes the table from the database)

truncate table test_table1;

# DISPLAYING CONTENTS OF DATABASES

## show everything in a table

SELECT * FROM test_table1;

## show columns in a table

DESC test_table1;

# INSERTING RECORDS, COPYING RECORDS BETWEEN TABLES

## create a table from an existing table

CREATE TABLE test_table2 AS
SELECT id, name
FROM test_table1;

## insert a record into a table

INSERT INTO test_table1
VALUES (1, "kamil", "gregor", "2010-05-11", 15, 85.55,"M"),
(2, "jan", "novák", "2010-12-01", 45, 11.3,"M");

## insert a record from one table to another table

INSERT INTO test_table2
SELECT id, name
FROM test_table1;

# UPDATING RECORDS

## updating records by inserting new values

UPDATE test_table1
SET name = "kamil gregor, jr.", date_of_birth = "1987-06-12"
WHERE id = 1;

## updating records by performing arithmetic operations on existing records

UPDATE test_table1
SET age = age+1
WHERE id > 0;

# DELETING RECORDS

DELETE FROM test_table1
WHERE id = 3;

# LOADING DATA FROM EXTERNAL SOURCES

## found out where the working directory is (the directory cannot be changed dynamically)

SHOW VARIABLES LIKE "secure_file_priv";

## load data from a file in the working directory into a table, the file must have the same structure

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/test.txt" # location of the file
INTO TABLE test_table1 # location of the target
FIELDS TERMINATED BY "," # specify a separation character
IGNORE 1 LINES; # ignore a certain number of top lines (rows), used for ignoring the header

# SUBSETTING DATA

## select all columns in a table

SELECT * FROM test_table1;

## select all rows in a table

SELECT id, name FROM test_table1;

## select the first 2 rows

SELECT * FROM test_table1
LIMIT 2;

## select the last 2 rows

SELECT * FROM test_table1
ORDER BY id DESC
LIMIT 2;

## select the last 2 rows but order them by id (ascending rather than descending)

SELECT * FROM (
    SELECT * FROM test_table1 ORDER BY id DESC LIMIT 2
) sub
ORDER BY id ASC;

## select a record where 'id' is 2

SELECT * FROM test_table1
WHERE id = 2;

## select records where 'id' is greater than 3

SELECT * FROM test_table1
WHERE id >= 3;

## select records where 'name' starts with 'k'

SELECT * FROM test_table1
WHERE name LIKE "k%";

## select records where 'name' ends with 'k'

SELECT * FROM test_table1
WHERE name LIKE "%k";

## select records where 'name' contains 'p'

SELECT * FROM test_table1
WHERE name LIKE "%p%";

## select records where 'id' is not 1

SELECT * FROM test_table1
WHERE id <> 1;

## select only unique values from a field

SELECT DISTINCT sex
FROM test_table1;

# AGGREGATE OPERATORS (MIN, MAX, SUM, AVG, COUNT)

## show a minimum value of a numeric field

SELECT MIN(id)
FROM test_table1;

## show an average value of a numeric field

SELECT AVG(height)
FROM test_table1;

## show a number of records in a field that match certain criteria

SELECT COUNT(*)
FROM test_table1
WHERE sex = "M";

# THE 'GROUP BY' CLAUSE OF 'SELECT'

## show names and heights of the highest male and the highest female

SELECT given_name, MAX(height)
FROM test_table1
GROUP BY sex;

## show records of the youngest person called 'gregor'

SELECT given_name, MIN(height)
FROM test_table1
WHERE family_name = "gregor"
GROUP BY sex;

# THE 'HAVING' CLAUSE OF 'SELECT'

## show the average height of families but only families that include male members

SELECT family_name, sex, AVG(height)
FROM test_table1
GROUP BY family_name
HAVING sex = "M";

# THE 'ORDER BY' CLAUSE OF 'SELECT'

## show records of all males, sorted by from the oldest

SELECT *
FROM test_table1
ORDER BY age DESC;

# BOOLEAN OPERATORS

## show all people called 'gregor' and older than 10

SELECT *
FROM test_table1
WHERE family_name = "gregor" AND age > 10;

## show all men and all women called 'dvořáková'

SELECT *
FROM test_table1
WHERE sex = "M" OR family_name = "dvořáková";

# LOGICAL OPERATORS

## - AND, OR
## - IN, BETWEEM
## - ALL - compare a value to all values in a value set
## - ANY - compare a value to any applicable value in the list according to the condition
## - EXISTS - search for the presence of a row in a specified table that meets certain criteria
## - NOT - reverses the other operators (e.g. NOT BETWEEN, NOT LIKE, IS NOT NULL)
## - IS NULL
## - searches every row of a specified table for uniqueness (no duplicates)

## show records of all people named 'gregor', 'dvořák' nebo 'novák'

SELECT *
FROM test_table1
WHERE family_name IN ("gregor", "dvořák", "novák");

## show records of all people older than 10 and youger then 30 (including 20 and 30)

SELECT *
FROM test_table1
WHERE age BETWEEN 20 AND 30;

## show all records where name is not missing

SELECT *
FROM test_table1
WHERE 'family_name' IS NOT NULL AND 'given_name' IS NOT NULL;

## show all records where age is 25 or 20

SELECT *
FROM test_table1
WHERE age IN (20, 25);

## show all records of males that are younger than the oldest female

SELECT *
FROM test_table1
WHERE sex = "M" AND age < ANY (SELECT age FROM test_table1 WHERE sex = "F");

## select all records of females that are older than all males

SELECT *
FROM test_table1
WHERE sex = "F" AND age > ALL (SELECT age FROM test_table1 WHERE sex = "M");

# MATHEMATICAL OPERATORS

## - % - returns an integer remainder of division (e.g. 9 / 5 = 1.8; 9 % 5 = 8)
## - MOD(x, y) - the same as x % y
## - ABS(x) - returns the absolute value of x (e.g. '3' for '-3')
## - SIGN(x) - returns the sign of x (e.g. '-' for '-1')
## - FLOOR(x) - returns the closest integer larger than x
## - CEIL(x) - returns the closest integer smaller than x
## - POWER (x, y) - returns the value of x raised to the power of y
## - ROUND(x) - returns the value of x rounded to the nearest whole integer
## - ROUND(x, y) - returns the value of x rounded to the number of decimal places specified by the value y
## - SQRT(x) - returns the square-root value of x

## show name and height of all people rounded to one decimal place

SELECT given_name, family_name, round(height, 1)
FROM test_table1; 

# CREATE TABLES FROM OTHER TABLES

## create a table with unique values of family names from 'test_table1'

CREATE TABLE test_table3 AS
SELECT DISTINCT family_name
FROM test_table1;

# INNER JOIN

## Inner join is a join where only an intersection of two tables is selected.
## This is identical to "merge" in R with the argument "all = FALSE"
## In this case, a person with id = 2 is missing because he wrote no books

select *
from test_table1, test_table2
where test_table1.id = test_table2.id;

## or

select *
from test_table1
inner join test_table2
on test_table1.id = test_table2.id;

# LEFT JOIN

## Left join select all records in the left table and shows them together with corresponding records from the right table, even if there are no corresponding records in the right table.
## This is identical to "merge" in R with the argument "all.x = TRUE, all.y = FALSE"
## In this case, a person with id = 2 is present and fields for books are fileld with NULL

select *
from test_table1
left join test_table2
on test_table1.id = test_table2.id;

# RIGHT JOIN

## Right join select all records in the right table and shows them together with corresponding records from the left table, even if there are no corresponding records in the left table.
## This is identical to "merge" in R with the argument "all.x = FALSE, all.y = TRUE"
## In this case, a person with id = 2 is missing because he wrote no books

select *
from test_table1
right join test_table2
on test_table1.id = test_table2.id;

## A right join on users is identical to a left join on courses. The statement above is identical to this:

select *
from test_table2
left join test_table1
on test_table1.id = test_table2.id;

# OUTER JOIN

## The outher join only shows all records in both tables.
## This is identical to "merge" in R with the argument "all = TRUE"
## In this case, a person with id = 2 is present and fields for books are fileld with NULL

select *
from test_table1
left join test_table2
on test_table1.id = test_table2.id

UNION

select *
from test_table1
right join test_table2
on test_table1.id = test_table2.id;

# SELF JOIN

## Self join will join a table with itself
## It will create two temporary tables "a" and "b" that will not appear anywhere

select *
from test_table1 a, test_table1 b
where a.id = b.id;

# CARTESIAN JOIN

## Cartesian join joins two tables simply by repeating all records of the second table for the first record in the first table etc.
## No id column is specified because the tables are not actually joined by any key field

select *
from test_table1, test_table2;

# OPERATIONS WITH JOINS

## Count a number of books written by individual people

SELECT test_table1.given_name, test_table1.family_name, count(test_table2.id)
FROM test_table1
LEFT JOIN test_table2
ON test_table1.id = test_table2.id
GROUP BY test_table1.id;

# UNION

## A UNION statement will combine results of multiple SELECT statements
## If the statements produce duplicate records, it will only return those once
## To use UNION, each SELECT must have the same number of columns selected, the same number of column expressions, the same data type, and have them in the same order, but they do not have to be the same length

# UNION ALL

## A UNION ALL statement will combine results of multiple SELECT statements and will include duplicate records

# IS (NOT) NULL

## return a list of authors that wrote no books

select *
from test_table1
left join test_table2
on test_table1.id = test_table2.id
where book_id is null;

# TRANSACTIONS

## ROLLBACK reverts a database to a state before the last COMMIT

## COMMIT saves changes made to the database. At that point, it is not possible to ROLLBACK to a previous state

## SAVEPOINT creates a save point that it is possible to ROLLBACK TO

savepoint new_savepoint;

## ROLLBACK TO  revers a database to a savepoint

rollback to new_savepoint;

## RELEASE SAVEPOINT deletes a savepoint

release savepoint new_savepoint;

# USING SEQUENCES

## AUTO_INCREMENT - is a property of a table set when a table is created. When data is loaded or inserted, NULL is entered and MySQL will automatically fill in the next value in the sequence
## The AUTO_INCREMENT field must also be a key

create table test_table4(
id int primary key auto_increment,
name varchar(20)
);

insert into test_table4
values (NULL, "kamil gregor"), (NULL, "jan dvořák");

select * from test_table4;

drop table test_table4;

## starting an AUTO_INCREMENT field from 100

create table test_table4(
id int primary key AUTO_INCREMENT,
name varchar(20)
);

alter table test_table4 AUTO_INCREMENT = 1001;

insert into test_table4
values (NULL, "kamil gregor"), (NULL, "jan dvořák");

select * from test_table4;

drop table test_table4;

# MISC

## show current date and time

select now();

## show current data

select current_date;

## return an online help

HELP "select";

## show which database is being in USE

SELECT database();

## list all tables in a database;

show tables in test_database;

## return a random number

select rand();

## order records randomly

select *
from test_table1
order by rand();

## concatenate two strings

select concat("kamil ", "gregor");