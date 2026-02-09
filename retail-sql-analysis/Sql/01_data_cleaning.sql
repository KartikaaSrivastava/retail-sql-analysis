-- 1. Add cleaned date column (mixed formats handling)
ALTER TABLE retail_sales
ADD COLUMN sale_date_clean DATE;

UPDATE retail_sales
SET sale_date_clean =
    CASE
        WHEN instr(Date, '-') > 0 THEN Date
        ELSE substr(Date, 7, 4) || '-' || substr(Date, 1, 2) || '-' || substr(Date, 4, 2)
    END;

--2.Add cleaned Category L1 column
ALTER TABLE retail_sales
ADD COLUMN Category_L1_Clean TEXT;
UPDATE retail_sales
SET Category_L1_Clean =
    CASE
        -- CLOTHING
        WHEN UPPER(TRIM(Category_L1)) IN (
            'CLOTHING', 'CLOTHINGS'
        ) THEN 'Clothing'

        -- BEAUTY
        WHEN UPPER(TRIM(Category_L1)) IN (
            'BEAUTY', 'BEAUTYS'
        ) THEN 'Beauty'

        -- ACCESSORIES
        WHEN UPPER(TRIM(Category_L1)) IN (
            'ACCESSORIES', 'ACCESSORIESS'
        ) THEN 'Accessories'

        -- FOOTWEAR
        WHEN UPPER(TRIM(Category_L1)) IN (
            'FOOTWEAR', 'FOOTWEARS'
        ) THEN 'Footwear'

        -- JEWELRY
        WHEN UPPER(TRIM(Category_L1)) IN (
            'JEWELRY', 'JEWELRYS'
        ) THEN 'Jewelry'

        -- UNKNOWN OR OTHERS
        ELSE 'Unknown'
    END;

-- 2. Check missing critical fields
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS missing_price,
    SUM(CASE WHEN Discount_Applied IS NULL THEN 1 ELSE 0 END) AS missing_discount,
    SUM(CASE WHEN Store_Location IS NULL OR TRIM(Store_Location) = '' THEN 1 ELSE 0 END) AS missing_location
FROM retail_sales;

-- 3. Identify pricing calculation mismatches
SELECT 
    COUNT(*) AS mismatched_transactions
FROM retail_sales
WHERE ABS(Total_Sale_Amount - (Unit_Price * Quantity_Sold)) 
      > 0.2 * (Unit_Price * Quantity_Sold);

-- 4. Detect extreme quantity outliers
SELECT 
    Transaction_ID,
	Category_L1_Clean,
    Product_Name,
    Quantity_Sold
FROM retail_sales
WHERE Quantity_Sold >= 500
ORDER BY Category_L1_Clean;