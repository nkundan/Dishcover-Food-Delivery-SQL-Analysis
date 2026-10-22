-- =====================================================
-- Dishcover: Food Delivery SQL Project - Queries with Outputs
-- MySQL Workbench | 10 business questions
-- Each query is followed by its output (as comments).
-- Tables: customers (33), restaurants (71), riders (34),
--         orders (10,000), deliveries (9,750)
-- Orders cover 2023-01-01 to 2024-01-25
-- =====================================================

USE dishcover_db;

-- Q.1 Popular Time Slots  [CASE, GROUP BY]
-- Which 2-hour time slots get the most orders?
SELECT
    CASE
        WHEN HOUR(order_time) BETWEEN 6 AND 7   THEN '06:00 - 08:00'
        WHEN HOUR(order_time) BETWEEN 8 AND 9   THEN '08:00 - 10:00'
        WHEN HOUR(order_time) BETWEEN 10 AND 11 THEN '10:00 - 12:00'
        WHEN HOUR(order_time) BETWEEN 12 AND 13 THEN '12:00 - 14:00'
        WHEN HOUR(order_time) BETWEEN 14 AND 15 THEN '14:00 - 16:00'
        WHEN HOUR(order_time) BETWEEN 16 AND 17 THEN '16:00 - 18:00'
        WHEN HOUR(order_time) BETWEEN 18 AND 19 THEN '18:00 - 20:00'
        WHEN HOUR(order_time) BETWEEN 20 AND 21 THEN '20:00 - 22:00'
        WHEN HOUR(order_time) BETWEEN 22 AND 23 THEN '22:00 - 00:00'
        ELSE '00:00 - 06:00'
    END AS time_slot,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY time_slot
ORDER BY order_count DESC;

-- OUTPUT:
-- +---------------+-------------+
-- | time_slot     | order_count |
-- +---------------+-------------+
-- | 14:00 - 16:00 |        1188 |
-- | 18:00 - 20:00 |        1136 |
-- | 22:00 - 00:00 |        1123 |
-- | 12:00 - 14:00 |        1115 |
-- | 10:00 - 12:00 |        1107 |
-- | 20:00 - 22:00 |        1089 |
-- | 16:00 - 18:00 |        1080 |
-- | 08:00 - 10:00 |        1076 |
-- | 06:00 - 08:00 |        1074 |
-- | 00:00 - 06:00 |          12 |
-- +---------------+-------------+


-- Q.2 Order Value Analysis  [JOIN, GROUP BY, HAVING]
-- Average order value of customers who placed more than 750 orders.
SELECT
    c.customer_id,
    c.customer_name,
    AVG(o.total_amount) AS aov
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 750;

-- OUTPUT:
-- +-------------+---------------+------------+
-- | customer_id | customer_name | aov        |
-- +-------------+---------------+------------+
-- |           5 | Aman Gupta    | 333.318653 |
-- |           6 | Sneha Desai   | 333.577447 |
-- |           7 | Rahul Verma   | 339.060802 |
-- +-------------+---------------+------------+


-- Q.3 High-Value Customers  [JOIN, SUM, HAVING]
-- Customers who spent more than 100K in total.
SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) > 100000;

-- OUTPUT:
-- +-------------+-----------------+-------------+
-- | customer_id | customer_name   | total_spent |
-- +-------------+-----------------+-------------+
-- |           4 | Ritu Patel      |   242681.00 |
-- |           5 | Aman Gupta      |   257322.00 |
-- |           6 | Sneha Desai     |   269197.00 |
-- |           7 | Rahul Verma     |   262094.00 |
-- |           8 | Neha Joshi      |   243223.00 |
-- |           9 | Karan Kapoor    |   244287.00 |
-- |          15 | Nikhil Jain     |   168782.00 |
-- |          16 | Aarti Yadav     |   146145.00 |
-- |          17 | Manish Kulkarni |   162552.00 |
-- |          18 | Shreya Ghosh    |   150807.00 |
-- |          19 | Aakash Dubey    |   150866.00 |
-- |          20 | Bhavna Agarwal  |   154368.00 |
-- |          21 | Ramesh Chandra  |   143571.00 |
-- |          22 | Kavita Malhotra |   154737.00 |
-- +-------------+-----------------+-------------+


