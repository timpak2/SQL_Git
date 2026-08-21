/*
Advanced data filtering, string parsing, subquery aggregations, 
and date-based metric calculations on AdventureWorks DW
*/

/*
Filter Internet Sales Orders by Order & Ship Date (FactInternetSales)
Target: Retrieve internet sales transactions filtering 
by specific order and shipping date ranges
*/

SELECT * 
FROM dbo.FactInternetSales 
WHERE OrderDate >= '2011-01-01' 
  AND ShipDate BETWEEN '2011-01-01' AND '2011-12-31'
ORDER BY OrderDate, ShipDate;

/*
Pattern matching on ProductAlternateKey with Color filter. 
Target:Identify specific bike model stock keys using
Advanced Pattern Matching (LIKE) and list filtering
*/

SELECT 
    ProductKey,
    ProductAlternateKey,
    EnglishProductName
FROM dbo.DimProduct 
WHERE ProductAlternateKey LIKE 'BK-[^T]-[0-9][0-9]' 
  AND Color IN ('Black', 'Red', 'White') 
ORDER BY ProductAlternateKey;

/*
Subquery Product Filtering on Fact Table (FactInternetSales)
Perform a subquery lookup to filter sales facts based on dimension attributes.
*/

-- Retrieve all red products from DimProduct
SELECT * 
FROM dbo.DimProduct 
WHERE Color = 'Red' 
ORDER BY EnglishProductName;

-- Filter sales transactions for red products using Subquery
SELECT * 
FROM dbo.FactInternetSales 
WHERE ProductKey IN ( 
    SELECT ProductKey  
    FROM dbo.DimProduct  
    WHERE Color = 'Red' 
) 
ORDER BY OrderDate, SalesOrderNumber;


/*
String Length Validation & Null Checks (DimEmployee)
Validate employee contact records using string criteria and non-null constraints.
*/

-- Filter non-null MiddleName and 12-character phone numbers
SELECT 
    EmployeeKey,
    FirstName,
    LastName,
    MiddleName,
    Phone 
FROM dbo.DimEmployee 
WHERE MiddleName IS NOT NULL 
  AND LEN(Phone) = 12
ORDER BY FirstName, LastName;

/*
Employee Profile & String Transformation Metrics (DimEmployee)
Target: Transform employee profile strings and calculate hiring/current age metrics.
*/

SELECT 
    EmployeeKey,
    -- Cách 1: Toán tử '+' (Sẽ bị NULL nếu 1 trong các trường là NULL)
    FirstName + ISNULL(' ' + MiddleName, '') + ' ' + LastName AS FullName_Plus,
    -- Cách 2: Bằng hàm CONCAT_WS (Tự bỏ qua NULL và tự thêm khoảng trắng)
    CONCAT_WS(' ', FirstName, MiddleName, LastName) AS FullName_Concat,
    
    DATEDIFF(YEAR, BirthDate, HireDate) AS AgeHired,
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS AgeNow,
    SUBSTRING(LoginID, CHARINDEX('\', LoginID) + 1, LEN(LoginID)) AS UserName
FROM dbo.DimEmployee 
ORDER BY EmployeeKey;

