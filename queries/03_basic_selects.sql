-- ============================================================
-- 03_basic_selects.sql
-- Basic SELECT queries: filtering, sorting, TOP N.
-- ============================================================

USE TestDB; 
GO

-- 1. All users
SELECT * FROM dbo.Users;

-- 2. All products ordered by price descending
SELECT * FROM dbo.Products
ORDER BY Price DESC;

-- 3. Products under $50
SELECT ProductID, Name, Category, Price
FROM dbo.Products
WHERE Price < 50.00
ORDER BY Price;

-- 4. Products that are in stock
SELECT ProductID, Name, Category, Price, Stock
FROM dbo.Products
WHERE Stock > 0
ORDER BY Stock DESC;

-- 5. Top 3 most expensive products
SELECT TOP 3 ProductID, Name, Price
FROM dbo.Products
ORDER BY Price DESC;

-- 6. All orders with status 'Pending'
SELECT OrderID, UserID, OrderDate, TotalAmount
FROM dbo.Orders
WHERE Status = 'Pending'
ORDER BY OrderDate;

-- 7. Orders placed in 2024 Q3 (July–September)
SELECT OrderID, UserID, OrderDate, Status, TotalAmount
FROM dbo.Orders
WHERE OrderDate >= '2024-07-01'
  AND OrderDate <  '2024-10-01'
ORDER BY OrderDate;

-- 8. Users registered after March 2024
SELECT UserID, FirstName, LastName, Email, CreatedAt
FROM dbo.Users
WHERE CreatedAt > '2024-03-31'
ORDER BY CreatedAt;
