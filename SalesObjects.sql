
-- View: Sales.vSales
-- ----------------------------------------
-- Extracts total sales aggregated at Product, Category, Subcategory, Date and Territory.
-- Assumes AdventureWorks2022 schema with tables:
--  Production.Product, Production.ProductSubcategory, Production.ProductCategory,
--  Sales.SalesOrderHeader, Sales.SalesOrderDetail, Sales.SalesTerritory
CREATE OR ALTER VIEW Sales.vSales AS
SELECT
    pc.Name       AS Category,
    psc.Name      AS Subcategory,
    p.Name        AS Product,
    CAST(soh.OrderDate AS date) AS [Date],
    soh.TerritoryID,
    SUM(sod.LineTotal) AS TotalSales
FROM
    Sales.SalesOrderHeader AS soh
    INNER JOIN Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
    INNER JOIN Production.Product AS p ON sod.ProductID = p.ProductID
    INNER JOIN Production.ProductSubcategory AS psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    INNER JOIN Production.ProductCategory AS pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    pc.Name,
    psc.Name,
    p.Name,
    CAST(soh.OrderDate AS date),
    soh.TerritoryID;
GO


-- Table-valued Function: dbo.ufnGetSales
-- Returns aggregated sales for a specific month and year supplied as parameters
CREATE OR ALTER FUNCTION dbo.ufnGetSales (
    @Year SMALLINT,
    @Month SMALLINT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Sales.vSales
    WHERE YEAR([Date]) = @Year
      AND MONTH([Date]) = @Month
);
GO


-- Stored Procedure: dbo.uspGetSales
-- Returns aggregated sales for a specific month and year supplied as parameters
CREATE OR ALTER PROCEDURE dbo.uspGetSales
    @Year  SMALLINT,
    @Month SMALLINT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM Sales.vSales
    WHERE YEAR([Date]) = @Year
      AND MONTH([Date]) = @Month;
END
GO
