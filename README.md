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


![ERD mini project](https://raw.githubusercontent.com/Chandankjk/sql-mini_project/main/ERD_mini_project.jpg)


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





## Handling Null Values

```sql
-- Query to check NULL value. This is only done for the columns that do not have PRIMARY KEY or NULL Value constraint on it

SELECT COUNT(*) FROM customers WHERE reg_date IS NULL;  -- return Zero
SELECT COUNT(*) FROM restaurants WHERE city IS NULL OR opening_hours IS NULL;   -- return Zero
SELECT COUNT(*) FROM orders WHERE order_item IS NULL OR order_status IS NULL; -- return Zero, not checking FK columns
SELECT COUNT(*) FROM riders WHERE sign_up IS NULL;  -- return Zero
SELECT COUNT(*) FROM deliveries WHERE delivery_status IS NULL OR delivery_time IS NULL; -- return Zero, not checking FK columns

-- No NULL value found in tables so no remediation action is required 
-- End of NULL value check 
```
## Descriptive statistics such as count, sum, average, minimum, and maximum for numerical columns

### 1. The restaurant table doesn't have a numerical column, hence only counting the rows
```sql
SELECT COUNT(*) FROM restaurants; -- Total 71 Restaurants in table
```
### 2. customers table doesn't have a numerical column
```sql
SELECT COUNT(*) FROM customers; -- Total 33 customers in the table
```
### 3. orders table have total_amount as a numeric column
```sql
SELECT 
    YEAR(order_date) AS order_year,
    AVG(total_amount) AS avg_amount,
    MIN(total_amount) AS min_amount,
    MAX(total_amount) AS max_amount
FROM 
    orders
GROUP BY 
    YEAR(order_date);
```


This section gives aggregated avg, min and max values for total_amount column for the years 2023 and 2024.

| Year | avg_amount  | min_amount       | max_amount|
|------|-------------|------------------|-----------|
| 2024 | 317.76      | 217              | 495       |
| 2023 | 322.83      | 199              | 750       |
```sql
SELECT COUNT(*) FROM orders;  -- Total 10000 rows or orders details 
```
### 4. The riders table doesn't have a numerical column
```sql
SELECT COUNT(*) FROM riders;  -- Total 34 riders in the table 
```
### 5. deliveries table doesn't have a numerical column 
```sql
SELECT COUNT(*) FROM deliveries;  -- Total 9750 deliveries data in the table
```
## Exploratory Data Analysis

### 1. Write a query 

```sql

```

### 2. 

```sql

```

## Insights and Conclusions

## Insights and Conclusions
### 1. Customer Activity Analysis
   a. By doing customer analysis we got to know who are our most valued customers, what each customer is spending, what are the min, max and avg of their spending.
   b. we got to know the most active customers on the platform, who placed orders more than the average number of orders by all customers
   c. We also labeled the customers as platinum, gold, and silver of this food delivery platform based on their spending, these customers can be given customized offers
   
### 2. Restaurant Performance Analysis
   a. Here  we analyzed which restaurants perform best in terms of orders and revenue
   b. We got to know some restaurants did not take any orders, maybe they have closed or there is a possibility that they stopped using the Zomato platform
   c. Based on the total revenue generated, we ranked the restaurants, these restaurants can be given discounts on platform charges or any other benefits by the platform
   d. We also calculated the busiest day for every restaurant, based on this data restaurants can plan their operation, staffing, and inventory
    
### 3. Delivery Time and Status Analysis
   a. In this section by querying the table our focus was to understand delivery patterns and identify any issues with delivery performance.
   b. We quickly know how many orders are "Delivered", "Not delivered" or in the "Order" state
   c. By querying total deliveries per rider we got to know top delivery persons, the platform can give them extra benefits or commission on crossing a certain number of delivery
   d. Also some riders left the platform, as they did not have any deliveries
   e. We got to know the number of orders that were not delivered, also give the restaurant name and city and number of orders not delivered based on this data platform can try to interview these 
      restaurants and try to find the root cause of the issue
   
### 4. Order Trends Over Time
   a. Here we discovered ordering patterns over different periods, which year and month the platform received how many orders
   b. In 2024 the data is just from Jan, so we can ignore jan-2024
   c. Zomato got most order in Oct-2023 , followed by Mar-2023 and July-2023
   d. By analyzing orders per week we got to know, that Sunday is most busiest day for the platform as they get more orders on Sunday than any other day
   e. By analyzing orders by hours, we got to know Restaurants gets more orders in 2nd half of the day
   f. During lunchtime at 2 PM - 3 PM, they get the most orders, also during the 7 PM also there is high amount of orders for restaurants
   
### 5. Revenue Analysis
    a. By analyzing total revenue per month, restaurants generated more  revenue  in March, October, and July of 2023
    b. By querying the revenue by city, we got to know Restaurants of Mumbai generated more revenue followed by Bangalore and the Delhi and Hyderabad
   
### 6. Rider Efficiency Analysis
     a. Top 3 riders who did most of the delivery, they can be delivery stars for the year and can be provided with some extra benefits
     b. We identified riders with delayed deliveries, Considering if they are not able to deliver within one hour after the order is placed
     c. we also calculated top 5 riders defaulted or missed the one-hour SLA most number of times , these riders can be addressed for the making SLA miss or a root cause analysis can be done of delay 
        by interviewing them 
### 7. Order Item Analysis
     a. 
## Future enhancement

#### 1.  Automate the process of uploading CSV files into MySQL tables by using Python’s mysql-connector which will have following steps :
        a. Use Python’s mysql-connector library to establish a connection to MySQL database.
        b. Write a function to dynamically generate the SQL CREATE TABLE query based on the structure of the CSV file 
        c. Write a function to insert the CSV data into the newly created table.  
        d. Implement exception handling to deal with issues such as database connectivity problems, duplicate tables, etc. 


## Notice 
All customer names and data used in this project are 'made up' data. They do not represent real data associated with Zomato and any resemblance to actual persons is purely coincidental.
