# GROUP 11
# SQL mini Project: Data Analysis for Zomato dataset using MySql workbench
# Objective :
The objective of this project is to perform SQL queries on a schema, and demonstrate our understanding of SQL concepts and data analysis techniques. Also extract meaningful insights from the data and present our findings

## Overview

This project demonstrates our SQL  skills through the analysis of dataset for Zomato, a food delivery company in India. The project involves setting up the database, creating the tables, importing data in csv format to the tables, handling null values, and analyzing the data using complex SQL queries and try to get meaningful insights from these data.

## Project Structure

- **Database Setup:** Creation of the `zomato_db` database and the required tables.
- **Data Import:** Inserting sample data into the tables.
- **Data Cleaning:** Handling null values and ensuring data integrity.
- **Data Analysis :** Using SQL queries to analyse the data in the tables.

## ER diagram (Entity-Relationship diagram) 
This is a visual representation of the structure of the `zomato_db` database, showing the entities (tables), attributes (columns), and the relationships between entities

![image](https://github.com/Chandankjk/sql-mini_project/blob/main/02A916B2-26B3-4708-8199-8E3710429081.jpeg)

## Database Creation 
```sql
CREATE DATABASE zomato_db;

-- connect to zomato_db;
USE zomato_db;

```

### 1. Creating Tables
```sql
-- Create restaurants table
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    opening_hours VARCHAR(50)
);

-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    reg_date DATE
);

-- Create Orders table

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_item VARCHAR(255),
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    order_status VARCHAR(20) DEFAULT 'Pending',
    total_amount FLOAT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);


-- Create riders table
CREATE TABLE riders (
    rider_id INT PRIMARY KEY,
    rider_name VARCHAR(100) NOT NULL,
    sign_up DATE
);

-- Create deliveries table

CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT,
    delivery_status VARCHAR(20) DEFAULT 'Pending',
    delivery_time TIME,
    rider_id INT,
    FOREIGN KEY (rider_id) REFERENCES riders(rider_id) 
);
-- order_id is a FK  in deliveries table , adding FK contraint 
ALTER TABLE deliveries
ADD CONSTRAINT fk_order_id
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


-- Schemas END

```

## Importing the data to the Table

This is done using the "Table Data Import Wizard"

## Verifying that the data uploaded and tables have the data 

```sql
-- To check that ,the data uploaded ,following sql query used 
select * from customers;
select * from deliveries;
select * from restaurants;
select * from riders;
select * from Orders;
```


# Showing the columns and data type information for all the tables 
```sql
use zomato_db;
-- Displaying the different table information in zomato_db
DESCRIBE customers;
DESCRIBE restaurants;
DESCRIBE orders;
DESCRIBE riders;
DESCRIBE deliveries;
```


### Table Structure: `customers`

| Column Name      | Data Type         | Null Allowed | Key    | Default Value | Extra |
|------------------|-------------------|--------------|--------|---------------|-------|
| `customer_id`     | `INT`             | NO           | PRI    | `NULL`        |       |
| `customer_name`   | `VARCHAR(100)`    | NO           |        | `NULL`        |       |
| `reg_date`        | `DATE`            | YES          |        | `NULL`        |       |


### Table Structure: `restaurants`

| Column Name        | Data Type         | Null Allowed | Key    | Default Value | Extra |
|--------------------|-------------------|--------------|--------|---------------|-------|
| `city`             | `VARCHAR(50)`     | YES          |        | `NULL`        |       |
| `opening_hours`    | `VARCHAR(50)`     | YES          |        | `NULL`        |       |
| `restaurant_id`    | `INT`             | NO           | PRI    | `NULL`        |       |
| `restaurant_name`  | `VARCHAR(100)`    | NO           |        | `NULL`        |       |

### Table Structure: `orders`

| Column Name        | Data Type         | Null Allowed | Key    | Default Value | Extra |
|--------------------|-------------------|--------------|--------|---------------|-------|
| `order_id`         | `INT`             | NO           | PRI    | `NULL`        |       |
| `customer_id`      | `INT`             | YES          | MUL    | `NULL`        |       |
| `restaurant_id`    | `INT`             | YES          | MUL    | `NULL`        |       |
| `order_item`       | `VARCHAR(255)`    | YES          |        | `NULL`        |       |
| `order_date`       | `DATE`            | NO           |        | `NULL`        |       |
| `order_time`       | `TIME`            | NO           |        | `NULL`        |       |
| `order_status`     | `VARCHAR(20)`     | YES          |        | `Pending`     |       |
| `total_amount`     | `FLOAT`           | NO           |        | `

### Table Structure: `riders`

| Column Name      | Data Type         | Null Allowed | Key    | Default Value | Extra |
|------------------|-------------------|--------------|--------|---------------|-------|
| `rider_id`       | `INT`             | NO           | PRI    | `NULL`        |       |
| `rider_name`     | `VARCHAR(100)`    | NO           |        | `NULL`        |       |
| `sign_up`        | `DATE`            | YES          |        | `NULL`        |       |

### Table Structure: `deliveries`


| Column Name        | Data Type         | Null Allowed | Key    | Default Value | Extra |
|--------------------|-------------------|--------------|--------|---------------|-------|
| `delivery_id`      | `INT`             | NO           | PRI    | `NULL`        |       |
| `order_id`         | `INT`             | YES          | MUL    | `NULL`        |       |
| `delivery_status`   | `VARCHAR(20)`     | YES          |        | `Pending`     |       |
| `delivery_time`    | `TIME`            | YES          |        | `NULL`        |       |
| `rider_id`        | `INT`             | YES          | MUL    | `NULL`        |       |





## Data Cleaning and Handling Null Values

Before doing analysis on the table,

```sql
UPDATE orders
SET total_amount = COALESCE(total_amount, 0);
```

## Exploratory Data Analysis

### 1. Write a query 

```sql

```

### 2. 

```sql

```

## Insights and Conclusions




## Notice 
All customer names and data used in this project are 'made up' data. They do not represent real data associated with Zomato and any resemblance to actual persons is purely coincidental.
