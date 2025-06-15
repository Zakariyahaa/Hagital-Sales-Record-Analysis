CREATE TABLE sales_record (
    order_id TEXT,
    order_date DATE,
    ship_date DATE,
    ship_mode TEXT,
    customer_id TEXT,
    customer_name TEXT,
    segment TEXT,
    sales_rep TEXT,
    sales_team TEXT,
    sales_team_manager TEXT,
    location_id TEXT,
    city TEXT,
    state TEXT,
    postal_code TEXT,
    region TEXT,
    product_id TEXT,
    category TEXT,
    sub_category TEXT,  
    product_name TEXT,
    sales NUMERIC(12, 2),
    quantity INTEGER,
    discount NUMERIC(5, 2),
    profit NUMERIC(12, 2)
);

SELECT * FROM sales_record

-- 1. Region with Highest Sales and Profit
SELECT 
	region, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit
FROM sales_record
GROUP BY region
ORDER BY total_sales DESC, total_profit DESC
LIMIT 1;

-- 2. Sales and Profit by Segment
SELECT 
	segment, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit
FROM sales_record
GROUP BY segment;

WITH sales_prof AS (
    SELECT 
        segment, 
        SUM(sales) AS total_sales, 
        SUM(profit) AS total_profit
    FROM sales_record
    GROUP BY segment
)
SELECT 
    segment, 
	ROUND(SUM(total_profit/total_sales), 2) margins
FROM sales_prof
GROUP BY segment;

-- 3. Top Product Categories by Sales and Profit
SELECT 
	category, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit,
	ROUND(SUM(profit)/SUM(sales),3) profit_margin
FROM sales_record
GROUP BY category
ORDER BY total_sales DESC
LIMIT 5;

    -- Top Sub-Categories by Sales and Profit
SELECT 
	sub_category, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit,
	ROUND(SUM(profit)/SUM(sales),3) profit_margin
FROM sales_record
GROUP BY sub_category
ORDER BY total_sales DESC
LIMIT 5;

-- 4. Average Profit Margin Over Years
SELECT 
	EXTRACT(YEAR FROM order_date) AS year, 
	ROUND(AVG(profit::NUMERIC / NULLIF(sales, 0)),3) AS avg_profit_margin
FROM sales_record
GROUP BY year
ORDER BY year;

-- 6. Top 10 Customers by Sales
SELECT 
	customer_name, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit
FROM sales_record
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- Top 10 Customers by Profit
SELECT 
	customer_name, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit
FROM sales_record
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 10;

-- 7. Sales Rep with Highest Sales Growth
WITH yearly_sales AS (
  SELECT 
    sales_rep, 
    EXTRACT(YEAR FROM order_date) AS year, 
    SUM(sales) AS total_sales
  FROM sales_record
  GROUP BY sales_rep, year
),
sales_2014_2017 AS (
  SELECT
    sales_rep,
    MIN(CASE WHEN year = 2014 THEN total_sales END) AS sales_2014,
    MAX(CASE WHEN year = 2017 THEN total_sales END) AS sales_2017
  FROM yearly_sales
  WHERE year IN (2014, 2017)
  GROUP BY sales_rep
)
SELECT
  sales_rep,
  ROUND((sales_2017 - sales_2014) / NULLIF(sales_2014, 0), 2) AS growth_perc
FROM sales_2014_2017
WHERE sales_2014 IS NOT NULL AND sales_2017 IS NOT NULL
ORDER BY growth_perc DESC
LIMIT 1;

-- 8. Sales Team Contribution
SELECT 
	sales_team, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit
FROM sales_record
GROUP BY sales_team
ORDER BY total_profit DESC;

-- 9. Segment with Highest Average Order Value and Frequency
SELECT segment, 
	ROUND(AVG(sales),2) AS avg_order_value, 
	COUNT(DISTINCT order_id) AS order_frequency
FROM sales_record
GROUP BY segment;

-- 10. Ship Mode vs. Delivery Timelines
SELECT 
	ship_mode, 
	ROUND(AVG(ship_date - order_date),2) AS avg_delivery_days,
	COUNT(order_id) orders
FROM sales_record
GROUP BY ship_mode
ORDER BY avg_delivery_days;

-- 11. Effect of Discounts by Category
SELECT 
	category, 
	ROUND(AVG(discount),2) AS avg_discount, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit,
	ROUND(AVG(profit::NUMERIC / NULLIF(sales, 0)),3) AS avg_profit_margin
FROM sales_record
GROUP BY category;

