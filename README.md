# Pizza Runner SQL Case Study 2

## Introduction
In this repository, I have created a SQL query related to Danny Ma's SQL Case Study #2, titled "Pizza Runner," to test my SQL query skills. I wrote the query using SQL Server Management Studio 19 (SSMS19). If you're wondering why my syntax differs from that of other people who participated in the Pizza Runner Challenge, it's because my solutions are focused only on Pizza Metrics. However, this challenge comprises four parts: Pizza Metrics, Runner and Customer Experience, Ingredient Optimization, and Pricing and Ratings.

This covers some of the following SQL queries such as:

- Creating table
- Creating temporary tables
- Updating tables
- Altering datatypes
- Joins
- Group by
- Order by
- Selecting row/s
- Common Table Expression (CTE)
- Dates

If you want to check about this specific challenge from the 8 Week SQL Challenge, click this link for more information about the challenge → [Case Study #2 - Pizza Runner](https://8weeksqlchallenge.com/case-study-2/)

## Problem Statement

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!” Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

Because Danny had a few years of experience as a data scientist - he was very aware that data collection was going to be critical for his business’ growth.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

All datasets exist within the pizza_runner database schema

## Entity Relationship Diagram
![ERD](https://github.com/innosy475/Pizza-Runner-SQL-Case-Study-SSMS-19-/assets/144645964/19780aaf-a16d-427e-b657-e316b0bc5357)

## Case Study Questions for Pizza Metrics

**1. How many pizzas were ordered?**
```
SELECT COUNT(order_id) AS PZ_Ordered
FROM #customer_orders_temp
```
![q1](https://github.com/innosy475/Pizza-Runner-SQL-Case-Study-SSMS-19-/assets/144645964/b317bb09-e347-494d-9fbe-7cee995f1e0d)

**2. How many unique customer orders were made?**
```
SELECT COUNT(DISTINCT(order_id)) AS Unique_Order
FROM #customer_orders_temp
```
![q2](https://github.com/innosy475/Pizza-Runner-SQL-Case-Study-SSMS-19-/assets/144645964/5b2e4b03-a94a-4da6-a234-22addd7f68a1)

**3. How many successful orders were delivered by each runner?**
```
SELECT runner_id, COUNT(duration) AS Delivered_by_each_Runner
FROM #runner_orders_temp
WHERE pickup_time <> ''
GROUP BY runner_id
```
![q3](https://github.com/innosy475/Pizza-Runner-SQL-Case-Study-SSMS-19-/assets/144645964/429d9634-f9d4-4edf-bb99-3ff9af447d01)

**4. How many of each type of pizza was delivered?**
```
SELECT PN.pizza_name, COUNT(CO.pizza_id) AS Amount_of_Pizza_Delivered
FROM pizza_names PN
JOIN #customer_orders_temp CO
ON CO.pizza_id = PN.pizza_id
JOIN #runner_orders_temp RO
ON CO.order_id = RO.order_id
WHERE duration <> ''
GROUP BY PN.pizza_name
```
![q4](https://github.com/innosy475/Pizza-Runner-SQL-Case-Study-SSMS-19-/assets/144645964/f3bbdfc1-0fd8-4601-aaed-a7b3281abb96)

**5. How many Vegetarian and Meatlovers were ordered by each customer?**
```
SELECT CO.customer_id, PN.pizza_name, COUNT(CO.pizza_id) AS Vege_Meat_Num
FROM #customer_orders_temp CO
JOIN pizza_names PN
ON CO.pizza_id = PN.pizza_id
GROUP BY CO.customer_id, PN.pizza_name
ORDER BY CO.customer_id
```
![q5](https://github.com/innosy475/Pizza-Runner-SQL-Case-Study-SSMS-19-/assets/144645964/546425d4-1034-4666-a47b-1e32a5db5b65)

**6. What was the maximum number of pizzas delivered in a single order?**
```
SELECT TOP 1 CO.order_id, COUNT(CO.order_id) AS Max_Sgl_Order
FROM #customer_orders_temp CO
JOIN #runner_orders_temp RO ON CO.order_id = RO.order_id
WHERE distance <> 0
GROUP BY CO.order_id
ORDER BY Max_Sgl_Order DESC;
```
![q6](https://github.com/innosy475/Pizza-Runner-SQL-Case-Study-SSMS-19-/assets/144645964/542a0717-5885-4620-a41d-404dd1b7ab79)

**7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**
```
WITH CTE_Change_Num AS (
SELECT order_id, customer_id,
   exclusions, 
   extras, 
  CASE WHEN exclusions <> '' or extras <> '' THEN 'CHANGE'
  ELSE 'DID NOT CHANGE'
  END AS Change_Stat
FROM #customer_orders_temp
)
SELECT customer_id, Change_Stat, count(Change_Stat) AS count
FROM #runner_orders_temp RO
JOIN CTE_Change_Num CN
ON RO.order_id = CN.order_id
WHERE cancellation = ''
GROUP BY customer_id, Change_Stat
ORDER BY customer_id  ASC
```
![q7](https://github.com/innosy475/Pizza-Runner-SQL-Case-Study-SSMS-19-/assets/144645964/6b47c48b-347a-4ecc-95f8-084ac4ee03a8)

**8. How many pizzas were delivered that had both exclusions and extras?**
```
SELECT CO.order_id, count(CO.order_id) AS Exclu_Extra_Num
FROM #customer_orders_temp CO
JOIN #runner_orders_temp RO
ON CO.order_id = RO.order_id
WHERE exclusions <> '' and extras <> '' and duration <> 0
GROUP BY CO.order_id
```
![q8](https://github.com/innosy475/Pizza-Runner-SQL-Case-Study-SSMS-19-/assets/144645964/8c04d2f3-6ab0-4318-b8d1-aa0204e2844f)

**9. What was the total volume of pizzas ordered for each hour of the day?**
```
SELECT DATEPART(HOUR, order_time) AS HOTD, COUNT(order_id) AS Order_Count
FROM #customer_orders_temp
GROUP BY DATEPART(HOUR, order_time)
```
![q9](https://github.com/innosy475/Pizza-Runner-SQL-Case-Study-SSMS-19-/assets/144645964/752e6e5e-deed-4327-80c5-0211e5337789)

**10. What was the volume of orders for each day of the week?**
```
SELECT DATENAME(WEEKDAY, order_time) AS DOTW, COUNT(order_id) AS Order_Count
FROM #customer_orders_temp
GROUP BY DATENAME(WEEKDAY, order_time)
```
![q10](https://github.com/innosy475/Pizza-Runner-SQL-Case-Study-SSMS-19-/assets/144645964/ec07db92-937d-4629-ad8e-8d333b7e5a73)









