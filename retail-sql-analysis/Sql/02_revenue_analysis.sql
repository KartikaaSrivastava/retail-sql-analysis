-- 1. Monthly revenue trend
SELECT 
    substr(sale_date_clean, 1, 7) AS month,
    ROUND(SUM(Total_Sale_Amount), 2) AS monthly_revenue
FROM retail_sales
GROUP BY month
ORDER BY month;

-- 2. Revenue by primary category
SELECT 
    Category_L1,
    ROUND(SUM(Total_Sale_Amount), 2) AS revenue
FROM retail_sales
GROUP BY Category_L1_Clean
ORDER BY revenue DESC;

-- 3. Revenue by category L3
SELECT 
    Category_L3,
    ROUND(SUM(Total_Sale_Amount), 2) AS revenue
FROM retail_sales
GROUP BY Category_L3
ORDER BY revenue DESC;

-- 4. Gross profit & margin by category
SELECT 
    Category_L1_Clean,
    ROUND(SUM((Unit_Price - Unit_Cost) * Quantity_Sold), 2) AS gross_profit,
    ROUND(
        SUM((Unit_Price - Unit_Cost) * Quantity_Sold) * 1.0 /
        SUM(Unit_Price * Quantity_Sold), 2
    ) AS profit_margin
FROM retail_sales
WHERE Unit_Price IS NOT NULL
GROUP BY Category_L1_Clean
ORDER BY gross_profit DESC;

-- 5. Top 10 revenue-generating products
SELECT 
    Product_Name,
	Unit_Cost,
    ROUND(SUM(Total_Sale_Amount), 2) AS revenue
FROM retail_sales
GROUP BY Product_Name
ORDER BY revenue DESC
LIMIT 10;