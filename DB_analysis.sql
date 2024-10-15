-- Generic Analysis queries 
use zomato_db;
-- Displaying the different table information in zomato_db
DESCRIBE customers;
DESCRIBE restaurants;
DESCRIBE orders;
DESCRIBE riders;
DESCRIBE deliveries;

-- Query to check NULL value for the columns which is doesnot have PRIMARY KEY or NULL Value constraint

SELECT COUNT(*) FROM customers WHERE reg_date IS NULL;  -- return Zero
SELECT COUNT(*) FROM restaurants WHERE city IS NULL OR opening_hours IS NULL;   -- return Zero
SELECT COUNT(*) FROM orders WHERE order_item IS NULL OR order_status IS NULL; -- return Zero, not checking FK columns
SELECT COUNT(*) FROM riders WHERE sign_up IS NULL;  -- return Zero
SELECT COUNT(*) FROM deliveries WHERE delivery_status IS NULL OR delivery_time IS NULL; -- return Zero, not checking FK columns

-- No NULL value found in tables so no remediation action require 
-- End of NULL value check 

-- Descriptive statistics such as count, sum, average, minimum, and maximum for numerical columns
-- 1. restaurants table doesn't have numerical column , hence only counting the rows 
SELECT COUNT(*) FROM restaurants; -- Total 71 Restaurants in table 
-- 2. customers table doesn't have numerical column 
SELECT COUNT(*) FROM customers; -- Total 33 customers in the table 
-- 3. orders table have total_amount as a numeric column 
SELECT 
    YEAR(order_date) AS order_year,
    AVG(total_amount) AS avg_amount,
    MIN(total_amount) AS min_amount,
    MAX(total_amount) AS max_amount
FROM 
    orders
GROUP BY 
    YEAR(order_date);

-- 4. riders table doesn't have numerical column  
SELECT COUNT(*) FROM riders;  -- Total 34 riders in the table 

-- 5. deliveries table doesn't have numerical column 


