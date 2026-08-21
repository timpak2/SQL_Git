/* Relational table joins, conditional demographic segmentation, 
and multi-channel order unification using set operators on AdventureWorks DW*/


/* Bike Category Product Filtering by Integer List Price 
(DimProduct & DimProductSubcategory).
Retrieve order details for high-value internet sales transactions ($>1000)
joined with territory regional data */

SELECT 
    FaInSa.SalesOrderNumber,
    FaInSa.SalesOrderLineNumber,
    FaInSa.ProductKey,
    DiSaTe.SalesTerritoryCountry
FROM dbo.FactInternetSales AS FaInSa
JOIN dbo.DimSalesTerritory AS DiSaTe
    ON FaInSa.SalesTerritoryKey = DiSaTe.SalesTerritoryKey
WHERE FaInSa.SalesAmount > 1000;



/* Bike Category Product Filtering by Integer List Price
 (DimProduct & DimProductSubcategory).
 Filter Bike products with ListPrice 
truncated to 3399 */

SELECT 
    p.ProductKey,
    p.EnglishProductName,
    p.Color,
    p.ListPrice,
    ps.EnglishProductSubCategoryName
FROM dbo.DimProduct AS p
JOIN dbo.DimProductSubcategory AS ps  
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
WHERE ps.EnglishProductSubCategoryName LIKE '%Bikes%'
  AND CAST(p.ListPrice AS INT) = 3399;



/* Promotional Sales Orders Filter (FactInternetSales & DimPromotion)
Identify sales transactions that applied 
a high promotional discount (>= 20%) */

SELECT 
    FaInSa.ProductKey,
    FaInSa.SalesOrderNumber,
    FaInSa.SalesAmount,
    Promo.DiscountPct
FROM dbo.FactInternetSales AS FaInSa
JOIN dbo.DimPromotion AS Promo  
    ON FaInSa.PromotionKey = Promo.PromotionKey
WHERE Promo.DiscountPct >= 0.20;


/* High-Income & Short-Commute Customer Demographics 
(DimCustomer & DimGeography) Extract contact details for
 high-earning customers residing within short commuting distances. */

SELECT 
    c.Phone,
    g.City,
    CONCAT_WS(' ', c.FirstName, c.MiddleName, c.LastName) AS FullName
FROM dbo.DimCustomer AS c
JOIN dbo.DimGeography AS g
    ON c.GeographyKey = g.GeographyKey
WHERE c.YearlyIncome > 150000
  AND c.CommuteDistance IN ('0-1 Miles', '1-2 Miles', '2-5 Miles');


/* Customer Demographics Segmentation (DimCustomer)
Objective: Categorize customers into income brackets and age demographic groups 
as of 2019-12-31. */

SELECT 
    CustomerKey,
    CASE 
        WHEN YearlyIncome <= 50000 THEN 'Low Income'
        WHEN YearlyIncome <= 90000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS YearlyIncomeRange,
    
    CASE 
        WHEN DATEDIFF(YEAR, BirthDate, '2019-12-31') < 40 THEN 'Young Adults'
        WHEN DATEDIFF(YEAR, BirthDate, '2019-12-31') BETWEEN 40 AND 59 THEN 'Middle-Aged Adults'
        ELSE 'Old Adults'
    END AS AgeRange
FROM dbo.DimCustomer;


/* Multi-Channel Sales Order Consolidation.
Consolidate unique sales order numbers 
across both Internet and Reseller channels 
for yellow 'Road' bikes. */

SELECT FaInSa.SalesOrderNumber 
FROM dbo.FactInternetSales AS FaInSa
JOIN dbo.DimProduct AS Product 
    ON FaInSa.ProductKey = Product.ProductKey
WHERE Product.EnglishProductName LIKE '%Road%' 
  AND Product.Color = 'Yellow'

UNION

SELECT Reseller.SalesOrderNumber 
FROM dbo.FactResellerSales AS Reseller
JOIN dbo.DimProduct AS Product 
    ON Reseller.ProductKey = Product.ProductKey
WHERE Product.EnglishProductName LIKE '%Road%' 
  AND Product.Color = 'Yellow';