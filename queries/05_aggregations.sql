-- ============================================================
-- 05_aggregations.sql
-- GROUP BY, COUNT, SUM, AVG, and HAVING queries.
-- ============================================================

USE TestDB;
GO

-- 1. Total number of orders per customer
SELECT
    u.FirstName + ' ' + u.LastName AS CustomerName,
    COUNT(o.OrderID)               AS TotalOrders
FROM dbo.Users u
LEFT JOIN dbo.Orders o ON u.UserID = o.UserID
GROUP BY u.UserID, u.FirstName, u.LastName
ORDER BY TotalOrders DESC;

-- 2. Total revenue per customer (excluding cancelled orders)
SELECT
    u.FirstName + ' ' + u.LastName AS CustomerName,
    SUM(o.TotalAmount)             AS TotalSpent
FROM dbo.Users u
INNER JOIN dbo.Orders o ON u.UserID = o.UserID
WHERE o.Status <> 'Cancelled'
GROUP BY u.UserID, u.FirstName, u.LastName
ORDER BY TotalSpent DESC;

-- 3. Average order value and order count per customer
SELECT
    u.FirstName + ' ' + u.LastName AS CustomerName,
    COUNT(o.OrderID)               AS OrderCount,
    AVG(o.TotalAmount)             AS AvgOrderValue,
    SUM(o.TotalAmount)             AS TotalSpent
FROM dbo.Users u
INNER JOIN dbo.Orders o ON u.UserID = o.UserID
GROUP BY u.UserID, u.FirstName, u.LastName
ORDER BY TotalSpent DESC;

-- 4. Top-selling products by total quantity sold
SELECT
    p.Name                  AS ProductName,
    p.Category,
    SUM(oi.Quantity)        AS TotalUnitsSold,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
FROM dbo.Products p
INNER JOIN dbo.OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.Name, p.Category
ORDER BY TotalUnitsSold DESC;

-- 5. Revenue by product category
SELECT
    p.Category,
    COUNT(DISTINCT p.ProductID)          AS ProductCount,
    SUM(oi.Quantity)                     AS UnitsSold,
    SUM(oi.Quantity * oi.UnitPrice)      AS TotalRevenue
FROM dbo.Products p
INNER JOIN dbo.OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;

-- 6. Customers who have spent more than $100 total (HAVING)
SELECT
    u.FirstName + ' ' + u.LastName AS CustomerName,
    SUM(o.TotalAmount)             AS TotalSpent
FROM dbo.Users u
INNER JOIN dbo.Orders o ON u.UserID = o.UserID
WHERE o.Status <> 'Cancelled'
GROUP BY u.UserID, u.FirstName, u.LastName
HAVING SUM(o.TotalAmount) > 100
ORDER BY TotalSpent DESC;

-- 7. Order count by status
SELECT
    Status,
    COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY Status
ORDER BY OrderCount DESC;
