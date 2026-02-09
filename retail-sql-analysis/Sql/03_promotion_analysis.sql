-- 1. Discount vs non-discount comparison
SELECT 
    CASE 
        WHEN Discount_Applied > 0 THEN 'Discounted'
        ELSE 'No Discount'
    END AS discount_flag,
    ROUND(AVG(Quantity_Sold), 2) AS avg_units,
    ROUND(AVG(Total_Sale_Amount), 2) AS avg_order_value
FROM retail_sales
GROUP BY discount_flag;

-- 2. Promotion-wise revenue & discount cost
SELECT 
    Promotion_ID,
    COUNT(*) AS transactions,
    ROUND(SUM(Discount_Applied), 2) AS total_discount,
    ROUND(SUM(Total_Sale_Amount), 2) AS revenue_generated
FROM retail_sales
WHERE Promotion_ID IS NOT NULL
GROUP BY Promotion_ID
ORDER BY revenue_generated DESC;

-- 3. Seasonal discount trend
SELECT 
    substr(sale_date_clean, 1, 7) AS month,
    ROUND(SUM(Discount_Applied), 2) AS total_discount
FROM retail_sales
GROUP BY month
ORDER BY month;