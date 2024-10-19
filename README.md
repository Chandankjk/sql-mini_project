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

###  Query used for EDA

```sql
use zomato_db;

-- 1. Customer Activity Analysis
      -- Objective: Identify how active customers are and spot trends.
 -- Total number of orders per customer
SELECT 
	c.customer_name, 
	COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 
	c.customer_id
ORDER BY total_orders DESC;

-- Total,Average,Min and Max order amount per customer
SELECT 
	c.customer_name, 
	SUM(o.total_amount) AS total_order_amount,
    ROUND(AVG(o.total_amount),0) AS avg_order_amount,
    MAX(o.total_amount) AS max_order_amount,
    MIN(o.total_amount) AS min_order_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY 
	c.customer_id;

 --  customers who placed orders more than the average number of orders by all customers
 
-- Step 1: Using CTE calculate the average number of orders per customer
WITH average_orders AS (
    SELECT AVG(customer_order_count) AS avg_order_count
    FROM (
        SELECT customer_id, COUNT(order_id) AS customer_order_count
        FROM orders
        GROUP BY customer_id
    ) AS customer_orders
)

-- Step 2: Main query find customers who placed more orders than the average
  -- This Analysis identify the customers who order frequency is higher than averge number of orders from all customers , these are very active users of platform 
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING total_orders > (SELECT avg_order_count FROM average_orders);


-- Customer registration trends by year
SELECT YEAR(c.reg_date) AS year, COUNT(*) AS total_customers
FROM customers c
GROUP BY year;

/*
This query identifies customers based on how much they’ve spent and assigns them a membership level. The levels are defined as follows:

Platinum Member: Spending more than 250,000.
Gold Member: Spending more than 200,000.
Silver Member: Spending more than 150,000.
Normal Member: Spending 150,000 or less.

This analysis identify the customers category based on their spendings , this will help in providing the special benifits or discount to specific category customers
*/

SELECT 
*,
CASE 
			WHEN  total_spending > 250000  THEN 'Platinum Member'
			WHEN total_spending > 200000  THEN 'Gold Member'
            WHEN total_spending > 150000  THEN 'Silver Member'
			ELSE 'Normal Member'
		END AS customer_type
FROM 
(SELECT 
	o.customer_id,
	c.customer_name,
	SUM(o.total_amount) as total_spending
FROM orders as o
JOIN customers as c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name) AS t;

-- 2. Restaurant Performance Analysis
	-- Objective: Analyze which restaurants perform best in terms of orders and revenue.

-- Total number of orders per restaurant
SELECT 
r.restaurant_name, 
COUNT(o.order_id) AS total_orders
FROM restaurants r
LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id
ORDER BY total_orders ASC;
-- we got to know there are the restaurants which did not took any order 
-- May be they are closed or there is possibility that they stopped using zomato patform

-- Total revenue per restaurant and accordingly calculated ranking of restaurant
SELECT
    *,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS ranking_by_revenue -- windows function for assigning the rank 
FROM 
( -- subquery to find the total revenue per restaurant
    SELECT r.restaurant_name, SUM(o.total_amount) AS total_revenue
    FROM restaurants r
    LEFT JOIN orders o ON r.restaurant_id = o.restaurant_id
    GROUP BY r.restaurant_id
) AS revenue_table
ORDER BY total_revenue DESC;

/*
Query to identifies the busiest day of the week (by order count) for each restaurant using a combination of a window function (DENSE_RANK()) and grouping,
 allowing us to focus on the highest-order day for every restaurant
*/

SELECT -- Main query  
* 
FROM
	(   --  Sub query 
		SELECT 
			r.restaurant_name,
			DAYNAME(o.order_date) AS day_of_week,
			COUNT(o.order_id) as total_orders,
			DENSE_RANK() OVER(PARTITION BY r.restaurant_name ORDER BY COUNT(o.order_id)  DESC) as rank_by_order
		FROM orders as o
		JOIN
		restaurants as r
		ON o.restaurant_id = r.restaurant_id
		GROUP BY 1, 2
		ORDER BY 1, 3 DESC
		) as t1
WHERE rank_by_order = 1;

-- 3. Delivery Time and Status Analysis
	-- Objective: Understand delivery patterns and identify any issues with delivery performance.
-- Deliveries by status
SELECT delivery_status, COUNT(*) AS total_deliveries
FROM deliveries
GROUP BY delivery_status;
-- Total deliveries per rider
SELECT r.rider_name, COUNT(d.delivery_id) AS total_deliveries
FROM riders r
LEFT JOIN deliveries d ON r.rider_id = d.rider_id
GROUP BY r.rider_id;

-- There are riders who left the platform ,as theny do not have any deliveries 

-- Find the number of orders which was not delivered , also give the restaurant name and city and number of orders not delivered. 

SELECT 
	r.restaurant_name,
    r.city,
	COUNT(*) AS orders_not_delivered
FROM orders as o
LEFT JOIN 
restaurants as r
ON r.restaurant_id = o.restaurant_id
WHERE 
	o.order_id NOT IN (SELECT order_id FROM deliveries)
GROUP BY r.restaurant_name,r.city
ORDER BY orders_not_delivered DESC;

-- 4. Order Trends Over Time
	-- Objective: Discover ordering patterns over different time periods.
	
-- Orders by year
SELECT YEAR(order_date) AS year, COUNT(order_id) AS total_orders
FROM orders
GROUP BY year;

-- Mostly the data is from 2023 

-- Orders by month
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, COUNT(order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY total_orders DESC;

-- in 2024 the data is just from Jan , so we can ignore jan-2024
-- Zomato got most order in Oct-2023 , followed by Mar-2023 and July-2023

-- Orders by day of the week
SELECT DAYNAME(order_date) AS day_of_week, COUNT(order_id) AS total_orders
FROM orders
GROUP BY day_of_week
ORDER BY total_orders DESC;

-- Sunday is most busy day for platform as they get more orders on Sunday than anyother day 

-- Orders by hour
SELECT HOUR(order_time) AS hour, COUNT(order_id) AS total_orders
FROM orders
GROUP BY hour
ORDER BY total_orders DESC;

-- Restaurants grts more orders in 2nd half of the day 
-- During the lunch time at 2 PM - 3 PM  , they get most number of orders 
-- During the 7 PM also there is high amount of orders for restaurants 

-- 5. Revenue Analysis
	-- Objective: Gain insights into the overall revenue generated across restaurants and customers.
	
-- Total revenue per month
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS total_revenue
FROM orders
GROUP BY month
ORDER BY total_revenue DESC;

-- More revenue generated by restaurants in March,October and Jusly of 2023 

-- Total revenue per city, also giving rank

SELECT 
	r.city,
	SUM(total_amount) as total_revenue,
	RANK() OVER(ORDER BY SUM(total_amount) DESC) as city_rank
FROM orders as o
JOIN
restaurants as r
ON o.restaurant_id = r.restaurant_id
GROUP BY r.city;

-- Restaurants of Mumbai genetated more revenue follwed by Bangalore and the Delhi and the Hyderabad 

-- 6. Rider Efficiency Analysis
	-- Objective: Analyze the performance and efficiency of riders.

-- Total deliveries per rider
SELECT r.rider_name, COUNT(d.delivery_id) AS total_deliveries
FROM riders r
LEFT JOIN deliveries d ON r.rider_id = d.rider_id
GROUP BY r.rider_id;

-- Top 3 riders who did most of the delivery 
-- They can be delivery star for the year and can be provided with some extra benefits 


-- Riders with delayed deliveries , Considering if they are not able to deliver within one hour after the order is placed 

SELECT r.rider_name, COUNT(d.delivery_id) AS delayed_deliveries
FROM riders r
LEFT JOIN deliveries d ON r.rider_id = d.rider_id
JOIN orders o ON d.order_id = o.order_id
WHERE TIMEDIFF(d.delivery_time, o.order_time) > '01:00:00'
GROUP BY r.rider_id
ORDER BY delayed_deliveries DESC
LIMIT 5;

-- Theses top 5 riders defaulted or missed the one hour SLA most number of times 
-- These riders can be addressed for the making SLA miss or a root cause analysis can be done of delay by interviewing them 


-- 7. Order Item Analysis
	-- Objective: Analyze the most popular order items.
-- Most popular order items
SELECT order_item, COUNT(*) AS total_orders
FROM orders
GROUP BY order_item
ORDER BY total_orders DESC;

-- Chicken Biryani is the most ordered item , followed by Paneer Butter Masala 

-- Popular dish by city 

SELECT * -- Main query 
FROM
(SELECT  -- Sub-query 
	r.city,
	o.order_item as dish,
	COUNT(order_id) as total_orders,
	RANK() OVER(PARTITION BY r.city ORDER BY COUNT(order_id) DESC) as rank_by_dish
FROM orders as o
JOIN 
restaurants as r
ON r.restaurant_id = o.restaurant_id
GROUP BY r.city, dish
) as t1
WHERE rank_by_dish = 1;

-- This gives us the most ordered item by city 
-- Bengaluru - Chicken Biryani
-- Hyderabad - Chicken Biryani 
-- Chennai - Mutton Rogan Josh 
-- Delhi and Mumbai  - Paneer Butter Masala 

-- Track the popularity of specific order items over time and identify seasonal demand spikes.

SELECT 
	order_item,
	seasons,
	COUNT(order_id) as total_orders
FROM 
(
SELECT 
		*,
		EXTRACT(MONTH FROM order_date) as month,
		CASE 
			WHEN EXTRACT(MONTH FROM order_date) BETWEEN 3 AND 4 THEN 'Spring'
			WHEN EXTRACT(MONTH FROM order_date) BETWEEN 5 AND 6 THEN 'Summer'
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 7 AND 9 THEN 'Monsoon'
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 10 AND 11 THEN 'Post-monsoon'
			ELSE 'Winter'
		END as seasons
	FROM orders
) as t
GROUP BY order_item, seasons
ORDER BY total_orders DESC;

-- This give the order fluction for the item based on season 
-- By looking at this analysis restaturants can prepare inventry for those items which is in demand in those seasons 

-- 8. Order Status Breakdown
	-- Objective: Understand how frequently different order statuses occur and track changes over time.
	
-- Count of orders by status
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;

-- Monthly breakdown of order statuses
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY month, order_status;




```


