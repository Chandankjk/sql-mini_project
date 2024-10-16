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
	c.customer_id;

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
GROUP BY r.rider_id
ORDER BY total_deliveries
LIMIT 3;

-- Top 3 riders who did most of the delivery are 1. Naveen Nair 2.Ravi Ranjan 3.Sanjay Kumar
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



