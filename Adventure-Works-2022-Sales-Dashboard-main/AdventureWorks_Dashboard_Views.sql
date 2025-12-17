

-- 1. Sales & Revenue Data Cleaning --
CREATE VIEW vw_CleanSales AS
SELECT
    soh.SalesOrderID,
    YEAR(soh.OrderDate) AS OrderYear,
    DATENAME(MONTH, soh.OrderDate) AS OrderMonth,
    p.Name AS ProductName,
    c.Name AS Category,
    s.Name AS SubCategory,
    sod.OrderQty,
    sod.UnitPrice,
    sod.LineTotal
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.SalesOrderDetail AS sod 
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product AS p 
    ON sod.ProductID = p.ProductID
LEFT JOIN Production.ProductSubcategory AS s 
    ON p.ProductSubcategoryID = s.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS c 
    ON s.ProductCategoryID = c.ProductCategoryID
WHERE p.Name IS NOT NULL
  AND sod.UnitPrice > 0;





-- 2. Customer & Demographics Cleaning --
CREATE VIEW vw_CleanCustomers AS
SELECT DISTINCT
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    e.EmailAddress,
    ph.PhoneNumber,
    a.City,
    sp.Name AS State,
    cr.Name AS Country
FROM Sales.Customer AS c
JOIN Person.Person AS p 
    ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.EmailAddress AS e 
    ON p.BusinessEntityID = e.BusinessEntityID
LEFT JOIN Person.PersonPhone AS ph 
    ON p.BusinessEntityID = ph.BusinessEntityID
LEFT JOIN Person.BusinessEntityAddress AS bea 
    ON p.BusinessEntityID = bea.BusinessEntityID
LEFT JOIN Person.Address AS a 
    ON bea.AddressID = a.AddressID
LEFT JOIN Person.StateProvince AS sp 
    ON a.StateProvinceID = sp.StateProvinceID
LEFT JOIN Person.CountryRegion AS cr 
    ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE e.EmailAddress IS NOT NULL;




-- 3. Product Cleaning & Performance Metrics --
CREATE VIEW vw_CleanProducts AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    c.Name AS Category,
    s.Name AS SubCategory,
    p.StandardCost,
    p.ListPrice,
    (p.ListPrice - p.StandardCost) AS ProfitPerItem,
    ((p.ListPrice - p.StandardCost) / NULLIF(p.ListPrice, 0)) * 100 AS ProfitMargin,
    pi.Quantity AS StockLevel
FROM Production.Product AS p
LEFT JOIN Production.ProductSubcategory AS s 
    ON p.ProductSubcategoryID = s.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS c 
    ON s.ProductCategoryID = c.ProductCategoryID
LEFT JOIN Production.ProductInventory AS pi 
    ON p.ProductID = pi.ProductID
WHERE p.ListPrice > 0 
  AND p.StandardCost > 0;




-- 4. Merge All Cleaned Views for Dashboard --
CREATE vw_FinalDashboardData AS
SELECT 
    s.OrderYear,
    s.OrderMonth,
    s.ProductName,
    p.Category,
    p.SubCategory,
    c.CustomerName,
    ISNULL(c.Country, 'Unknown') AS Country,
    s.OrderQty,
    s.UnitPrice,
    s.LineTotal,
    p.ProfitMargin,
    ISNULL(p.StockLevel, 0) AS StockLevel
FROM vw_CleanSales s
JOIN vw_CleanCustomers c ON s.SalesOrderID IN (
    SELECT SalesOrderID FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID
)
JOIN vw_CleanProducts p ON s.ProductName = p.ProductName;






-- 5. Output Verification & Export--
-- Count rows in each view --
SELECT COUNT(*) AS SalesRows FROM vw_CleanSales;
SELECT COUNT(*) AS CustomerRows FROM vw_CleanCustomers;
SELECT COUNT(*) AS ProductRows FROM vw_CleanProducts;
SELECT COUNT(*) AS FinalRows FROM vw_FinalDashboardData;

-- Preview data --
SELECT TOP 10 * FROM vw_FinalDashboardData;

SELECT * FROM vw_FinalDashboardData;