## Insights and Conclusions
### 1. Customer Activity Analysis :
       a. By doing customer analysis we got to know who are our most valued customers, what each customer is spending, what are the min, max and avg of their spending.
       b. we got to know the most active customers on the platform, who placed orders more than the average number of orders by all customers
       c. We also labeled the customers as platinum, gold, and silver of this food delivery platform based on their spending, these customers can be given customized offers
   
### 2. Restaurant Performance Analysis :
       a. Here  we analyzed which restaurants perform best in terms of orders and revenue
       b. We got to know some restaurants did not take any orders, maybe they have closed or there is a possibility that they stopped using the Zomato platform
       c. Based on the total revenue generated, we ranked the restaurants, these restaurants can be given discounts on platform charges or any other benefits by the platform
       d. We also calculated the busiest day for every restaurant, based on this data restaurants can plan their operation, staffing, and inventory
    
### 3. Delivery Time and Status Analysis :
       a. In this section by querying the table our focus was to understand delivery patterns and identify any issues with delivery performance.
       b. We quickly know how many orders are "Delivered", "Not delivered" or in the "Order" state
       c. By querying total deliveries per rider we got to know top delivery persons, the platform can give them extra benefits or commission on crossing a certain number of delivery
       d. Also some riders left the platform, as they did not have any deliveries
       e. We got to know the number of orders that were not delivered, also give the restaurant name and city and number of orders not delivered based on this data platform can try to interview these 
      restaurants and try to find the root cause of the issue
   