-- Q.4 Orders Without Delivery  [LEFT JOIN, IS NULL]
-- Restaurant name, city and number of orders with no delivery record.
SELECT
    r.restaurant_name,
    r.city,
    COUNT(o.order_id) AS cnt_not_delivered_orders
FROM orders AS o
LEFT JOIN restaurants AS r ON r.restaurant_id = o.restaurant_id
LEFT JOIN deliveries  AS d ON d.order_id = o.order_id
WHERE d.delivery_id IS NULL
GROUP BY r.restaurant_name, r.city
ORDER BY cnt_not_delivered_orders DESC;

-- OUTPUT:
-- +---------------------------+-----------+--------------------------+
-- | restaurant_name           | city      | cnt_not_delivered_orders |
-- +---------------------------+-----------+--------------------------+
-- | Britannia & Co.           | Mumbai    |                       16 |
-- | Indigo                    | Mumbai    |                       13 |
-- | Bademiya                  | Mumbai    |                       13 |
-- | The Bombay Canteen        | Mumbai    |                       12 |
-- | Masala Library            | Mumbai    |                       12 |
-- | Mahesh Lunch Home         | Mumbai    |                       12 |
-- | Ziya                      | Mumbai    |                       11 |
-- | Leopold Cafe              | Mumbai    |                       10 |
-- | Gajalee                   | Mumbai    |                        9 |
-- | Yauatcha                  | Mumbai    |                        8 |
-- | Nagarjuna                 | Bengaluru |                        7 |
-- | The Spicy Venue           | Hyderabad |                        6 |
-- +---------------------------+-----------+--------------------------+
-- (Showing first 12 of 51 rows)


-- Q.5 Customer Churn  [Subquery, NOT IN]
-- Customers who ordered in 2023 but not in 2024.
SELECT DISTINCT customer_id
FROM orders
WHERE YEAR(order_date) = 2023
  AND customer_id NOT IN (
        SELECT DISTINCT customer_id
        FROM orders
        WHERE YEAR(order_date) = 2024
          AND customer_id IS NOT NULL
  )
ORDER BY customer_id;

-- OUTPUT:
-- +-------------+
-- | customer_id |
-- +-------------+
-- |           5 |
-- |           6 |
-- |           9 |
-- |          11 |
-- |          18 |
-- |          21 |
-- |          22 |
-- |          23 |
-- |          24 |
-- +-------------+


-- Q.6 Top Restaurant in Each City (2023)  [RANK, PARTITION BY]
-- Rank restaurants by revenue within their city.
-- Remove "WHERE rnk = 1" to see the full ranking.
SELECT *
FROM (
    SELECT
        r.city,
        r.restaurant_name,
        SUM(o.total_amount) AS revenue,
        RANK() OVER (PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) AS rnk
    FROM orders AS o
    JOIN restaurants AS r ON r.restaurant_id = o.restaurant_id
    WHERE YEAR(o.order_date) = 2023
    GROUP BY r.city, r.restaurant_name
) AS t1
WHERE rnk = 1
ORDER BY city;

-- OUTPUT:
-- +-----------+-----------------------+-----------+-----+
-- | city      | restaurant_name       | revenue   | rnk |
-- +-----------+-----------------------+-----------+-----+
-- | Bengaluru | The Oberoi            |  57046.00 |   1 |
-- | Chennai   | Annalakshmi           |  46831.00 |   1 |
-- | Delhi     | Saravana Bhavan       |  26265.00 |   1 |
-- | Hyderabad | Ohri’s Jiva Imperia   |  48289.00 |   1 |
-- | Mumbai    | Bademiya              | 156853.00 |   1 |
-- +-----------+-----------------------+-----------+-----+


-- Q.7 Most Popular Dish in Each City  [RANK, PARTITION BY]
SELECT *
FROM (
    SELECT
        r.city,
        o.order_item AS dish,
        COUNT(o.order_id) AS total_orders,
        RANK() OVER (PARTITION BY r.city ORDER BY COUNT(o.order_id) DESC) AS rnk
    FROM orders AS o
    JOIN restaurants AS r ON r.restaurant_id = o.restaurant_id
    GROUP BY r.city, o.order_item
) AS t1
WHERE rnk = 1
ORDER BY city;