-- 12. Correlation of Discounts with Sales/Profit
SELECT 
	ROUND(CORR(discount, sales)::NUMERIC, 2) AS discount_sales_corr, 
	ROUND(CORR(discount, profit)::NUMERIC, 2) AS discount_profit_corr
FROM sales_record;

-- 13. Most Profitable States and Cities
-- Top 10 States by Sales and Profit 
SELECT 
	state, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit,
	COUNT(order_id) orders
FROM sales_record
GROUP BY state
ORDER BY total_profit DESC, total_sales DESC
LIMIT 10;

-- Top 10 Cities by Sales and Profit 
SELECT 
	city, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit,
	COUNT(order_id) orders
FROM sales_record
GROUP BY city
ORDER BY total_profit DESC, total_sales DESC
LIMIT 10;

-- 14. Sales and Profit by Region
SELECT 
	region, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit
FROM sales_record
GROUP BY region
ORDER BY total_profit DESC;

-- 15. Category Popularity by Location
SELECT 
	state, 
	category, 
	SUM(sales) AS total_sales,
	SUM(profit) AS total_profit,
	COUNT(order_id) orders
FROM sales_record
GROUP BY state, category
ORDER BY orders DESC
LIMIT 10;

-- 16. Average Time Between Order and Ship Date
SELECT 
	ROUND(AVG(ship_date - order_date),2) AS avg_days_to_ship
FROM sales_record;

-- 17. Products with Highest Sales Volume and Profit
SELECT 
	product_name, 
	SUM(quantity) AS total_quantity, 
	SUM(sales) AS total_sales, 
	SUM(profit) AS total_profit
FROM sales_record
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- 18. Product Categories with High ROI
SELECT 
	category, 
	ROUND(SUM(profit) / NULLIF(SUM(sales), 0),3) AS roi
FROM sales_record
GROUP BY category
ORDER BY roi DESC;

-- 19. Monthly Sales and Profit Trends
SELECT 
    EXTRACT(YEAR FROM order_date) AS year, 
    EXTRACT(MONTH FROM order_date) AS month_num,
    TO_CHAR(order_date, 'Month') AS month, 
    SUM(sales) AS total_sales, 
    SUM(profit) AS total_profit
FROM sales_record
GROUP BY year, month_num, month
ORDER BY year, month_num;

--- Excerpt from the full Monthly Sales and Profit Trends
SELECT 
    EXTRACT(YEAR FROM order_date) AS year, 
    EXTRACT(MONTH FROM order_date) AS month_num,
    TO_CHAR(order_date, 'Month') AS month, 
    SUM(sales) AS total_sales, 
    SUM(profit) AS total_profit
FROM sales_record
GROUP BY year, month_num, month
HAVING 
	EXTRACT(MONTH FROM order_date) > 9 
	OR EXTRACT(MONTH FROM order_date) <= 2
ORDER BY year, month_num;

-- 20. Seasonal Sales by Category
SELECT 
    category,
    EXTRACT(MONTH FROM order_date) AS month_num,
    TO_CHAR(order_date, 'FMMonth') AS month,  
    SUM(sales) AS total_sales
FROM sales_record
GROUP BY category, month_num, month
ORDER BY category, month_num;

--Excerpt
SELECT 
    category,
    EXTRACT(MONTH FROM order_date) AS month_num,
    TO_CHAR(order_date, 'FMMonth') AS month,  
    SUM(sales) AS total_sales
FROM sales_record
WHERE category = 'Technology'
GROUP BY category, month_num, month
HAVING 
	EXTRACT(MONTH FROM order_date) > 9
	OR EXTRACT(MONTH FROM order_date) <= 3
ORDER BY category, month_num;

-- 21. Segment Buying Patterns
SELECT 
	segment, 
	EXTRACT(YEAR FROM order_date) AS year, 
	COUNT(DISTINCT customer_id) AS customer_count, 
	SUM(sales) AS total_sales,
	SUM(profit) AS total_profit
FROM sales_record
GROUP BY segment, year;

-- Regional Buying Patterns
SELECT 
	region, 
	EXTRACT(YEAR FROM order_date) AS year, 
	COUNT(DISTINCT customer_id) AS customer_count, 
	SUM(sales) AS total_sales,
	SUM(profit) AS total_profit
FROM sales_record
GROUP BY region, year;

