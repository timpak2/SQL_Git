/* Multi-table joins, hierarchy self-joins, anti-join patterns for unsold inventory, 
and financial scenario filtering on AdventureWorks DW */

/* Promotional Product Sales Query (FactInternetSales, DimProduct & DimPromotion).
Retrieve order details 
and product info for internet sales with promotional discounts >= 20% */

SELECT 
    PRD.ProductKey,
    PRD.EnglishProductName,
    FIS.SalesOrderNumber
FROM dbo.FactInternetSales AS FIS
JOIN dbo.DimProduct AS PRD 
    ON FIS.ProductKey = PRD.ProductKey
JOIN dbo.DimPromotion AS PRO 
    ON FIS.PromotionKey = PRO.PromotionKey
WHERE PRO.DiscountPct >= 0.20;


/* Product Category Hierarchy Filter 
(DimProduct, DimProductSubcategory & DimProductCategory). 
Query products belonging specifically to the 'Clothing' main category */

SELECT 
    PRD.ProductKey,
    PRD.EnglishProductName,
    PS.EnglishProductSubCategoryName,
    PCA.EnglishProductCategoryName
FROM dbo.DimProduct AS PRD
JOIN dbo.DimProductSubcategory AS PS 
    ON PRD.ProductSubcategoryKey = PS.ProductSubcategoryKey
JOIN dbo.DimProductCategory AS PCA 
    ON PS.ProductCategoryKey = PCA.ProductCategoryKey
WHERE PCA.EnglishProductCategoryName = 'Clothing';

/*Identify products in the catalog that have never been sold 
in internet transactions using two approach methods */

-- Subquery  
SELECT 
    PRD.ProductKey,
    PRD.EnglishProductName,
    PRD.ListPrice
FROM dbo.DimProduct AS PRD
WHERE PRD.ProductKey NOT IN (
    SELECT ProductKey 
    FROM dbo.FactInternetSales 
    WHERE ProductKey IS NOT NULL
);

-- Outer Join

SELECT 
    PRD.ProductKey,
    PRD.EnglishProductName,
    PRD.ListPrice
FROM dbo.DimProduct AS PRD
LEFT JOIN dbo.FactInternetSales AS FIS 
    ON PRD.ProductKey = FIS.ProductKey
WHERE FIS.ProductKey IS NULL;

/* 
Mapping department groups to their parent departments via a self-join */

SELECT 
    DGONE.DepartmentGroupKey,
    DGONE.DepartmentGroupName,
    DGONE.ParentDepartmentGroupKey,
    DGTWO.DepartmentGroupName AS ParentDepartmentGroupName
FROM dbo.DimDepartmentGroup AS DGONE
LEFT JOIN dbo.DimDepartmentGroup AS DGTWO 
    ON DGONE.ParentDepartmentGroupKey = DGTWO.DepartmentGroupKey;


/* Financial Actuals Organizational Mapping 
(FactFinance, DimOrganization & DimScenario)
Analyzing financial actual amounts mapped across parent-child organizational structures*/

SELECT 
    ORG.OrganizationKey,
    ORG.OrganizationName,
    ORG.ParentOrganizationKey,
    ORA.OrganizationName AS ParentOrganizationName,
    FIN.Amount,
    SRO.ScenarioName
FROM dbo.FactFinance AS FIN
JOIN dbo.DimOrganization AS ORG 
    ON FIN.OrganizationKey = ORG.OrganizationKey
LEFT JOIN dbo.DimOrganization AS ORA 
    ON ORG.ParentOrganizationKey = ORA.OrganizationKey
JOIN dbo.DimScenario AS SRO 
    ON FIN.ScenarioKey = SRO.ScenarioKey
WHERE SRO.ScenarioName = 'Actual';