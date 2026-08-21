/** 
1. Calculate Employee Leave Pay (DimEmployee)
2. Internet Sales Profit Margin Analysis (FactInternetSales)
3. Daily Inventory Valuation (FactProductInventory)
4. Geography Unique Location Directory (DimGeography)
5. Top 10% High-Value Products Identification (DimProduct)

**/

USE AdventureWorksDW2019
SELECT EmployeeKey  
,FirstName 
,LastName 
,BaseRate 
,VacationHours 
,SickLeaveHours 
, FirstName + '' + LastName AS FullName 
, Baserate * VacationHours AS VacationLeavePay 
, BaseRate * SickLeaveHours AS SickLeavePay 
, BaseRate * VacationHours + BaseRate * SickLeaveHours AS TotalLeavePay 
FROM dbo.DimEmployee 



SELECT 
    SalesOrderNumber,
    ProductKey,
    OrderDate,
    OrderQuantity,
    UnitPrice,
    ProductStandardCost,
    DiscountAmount,
    (OrderQuantity * UnitPrice) AS TotalRevenue,
    (ProductStandardCost + DiscountAmount) AS TotalCost,
    (OrderQuantity * UnitPrice) - (ProductStandardCost + DiscountAmount) AS Profit,
    ((OrderQuantity * UnitPrice) - (ProductStandardCost + DiscountAmount)) / (OrderQuantity * UnitPrice) * 100 AS ProfitMargin
FROM dbo.FactInternetSales;


SELECT 
    MovementDate,
    ProductKey,
    UnitsBalance,
    UnitsIn,
    UnitsOut,
    UnitCost,
    (UnitsBalance + UnitsIn - UnitsOut) AS NoProductEOD,
    (UnitsBalance + UnitsIn - UnitsOut) * UnitCost AS TotalCost
FROM dbo.FactProductInventory;



SELECT DISTINCT 
    EnglishCountryRegionName,
    City,
    StateProvinceName
FROM dbo.DimGeography
ORDER BY 
    EnglishCountryRegionName ASC,
    City DESC;




SELECT TOP 10 PERCENT 
    ProductKey,
    EnglishProductName,
    ListPrice,
    Color,
    Size,
    ProductLine,
    DealerPrice,
    StandardCost
FROM dbo.DimProduct
ORDER BY ListPrice DESC;