-- 22. Top 20% Customers Sales Contribution
WITH customer_sales AS (
  SELECT 
  	customer_id, 
	SUM(sales) AS total_sales
  FROM sales_record
  GROUP BY customer_id
),
ranked AS (
  SELECT *, 
  	NTILE(5) OVER (ORDER BY total_sales DESC) AS quintile
  FROM customer_sales
)
SELECT 
	ROUND(100.0 * SUM(total_sales) / (SELECT SUM(sales) FROM sales_record), 2) AS top_20_pct_contribution
FROM ranked
WHERE quintile = 1;

--  Top 20% Product Sales Contribution
WITH customer_sales AS (
  SELECT 
  	product_name, 
	SUM(sales) AS total_sales
  FROM sales_record
  GROUP BY product_name
  ORDER BY total_sales DESC
),
ranked AS (
  SELECT *, 
  	NTILE(5) OVER (ORDER BY total_sales DESC) AS quintile
  FROM customer_sales
)
SELECT 
	ROUND(100.0 * SUM(total_sales) / (SELECT SUM(sales) FROM sales_record), 2) AS top_20_pct_contribution
FROM ranked
WHERE quintile = 1;

-- 23. Region/Segment Sales and Profit Variance Year over Year
-- Segment Sales and Profit Variance Year over Year
WITH yearly_sales AS (
    SELECT
        segment,
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(sales) AS total_sales,
		SUM(profit) AS total_profit
    FROM sales_record
    GROUP BY segment, year
)
SELECT
    segment,
    ROUND(VARIANCE(total_sales),2) AS sales_variance,
    ROUND(VARIANCE(total_profit),2) AS profit_variance
FROM yearly_sales
GROUP BY segment
ORDER BY sales_variance DESC
LIMIT 1;

-- Region Sales & Profit Variance Year over Year 
WITH yearly_sales AS (
    SELECT
        region,
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(sales) AS total_sales,
		SUM(profit) AS total_profit
    FROM sales_record
    GROUP BY region, year
)
SELECT
    region,
    ROUND(VARIANCE(total_sales),2) AS sales_variance,
    ROUND(VARIANCE(total_profit),2) AS profit_variance
FROM yearly_sales
GROUP BY region
ORDER BY sales_variance DESC
LIMIT 1;

-- 24. Sales Rep Impact on Regional Sales (Top 3 by region)
SELECT 
	region, 
	sales_rep, 
	total_sales, 
	total_profit
FROM (
    SELECT 
        region, 
        sales_rep, 
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rn
    FROM sales_record
    GROUP BY region, sales_rep
) ranked
WHERE rn <= 3
ORDER BY region, total_sales DESC;

-- 25. Profitability Across Segments and Locations
SELECT 
	segment, 
	region, 
	SUM(profit) AS total_profit, 
	ROUND(AVG(100 * profit / NULLIF(sales, 0)),2) AS avg_profit_margin
FROM sales_record
GROUP BY segment, region
ORDER BY segment, total_profit DESC;

----Capstone Project Questions Ends here------

-- Category & Sub-Category Performance
-- Category Performance
SELECT 
	category, 
	SUM(sales) AS total_sales,
	SUM(profit) AS total_profit,
	COUNT(DISTINCT order_id) orders
FROM sales_record
GROUP BY category
ORDER BY total_sales DESC;

-- Top 5 Sub-Category Performance

SELECT 
	sub_category, 
	SUM(sales) AS total_sales,
	SUM(profit) AS total_profit,
	COUNT(order_id) orders,
	ROUND(SUM(100 * profit)/SUM(sales),3) profit_margin
FROM sales_record
GROUP BY sub_category
ORDER BY total_sales DESC
LIMIT 5;

-- Top 10 Customers Performance

SELECT 
	customer_name, 
	SUM(sales) AS total_sales,
	SUM(profit) AS total_profit,
	SUM(quantity) total_quantity
FROM sales_record
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- Top 5 Order Destinations

SELECT 
	state, 
	COUNT(DISTINCT order_id) unique_orders
FROM sales_record
GROUP BY state
ORDER BY unique_orders DESC
LIMIT 10;

-- Top Sub-Categories by Profit margin

--	Top 3 High‐Margin Sub‐Categories
SELECT 
	sub_category, 
	ROUND(SUM(100 * profit)/SUM(sales),3) profit_margin
FROM sales_record
GROUP BY sub_category
ORDER BY profit_margin DESC
LIMIT 3;

-- Top 3 Low‐Margin Sub‐Categories
SELECT 
	sub_category, 
	ROUND(SUM(100 * profit)/SUM(sales),3) profit_margin
FROM sales_record
GROUP BY sub_category
ORDER BY profit_margin ASC
LIMIT 3;


