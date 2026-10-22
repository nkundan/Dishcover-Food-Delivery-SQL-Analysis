Dishcover: Food Delivery SQL Analysis

A beginner-friendly SQL project that analyses food delivery data in MySQL Workbench.

Tools

SQL, MySQL, MySQL Workbench

Dataset
Table	Rows
customers	33
restaurants	71
riders	34
orders	10,000
deliveries	9,750

Orders cover 1 Jan 2023 to 25 Jan 2024.

What I Did
Created the database and 5 tables (Zomato_Schemas.sql) and loaded the CSV files.
Checked and removed NULL values.
Wrote 10 business queries using JOINs, GROUP BY, HAVING, CASE, subqueries and window functions (RANK, LAG).
Questions Answered
Which 2-hour time slots get the most orders?
Average order value of customers with more than 750 orders
Customers who spent more than 100K
Orders without a delivery record
Customers who ordered in 2023 but not in 2024
Top restaurant in each city (2023)
Most popular dish in each city
Monthly sales trend (month over month)
Gold / Silver customer segmentation
Customer lifetime value
Key Findings
Busiest order time slot: 2 PM to 4 PM (1,188 orders).
14 customers spent more than 100K; Sneha Desai is highest at 269,197.
9 customers ordered in 2023 but not in 2024.
Top restaurant by city (2023): The Oberoi (Bengaluru), Annalakshmi (Chennai), Saravana Bhavan (Delhi), Ohri's Jiva Imperia (Hyderabad), Bademiya (Mumbai).
Segmentation: 7 Gold customers and 17 Silver customers.
Files
Zomato_Schemas.sql - database and table creation
Dishcover_10_Queries_with_Output.sql - 10 queries with outputs
data/ - CSV files (customers, restaurants, riders, orders, deliveries)
How to Run
Open MySQL Workbench and run Zomato_Schemas.sql.
Import the CSV files into their tables (Table Data Import Wizard).
Run Dishcover_10_Queries_with_Output.sql.
