-- SQL Project
-- Zomato Exploratory data analysis

CREATE DATABASE zomato_db;

-- connect to zomato_db;
USE zomato_db;

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

-- data is imported through the MySql "Table Data Import Wizard" for all the table created 
-- To check that ,the data uploaded ,following sql query used 
select * from customers;
select * from deliveries;
select * from restaurants;
select * from riders;
select * from Orders;



