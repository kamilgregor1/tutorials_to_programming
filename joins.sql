# PREPARE A DATABASE

# create a database called "courses_db"

create database joins_db;

# use the database

use joins_db;

# create a table of authors

CREATE TABLE test_table1(
id int PRIMARY KEY,
given_name varchar(20),
family_name varchar(20),
date_of_birth date,
age int,
height numeric(5,2),
sex char(1)
);

# load data into "test_table1"

load data infile "C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/test.txt"
into table test_table1
fields terminated by ","
ignore 1 lines
;

# create a table of books

create table test_table2(
book_id int,
id int,
title varchar(10),
year int
);

# load data into "test_table2"

load data infile "C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/test2.txt"
into table test_table2
fields terminated by ","
ignore 1 lines;

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