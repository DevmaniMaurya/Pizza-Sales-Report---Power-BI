USE pizza_db;
SELECT * FROM pizza_sales;

DESC pizza_sales;
# TO CHANGE order_time COLUMN FROM TEXT TO TIME
ALTER TABLE pizza_sales MODIFY COLUMN order_time TIME;

# TO CHANGE VALUES IN order_date COLUMN FROM YYYY-MM-DD FORMAT TO DD-MM-YYYY 
UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');

# THEN CHANGE TO COLUMN TYPE TO DATE FORMATE
ALTER TABLE pizza_sales MODIFY COLUMN order_date DATE;

SELECT ROUND(SUM(total_price),2) AS 'total_revenue' FROM pizza_sales;

SELECT ROUND(SUM(total_price)/COUNT(DISTINCT(order_id)),2) AS 'average_order_value' FROM pizza_sales;

SELECT SUM(quantity) AS 'total_pizza_sold' FROM pizza_sales;

SELECT COUNT(DISTINCT(order_id)) AS 'total_orders' FROM pizza_sales; 

SELECT SUM(quantity)/COUNT(DISTINCT(order_id)) AS 'total_pizza_per_order' FROM pizza_sales;

#HOURLY TREND FOR TOTAL PIZZA SOLD
SELECT HOUR(order_time) AS 'order_hour', 
SUM(quantity) AS 'total_pizza_sold'
FROM pizza_sales
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);

# WEEKLY TREND FOR TOTAL ORDERS
UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y');

SELECT WEEK(order_date),YEAR(order_date),COUNT(DISTINCT(order_id))
from pizza_sales
GROUP BY WEEK(order_date),YEAR(order_date)
ORDER BY WEEK(order_date),YEAR(order_date);

# PERCENTAGE OF SALES BY PIZZA CATEGORY
SELECT pizza_category,SUM(total_price),
ROUND((SUM(total_price)/(SELECT SUM(total_price) FROM pizza_sales))*100,2) AS 'PCT' 
FROM pizza_sales
GROUP BY pizza_category;

SELECT pizza_category,SUM(total_price),
ROUND((SUM(total_price)/(SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(order_date)=1))*100,2) AS 'PCT' 
FROM pizza_sales
WHERE MONTH(order_date)=1
GROUP BY pizza_category;

# PERCENTAGE OF SALES BY PIZZA size
SELECT pizza_size,ROUND(SUM(total_price),2),
ROUND((SUM(total_price)/(SELECT SUM(total_price) FROM pizza_sales))*100,2) AS 'PCT' 
FROM pizza_sales
GROUP BY pizza_size
ORDER BY PCT DESC;

#TOP 5 BEST SELLERS BY REVENUE, TOTAL QUANTITY AND TOTAL ORDERS
SELECT pizza_name_id,
SUM(total_price) AS revenue, 
SUM(quantity) AS total_quantity,
COUNT(DISTINCT order_id) AS total_order
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY revenue DESC LIMIT 5;

#TOP 5 BEST WORST BY REVENUE, TOTAL QUANTITY AND TOTAL ORDERS
SELECT pizza_name_id,
SUM(total_price) AS revenue, 
SUM(quantity) AS total_quantity,
COUNT(DISTINCT order_id) AS total_order
FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY revenue LIMIT 5;



