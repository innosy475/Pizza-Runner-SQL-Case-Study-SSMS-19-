DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" int,
  "registration_date" date
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" datetime
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');

select *
from customer_orders

DROP TABLE IF EXISTS #customer_orders_temp;
create table #customer_orders_temp (
"order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" datetime
  )

INSERT INTO #customer_orders_temp
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');

SELECT *
FROM #customer_orders_temp

UPDATE #customer_orders_temp
SET exclusions = CASE
    WHEN exclusions IS NULL OR exclusions = 'null'
    THEN ''
    ELSE exclusions
    END,
    extras = CASE
	WHEN extras IS NULL OR extras = 'NULL' OR extras = 'null'
	THEN ''
	ELSE extras
	END

DROP TABLE IF EXISTS #runner_orders_temp;
CREATE TABLE #runner_orders_temp (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO #runner_orders_temp
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

select *
from #runner_orders_temp

UPDATE #runner_orders_temp
SET pickup_time = CASE
	WHEN pickup_time = 'null' THEN ''
	ELSE pickup_time
	END,
	distance = CASE
	WHEN distance = 'null' THEN ''
	WHEN distance LIKE '%km' THEN TRIM('%km' FROM distance)
	ELSE distance
	END,
	cancellation = CASE
	WHEN cancellation = 'null' OR cancellation = 'NULL' OR cancellation IS NULL THEN ''
	ELSE cancellation
	END,
	duration = CASE
	WHEN duration = 'null' THEN ''
	WHEN duration like '%mins' THEN TRIM ('%mins' FROM duration)
	WHEN duration like '%minutes' THEN TRIM ('%minutes' FROM duration)
	WHEN duration like '%minute' THEN TRIM ('%minute' FROM duration)
	ELSE duration
	END


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

ALTER TABLE #runner_orders_temp
ALTER COLUMN pickup_time DATETIME

ALTER TABLE #runner_orders_temp
ALTER COLUMN distance FLOAT

ALTER TABLE #runner_orders_temp
ALTER COLUMN duration INT

ALTER TABLE pizza_names
ALTER COLUMN pizza_name VARCHAR(MAX)

ALTER TABLE pizza_recipes
ALTER COLUMN toppings VARCHAR(MAX)

ALTER TABLE pizza_toppings
ALTER COLUMN topping_name VARCHAR(MAX)

select *
from runners

select *
from #runner_orders_temp

select *
from #customer_orders_temp

select *
from pizza_names

select *
from pizza_recipes

select *
from pizza_toppings

--1.How many pizzas were ordered?
SELECT COUNT(order_id) as PZ_Ordered
FROM #customer_orders_temp

--2. How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id)) as Unique_Order
FROM #customer_orders_temp

--3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(duration) as Delivered_by_each_Runner
FROM #runner_orders_temp
WHERE pickup_time <> ''
GROUP BY runner_id

--4. How many of each type of pizza was delivered?
SELECT PN.pizza_name, COUNT(CO.pizza_id) AS Amount_of_Pizza_Delivered
FROM pizza_names PN
JOIN #customer_orders_temp CO
ON CO.pizza_id = PN.pizza_id
JOIN #runner_orders_temp RO
ON CO.order_id = RO.order_id
WHERE duration <> ''
GROUP BY PN.pizza_name

--5.How many Vegetarian and Meatlovers were ordered by each customer?
SELECT CO.customer_id, PN.pizza_name, COUNT(CO.pizza_id) AS Vege_Meat_Num
FROM #customer_orders_temp CO
JOIN pizza_names PN
ON CO.pizza_id = PN.pizza_id
GROUP BY CO.customer_id, PN.pizza_name
ORDER BY CO.customer_id

--6. What was the maximum number of pizzas delivered in a single order?
SELECT TOP 1 CO.order_id, COUNT(CO.order_id) AS Max_Sgl_Order
FROM #customer_orders_temp CO
JOIN #runner_orders_temp RO ON CO.order_id = RO.order_id
WHERE distance <> 0
GROUP BY CO.order_id
ORDER BY Max_Sgl_Order DESC;

--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
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

--8. How many pizzas were delivered that had both exclusions and extras?
SELECT CO.order_id, count(CO.order_id) AS Exclu_Extra_Num
FROM #customer_orders_temp CO
JOIN #runner_orders_temp RO
ON CO.order_id = RO.order_id
WHERE exclusions <> '' and extras <> '' and duration <> 0
GROUP BY CO.order_id

--9. What was the total volume of pizzas ordered for each hour of the day?
SELECT DATEPART(HOUR, order_time) AS HOTD, COUNT(order_id) AS Order_Count
FROM #customer_orders_temp
GROUP BY DATEPART(HOUR, order_time)

--10. What was the volume of orders for each day of the week?
SELECT DATENAME(WEEKDAY, order_time) AS DOTW, COUNT(order_id) AS Order_Count
FROM #customer_orders_temp
GROUP BY DATENAME(WEEKDAY, order_time)