### 4. Order Trends Over Time :
           a. Here we discovered ordering patterns over different periods, which year and month the platform received how many orders
           b. In 2024 the data is just from Jan, so we can ignore jan-2024
           c. Zomato got most order in Oct-2023 , followed by Mar-2023 and July-2023
           d. By analyzing orders per week we got to know, that Sunday is most busiest day for the platform as they get more orders on Sunday than any other day
           e. By analyzing orders by hours, we got to know Restaurants gets more orders in 2nd half of the day
           f. During lunchtime at 2 PM - 3 PM, they get the most orders, also during the 7 PM also there is high amount of orders for restaurants
   
### 5. Revenue Analysis :
        a. By analyzing total revenue per month, restaurants generated more  revenue  in March, October, and July of 2023
        b. By querying the revenue by city, we got to know Restaurants of Mumbai generated more revenue followed by Bangalore and the Delhi and Hyderabad
   
### 6. Rider Efficiency Analysis :
         a. Top 3 riders who did most of the delivery, they can be delivery stars for the year and can be provided with some extra benefits
         b. We identified riders with delayed deliveries, Considering if they are not able to deliver within one hour after the order is placed
         c. we also calculated top 5 riders defaulted or missed the one-hour SLA most number of times, these riders can be addressed for the making SLA miss or a root cause analysis can be done of delay 
        by interviewing them 
### 7. Order Item Analysis :
         a. We analyzed the most popular items ordered from all restaurants , Chicken Biryani is the most ordered item, followed by Paneer Butter Masala 
	 b. We analyzed popular dishes by city 
  		-- This gives us the most ordered item by city 
		-- Bengaluru - Chicken Biryani
		-- Hyderabad - Chicken Biryani 
		-- Chennai - Mutton Rogan Josh 
		-- Delhi and Mumbai  - Paneer Butter Masala 
  	c. We also track the popularity of specific order items over time and identify seasonal demand spikes, there is no effect for chicken biryani or dosa on seasons 
   
## Future enhancement

#### 1.  Automate the process of uploading CSV files into MySQL tables by using Python’s mysql-connector which will have the following steps :
            a. Use Python’s mysql-connector library to establish a connection to MySQL database.
            b. Write a function to dynamically generate the SQL CREATE TABLE query based on the structure of the CSV file 
            c. Write a function to insert the CSV data into the newly created table.  
            d. Implement exception handling to deal with issues such as database connectivity problems, duplicate tables, etc. 


## Notice 
All customer names and data used in this project are 'made up' data. They do not represent real data associated with Zomato and any resemblance to actual persons is purely coincidental.
