/* Examining customer repeat-order behavior */

/*Total Order Volume per Customer Aggregation (FactInternetSales).
Calculate the cumulative product order quantity purchased by each customer */

SELECT 
    CustomerKey,
    SUM(OrderQuantity) AS TOTAL_ORDER_QUANTITY
FROM dbo.FactInternetSales
GROUP BY CustomerKey
ORDER BY TOTAL_ORDER_QUANTITY DESC;

/*Total Units Sold by Product Name (FactInternetSales & DimProduct).
Measure total units sold per product name across all internet sales transactions */

SELECT 
    p.EnglishProductName,
    SUM(f.OrderQuantity) AS TotalOrderQuantity
FROM dbo.FactInternetSales AS f
JOIN dbo.DimProduct AS p 
    ON f.ProductKey = p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY TotalOrderQuantity DESC;

/* Repeat Customer Order Frequency Metrics (FactInternetSales & DimCustomer).
Identify active customers in 2014 who placed 2 or more distinct sales orders. */

SELECT 
    c.CustomerKey,
    CONCAT_WS(' ', c.FirstName, c.MiddleName, c.LastName) AS FullName,
    COUNT(DISTINCT f.SalesOrderNumber) AS OrderCount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimCustomer AS c 
    ON f.CustomerKey = c.CustomerKey
WHERE YEAR(f.OrderDate) = 2014
GROUP BY 
    c.CustomerKey,
    c.FirstName,
    c.MiddleName,
    c.LastName
HAVING COUNT(DISTINCT f.SalesOrderNumber) >= 2;

/*Top 2 Revenue-Generating Product Categories (FactInternetSales & Category Hierarchy). 
Identify the top 2 product categories generating the highest sales revenue in 2014 */


SELECT TOP 2 
    c.EnglishProductCategoryName,
    SUM(f.SalesAmount) AS TotalAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimProduct AS p 
    ON f.ProductKey = p.ProductKey
JOIN dbo.DimProductSubcategory AS ps 
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN dbo.DimProductCategory AS c 
    ON ps.ProductCategoryKey = c.ProductCategoryKey
WHERE YEAR(f.OrderDate) = 2014
GROUP BY c.EnglishProductCategoryName
ORDER BY TotalAmount DESC;

/* Consolidated Multi-Channel Sales Order Valuation (UNION ALL & Subquery).
Aggregate total revenue per order number combining both Internet and Reseller channels */

SELECT 
    SalesOrderNumber,
    SUM(SalesAmount) AS TOTAL_SALES_AMOUNT
FROM (
    SELECT SalesOrderNumber, SalesAmount 
    FROM dbo.FactInternetSales
    
    UNION ALL
    
    SELECT SalesOrderNumber, SalesAmount 
    FROM dbo.FactResellerSales
) AS CombinedSales
GROUP BY SalesOrderNumber;


/* Departmental & Hierarchy Financial Spending Aggregation (FactFinance & DimDepartmentGroup).
Aggregate total financial expenditure amounts mapped across department groups and parent groups */

SELECT 
    d1.DepartmentGroupName,
    d2.DepartmentGroupName AS ParentDepartmentGroupName,
    SUM(fin.Amount) AS TotalAmount
FROM dbo.FactFinance AS fin
JOIN dbo.DimDepartmentGroup AS d1 
    ON fin.DepartmentGroupKey = d1.DepartmentGroupKey
LEFT JOIN dbo.DimDepartmentGroup AS d2 
    ON d1.ParentDepartmentGroupKey = d2.DepartmentGroupKey
GROUP BY 
    d1.DepartmentGroupName,
    d2.DepartmentGroupName;
