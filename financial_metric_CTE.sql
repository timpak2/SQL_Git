/* Multi-channel revenue comparisons and financial metric summarizations
 - CTE, Group By */

/* Average Base Rate Analysis by Job Title (DimEmployee)
Calculate the average base pay rate aggregated by employee job title.*/

SELECT 
    Title,
    AVG(BaseRate) AS BASE_RATE
FROM dbo.DimEmployee
GROUP BY Title;


/* Daily Product Order Volume Summary (FactInternetSales)
Calculate total order quantities aggregated by product and order date */

SELECT 
    ProductKey,
    OrderDate,
    SUM(OrderQuantity) AS TotalOrderQuantity
FROM dbo.FactInternetSales
GROUP BY ProductKey, OrderDate;

/* Product Category Performance & Margin Analysis (FactInternetSales & DimProductCategory).
Measure financial revenue, cost, 
and profit per product category for the year 2012, filtering high-revenue categories */

SELECT 
    c.ProductCategoryKey AS CategoryKey,
    c.EnglishProductCategoryName AS EnglishCategoryName,
    SUM(f.SalesAmount) AS TotalRevenue,
    SUM(f.TotalProductCost) AS TotalCost,
    SUM(f.SalesAmount) - SUM(f.TotalProductCost) AS TotalProfit
FROM dbo.FactInternetSales AS f
JOIN dbo.DimProduct AS p 
    ON f.ProductKey = p.ProductKey
JOIN dbo.DimProductSubcategory AS ps 
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN dbo.DimProductCategory AS c 
    ON ps.ProductCategoryKey = c.ProductCategoryKey
WHERE YEAR(f.OrderDate) = 2012
GROUP BY 
    c.ProductCategoryKey,
    c.EnglishProductCategoryName
HAVING SUM(f.SalesAmount) > 5000;

/* Custom Color Grouping Revenue Aggregation (FactInternetSales & DimProduct).
Group products into custom color tiers and aggregate total sales revenue per group */

SELECT 
    CASE 
        WHEN p.Color IN ('Black', 'Silver') THEN 'Basic'
        ELSE p.Color 
    END AS Color_group,
    SUM(f.SalesAmount) AS TotalRevenue
FROM dbo.FactInternetSales AS f
JOIN dbo.DimProduct AS p 
    ON f.ProductKey = p.ProductKey
GROUP BY 
    CASE 
        WHEN p.Color IN ('Black', 'Silver') THEN 'Basic'
        ELSE p.Color 
    END;


/* Multi-Channel Monthly Revenue Reconciliation (CTE & FULL OUTER JOIN).
Compare monthly revenue streams 
between Internet and Reseller sales channels across all transaction years */

WITH InternetSales AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        MONTH(OrderDate) AS Month,
        SUM(SalesAmount) AS InternetSales
    FROM dbo.FactInternetSales
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
),
ResellerSales AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        MONTH(OrderDate) AS Month,
        SUM(SalesAmount) AS Reseller_Sales
    FROM dbo.FactResellerSales
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT 
    COALESCE(i.Year, r.Year) AS Year,
    COALESCE(i.Month, r.Month) AS Month,
    ISNULL(i.InternetSales, 0) AS InternetSales,
    ISNULL(r.Reseller_Sales, 0) AS Reseller_Sales
FROM InternetSales AS i
FULL OUTER JOIN ResellerSales AS r 
    ON i.Year = r.Year AND i.Month = r.Month
ORDER BY Year, Month;

