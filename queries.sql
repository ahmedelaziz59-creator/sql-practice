-- SQL practice exercises
-- Interview-style questions on small sample data (e-commerce).
-- Each exercise has the question, my query, and the expected result.

-- ---------------------------------------------------------------
-- Sample data
-- ---------------------------------------------------------------
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    name        TEXT,
    signup_date TEXT,
    country     TEXT
);

CREATE TABLE orders (
    order_id     INTEGER PRIMARY KEY,
    customer_id  INTEGER,
    order_date   TEXT,
    status       TEXT,
    total_amount INTEGER
);

CREATE TABLE products (
    product_id   INTEGER PRIMARY KEY,
    product_name TEXT,
    category     TEXT
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id      INTEGER,
    product_id    INTEGER,
    quantity      INTEGER,
    unit_price    INTEGER
);

INSERT INTO customers VALUES
    (1, 'Ann',  '2025-11-02', 'US'),
    (2, 'Bob',  '2026-01-15', 'UK'),
    (3, 'Cara', '2026-03-20', 'US'),
    (4, 'Dev',  '2026-02-08', 'India'),
    (5, 'Eli',  '2026-04-22', 'UK'),
    (6, 'Fay',  '2026-05-30', 'Canada'),
    (7, 'Gus',  '2026-07-14', 'India');

INSERT INTO orders VALUES
    (101, 1, '2026-01-10', 'completed', 120),
    (102, 1, '2026-02-14', 'completed',  80),
    (103, 2, '2026-02-20', 'cancelled', 300),
    (104, 2, '2026-03-05', 'completed', 150),
    (105, 3, '2025-12-30', 'completed', 500),
    (106, 4, '2026-04-01', 'refunded',   90),
    (107, 3, '2026-05-12', 'completed', 200),
    (108, 5, '2026-06-01', 'completed', 100),
    (109, 4, '2026-06-15', 'completed',  60);

INSERT INTO products VALUES
    (1, 'Laptop', 'Electronics'),
    (2, 'Mouse',  'Electronics'),
    (3, 'Desk',   'Furniture'),
    (4, 'Lamp',   'Furniture');

INSERT INTO order_items VALUES
    (1, 101, 1, 2, 900),
    (2, 101, 2, 5,  20),
    (3, 102, 2, 3,  20);


-- ---------------------------------------------------------------
-- 1. Top 3 customers by spend
-- Return the top 3 customers by total spend on completed orders in 2026.
-- Show name, country, and total spend.
-- Concepts: INNER JOIN, WHERE with a date range, GROUP BY, SUM, ORDER BY, LIMIT
-- Expected: Ann (US) 200, Cara (US) 200, Bob (UK) 150
-- ---------------------------------------------------------------
SELECT
    customers.name,
    customers.country,
    SUM(total_amount) AS total_amount_spend
FROM customers
INNER JOIN orders
    ON customers.customer_id = orders.customer_id
WHERE status = 'completed'
  AND order_date >= '2026-01-01'
  AND order_date <  '2027-01-01'
GROUP BY customers.customer_id, customers.name, customers.country
ORDER BY total_amount_spend DESC
LIMIT 3;


-- ---------------------------------------------------------------
-- 2. Products that were never sold
-- Return the product_name of every product that has never been sold.
-- Concepts: LEFT JOIN, IS NULL on the right table
-- Expected: Desk, Lamp
-- ---------------------------------------------------------------
SELECT
    products.product_name
FROM products
LEFT JOIN order_items
    ON products.product_id = order_items.product_id
WHERE order_items.order_item_id IS NULL;


-- ---------------------------------------------------------------
-- 3. Total quantity sold per product
-- For each product, return the product_name and total quantity sold,
-- highest first.
-- Concepts: INNER JOIN, SUM, GROUP BY, ORDER BY DESC
-- Expected: Mouse 8, Laptop 2
-- ---------------------------------------------------------------
SELECT
    products.product_name,
    SUM(quantity) AS total_quantity_amount
FROM products
INNER JOIN order_items
    ON products.product_id = order_items.product_id
GROUP BY products.product_id, products.product_name
ORDER BY total_quantity_amount DESC;


-- ---------------------------------------------------------------
-- 4. Customers with a high total
-- For each customer, return the name and total amount of completed orders
-- in 2026. Only customers whose total is above 150. Highest first.
-- Concepts: HAVING with an aggregate, WHERE vs HAVING
-- Expected: Ann 200, Cara 200
-- ---------------------------------------------------------------
SELECT
    customers.name,
    SUM(total_amount) AS total_order_amount
FROM customers
INNER JOIN orders
    ON customers.customer_id = orders.customer_id
WHERE status = 'completed'
  AND order_date <  '2027-01-01'
  AND order_date >= '2026-01-01'
GROUP BY customers.name
HAVING SUM(total_amount) > 150
ORDER BY total_order_amount DESC;


-- ---------------------------------------------------------------
-- 5. Top 2 countries by revenue
-- Return the top 2 countries by total revenue from completed orders in 2026.
-- Concepts: JOIN, GROUP BY country, SUM, ORDER BY, LIMIT
-- Expected: US 400, UK 250
-- ---------------------------------------------------------------
SELECT
    customers.country,
    SUM(total_amount) AS total_revenue
FROM customers
INNER JOIN orders
    ON customers.customer_id = orders.customer_id
WHERE status = 'completed'
  AND order_date <  '2027-01-01'
  AND order_date >= '2026-01-01'
GROUP BY country
ORDER BY SUM(total_amount) DESC
LIMIT 2;


-- ---------------------------------------------------------------
-- 6. Customers who never ordered
-- Return the name and country of every customer who has never placed an order.
-- Concepts: LEFT JOIN, IS NULL on the right table
-- Expected: Fay (Canada), Gus (India)
-- ---------------------------------------------------------------
SELECT
    customers.name,
    country
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
WHERE order_id IS NULL;
