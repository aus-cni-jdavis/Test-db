-- ============================================================
-- 04_joins.sql
-- JOIN queries: INNER, LEFT, and multi-table joins.
-- ============================================================

USE TestDB;
GO

-- 1. All orders with the customer's full name (INNER JOIN)
SELECT
    o.OrderID,
    u.FirstName + ' ' + u.LastName AS CustomerName,
    o.OrderDate,
    o.Status,
    o.TotalAmount
FROM dbo.Orders o
INNER JOIN dbo.Users u ON o.UserID = u.UserID
ORDER BY o.OrderDate;

-- 2. Users who have NOT placed any orders (LEFT JOIN)
SELECT
    u.UserID,
    u.FirstName + ' ' + u.LastName AS CustomerName,
    u.Email
FROM dbo.Users u
LEFT JOIN dbo.Orders o ON u.UserID = o.UserID
WHERE o.OrderID IS NULL;

-- 3. Full order detail: customer, product, quantity, line total
SELECT
    u.FirstName + ' ' + u.LastName AS CustomerName,
    o.OrderID,
    o.OrderDate,
    p.Name                              AS ProductName,
    p.Category,
    oi.Quantity,
    oi.UnitPrice,
    oi.Quantity * oi.UnitPrice          AS LineTotal
FROM dbo.OrderItems oi
INNER JOIN dbo.Orders   o ON oi.OrderID   = o.OrderID
INNER JOIN dbo.Users    u ON o.UserID     = u.UserID
INNER JOIN dbo.Products p ON oi.ProductID = p.ProductID
ORDER BY CustomerName, o.OrderDate, p.Name;

-- 4. Products that have been ordered at least once (INNER JOIN distinct)
SELECT DISTINCT
    p.ProductID,
    p.Name,
    p.Category,
    p.Price
FROM dbo.Products p
INNER JOIN dbo.OrderItems oi ON p.ProductID = oi.ProductID
ORDER BY p.Category, p.Name;

-- 5. All orders including items, showing cancelled orders too
SELECT
    o.OrderID,
    o.Status,
    u.FirstName + ' ' + u.LastName AS CustomerName,
    p.Name                         AS ProductName,
    oi.Quantity,
    oi.UnitPrice
FROM dbo.Orders o
INNER JOIN dbo.Users      u  ON o.UserID     = u.UserID
LEFT  JOIN dbo.OrderItems oi ON o.OrderID    = oi.OrderID
LEFT  JOIN dbo.Products   p  ON oi.ProductID = p.ProductID
ORDER BY o.OrderID;
