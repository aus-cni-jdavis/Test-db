-- ============================================================
-- 06_advanced.sql
-- CTEs, subqueries, window functions, and running totals.
-- ============================================================

USE TestDB;
GO

-- 1. CTE: Rank customers by total spend
WITH CustomerSpend AS (
    SELECT
        u.UserID,
        u.FirstName + ' ' + u.LastName AS CustomerName,
        SUM(o.TotalAmount)             AS TotalSpent
    FROM dbo.Users u
    INNER JOIN dbo.Orders o ON u.UserID = o.UserID
    WHERE o.Status <> 'Cancelled'
    GROUP BY u.UserID, u.FirstName, u.LastName
)
SELECT
    RANK() OVER (ORDER BY TotalSpent DESC) AS SpendRank,
    CustomerName,
    TotalSpent
FROM CustomerSpend;

-- 2. Subquery: Products that have never been ordered
SELECT ProductID, Name, Category, Price, Stock
FROM dbo.Products
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID FROM dbo.OrderItems
);

-- 3. Window function: Number each order per customer chronologically
SELECT
    u.FirstName + ' ' + u.LastName                                  AS CustomerName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    ROW_NUMBER() OVER (PARTITION BY o.UserID ORDER BY o.OrderDate)  AS OrderSequence
FROM dbo.Orders o
INNER JOIN dbo.Users u ON o.UserID = u.UserID
ORDER BY CustomerName, OrderSequence;

-- 4. Running total of revenue over time (all non-cancelled orders)
SELECT
    o.OrderDate,
    o.OrderID,
    u.FirstName + ' ' + u.LastName                                          AS CustomerName,
    o.TotalAmount,
    SUM(o.TotalAmount) OVER (ORDER BY o.OrderDate, o.OrderID
                              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM dbo.Orders o
INNER JOIN dbo.Users u ON o.UserID = u.UserID
WHERE o.Status <> 'Cancelled'
ORDER BY o.OrderDate, o.OrderID;

-- 5. CTE + window function: Each product's share of its category revenue
WITH ProductRevenue AS (
    SELECT
        p.ProductID,
        p.Name          AS ProductName,
        p.Category,
        SUM(oi.Quantity * oi.UnitPrice) AS ProductRevenue
    FROM dbo.Products p
    INNER JOIN dbo.OrderItems oi ON p.ProductID = oi.ProductID
    GROUP BY p.ProductID, p.Name, p.Category
)
SELECT
    Category,
    ProductName,
    ProductRevenue,
    SUM(ProductRevenue) OVER (PARTITION BY Category)            AS CategoryRevenue,
    CAST(
        100.0 * ProductRevenue
        / SUM(ProductRevenue) OVER (PARTITION BY Category)
    AS DECIMAL(5,2))                                            AS PctOfCategory
FROM ProductRevenue
ORDER BY Category, ProductRevenue DESC;

-- 6. Subquery: Orders where TotalAmount exceeds the overall average
SELECT
    OrderID,
    UserID,
    OrderDate,
    TotalAmount
FROM dbo.Orders
WHERE TotalAmount > (
    SELECT AVG(TotalAmount) FROM dbo.Orders WHERE Status <> 'Cancelled'
)
ORDER BY TotalAmount DESC;
