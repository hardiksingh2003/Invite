
-- SalesDB Analytics Project
-- Author: Hardik Singh
-- Description: Schema, sample data, and analytical queries
-- =========================================================

-- =====================
-- 1. Schema Definition
-- =====================
CREATE DATABASE SalesDB;
USE SalesDB;

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    region VARCHAR(50),
    signup_date DATE
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_method VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- =====================
-- 2. Sample Data Insert
-- =====================
INSERT INTO Customers VALUES
(1, 'Amit Sharma', 'North', '2024-01-15'),
(2, 'Priya Verma', 'South', '2024-02-10'),
(3, 'Rohit Singh', 'East', '2024-03-05');

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 55000),
(102, 'Smartphone', 'Electronics', 25000),
(103, 'Shoes', 'Fashion', 3000);

INSERT INTO Orders VALUES
(1001, 1, 101, '2024-04-01', 1),
(1002, 2, 102, '2024-04-02', 2),
(1003, 3, 103, '2024-04-03', 1);

INSERT INTO Payments VALUES
(5001, 1001, 55000, '2024-04-01', 'Credit Card'),
(5002, 1002, 50000, '2024-04-02', 'UPI'),
(5003, 1003, 3000, '2024-04-03', 'Cash');

-- =====================
-- 3. Analytical Queries
-- =====================

-- Total Revenue
SELECT SUM(amount) AS total_revenue FROM Payments;

-- Revenue by Region
SELECT c.region, SUM(p.amount) AS revenue
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.region;

-- Top Customers by Spend
SELECT c.name, SUM(p.amount) AS total_spent
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- Product Category Performance
SELECT pr.category, SUM(p.amount) AS category_sales
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id
JOIN Products pr ON o.product_id = pr.product_id
GROUP BY pr.category;
