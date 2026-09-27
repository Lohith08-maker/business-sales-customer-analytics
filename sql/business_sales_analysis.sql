-- Business Sales & Customer Analytics
-- Portfolio SQL analysis for the synthetic e-commerce dataset.

-- 1. Overall KPIs
SELECT
    SUM(Revenue) AS total_revenue,
    SUM(Profit) AS total_profit,
    COUNT(DISTINCT Order_ID) AS total_orders,
    COUNT(DISTINCT Customer_ID) AS unique_customers,
    SUM(Quantity) AS units_sold,
    SUM(Revenue) / COUNT(DISTINCT Order_ID) AS average_order_value,
    100.0 * SUM(Profit) / NULLIF(SUM(Revenue), 0) AS profit_margin_pct
FROM business_sales;

-- 2. Regional performance
SELECT Region, SUM(Revenue) AS revenue, SUM(Profit) AS profit,
       COUNT(DISTINCT Order_ID) AS orders
FROM business_sales
GROUP BY Region
ORDER BY revenue DESC;

-- 3. Category performance
SELECT Category, SUM(Revenue) AS revenue, SUM(Profit) AS profit,
       100.0 * SUM(Profit) / NULLIF(SUM(Revenue), 0) AS profit_margin_pct
FROM business_sales
GROUP BY Category
ORDER BY profit DESC;

-- 4. Product performance
SELECT Product, SUM(Revenue) AS revenue, SUM(Profit) AS profit,
       SUM(Quantity) AS units_sold
FROM business_sales
GROUP BY Product
ORDER BY revenue DESC;

-- 5. Monthly trend
SELECT EXTRACT(YEAR FROM Order_Date) AS order_year,
       EXTRACT(MONTH FROM Order_Date) AS order_month,
       SUM(Revenue) AS revenue, SUM(Profit) AS profit,
       COUNT(DISTINCT Order_ID) AS orders
FROM business_sales
GROUP BY EXTRACT(YEAR FROM Order_Date), EXTRACT(MONTH FROM Order_Date)
ORDER BY order_year, order_month;

-- 6. Customer ranking
WITH customer_sales AS (
    SELECT Customer_ID, SUM(Revenue) AS revenue, SUM(Profit) AS profit,
           COUNT(DISTINCT Order_ID) AS orders
    FROM business_sales
    GROUP BY Customer_ID
)
SELECT *,
       DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM customer_sales
ORDER BY revenue_rank;