-- OUTPUT:
-- +-----------+----------------------+--------------+-----+
-- | city      | dish                 | total_orders | rnk |
-- +-----------+----------------------+--------------+-----+
-- | Bengaluru | Chicken Biryani      |          172 |   1 |
-- | Chennai   | Mutton Rogan Josh    |           74 |   1 |
-- | Delhi     | Paneer Butter Masala |           97 |   1 |
-- | Hyderabad | Chicken Biryani      |           81 |   1 |
-- | Mumbai    | Paneer Butter Masala |          363 |   1 |
-- +-----------+----------------------+--------------+-----+


-- Q.8 Monthly Sales Trend  [LAG, month-over-month]
-- Compare each month's sales with the previous month.
SELECT
    YEAR(order_date)  AS yr,
    MONTH(order_date) AS mth,
    SUM(total_amount) AS total_sale,
    LAG(SUM(total_amount), 1) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) AS prev_month_sale
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY yr, mth;

-- OUTPUT:
-- +------+------+------------+-----------------+
-- | yr   | mth  | total_sale | prev_month_sale |
-- +------+------+------------+-----------------+
-- | 2023 |    1 |  275656.00 |            NULL |
-- | 2023 |    2 |  233439.00 |       275656.00 |
-- | 2023 |    3 |  288309.00 |       233439.00 |
-- | 2023 |    4 |  271615.00 |       288309.00 |
-- | 2023 |    5 |  276827.00 |       271615.00 |
-- | 2023 |    6 |  247780.00 |       276827.00 |
-- | 2023 |    7 |  284818.00 |       247780.00 |
-- | 2023 |    8 |  255234.00 |       284818.00 |
-- | 2023 |    9 |  259743.00 |       255234.00 |
-- | 2023 |   10 |  286519.00 |       259743.00 |
-- | 2023 |   11 |  264235.00 |       286519.00 |
-- | 2023 |   12 |  276097.00 |       264235.00 |
-- | 2024 |    1 |    7944.00 |       276097.00 |
-- +------+------+------------+-----------------+


-- Q.9 Customer Segmentation: Gold / Silver  [CASE, subquery]
-- Gold if the customer's average order value is above the overall
-- average order value, otherwise Silver.
SELECT
    cx_category,
    COUNT(*)           AS total_customers,
    SUM(total_orders)  AS total_orders,
    SUM(total_spent)   AS total_revenue
FROM (
    SELECT
        customer_id,
        COUNT(order_id)   AS total_orders,
        SUM(total_amount) AS total_spent,
        CASE
            WHEN AVG(total_amount) > (SELECT AVG(total_amount) FROM orders) THEN 'Gold'
            ELSE 'Silver'
        END AS cx_category
    FROM orders
    GROUP BY customer_id
) AS t1
GROUP BY cx_category;

-- OUTPUT:
-- +-------------+-----------------+--------------+---------------+
-- | cx_category | total_customers | total_orders | total_revenue |
-- +-------------+-----------------+--------------+---------------+
-- | Gold        |               7 |         4548 |    1519551.00 |
-- | Silver      |              17 |         5452 |    1708665.00 |
-- +-------------+-----------------+--------------+---------------+


-- Q.10 Customer Lifetime Value (CLV)  [JOIN, SUM]
-- Total revenue generated by each customer.
SELECT
    o.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS CLV
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
ORDER BY CLV DESC;

-- OUTPUT:
-- +-------------+-----------------+-----------+
-- | customer_id | customer_name   | CLV       |
-- +-------------+-----------------+-----------+
-- |           6 | Sneha Desai     | 269197.00 |
-- |           7 | Rahul Verma     | 262094.00 |
-- |           5 | Aman Gupta      | 257322.00 |
-- |           9 | Karan Kapoor    | 244287.00 |
-- |           8 | Neha Joshi      | 243223.00 |
-- |           4 | Ritu Patel      | 242681.00 |
-- |          15 | Nikhil Jain     | 168782.00 |
-- |          17 | Manish Kulkarni | 162552.00 |
-- |          22 | Kavita Malhotra | 154737.00 |
-- |          20 | Bhavna Agarwal  | 154368.00 |
-- |          19 | Aakash Dubey    | 150866.00 |
-- |          18 | Shreya Ghosh    | 150807.00 |
-- +-------------+-----------------+-----------+
-- (Showing first 12 of 24 rows)


-- End of Reports
