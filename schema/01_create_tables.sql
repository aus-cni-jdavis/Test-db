-- ============================================================
-- 01_create_tables.sql
-- Creates the TestDB database and e-commerce schema.
-- Re-runnable: drops tables if they already exist.
-- Run this first before seed or query scripts.
-- ============================================================

-- Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'TestDB')
BEGIN
    CREATE DATABASE TestDB;
END
GO

USE TestDB;
GO

-- --------------------------------------------------------
-- Drop tables in reverse FK dependency order
-- --------------------------------------------------------
IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID('dbo.Orders',     'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products',   'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Users',      'U') IS NOT NULL DROP TABLE dbo.Users;
GO

-- --------------------------------------------------------
-- Users
-- --------------------------------------------------------
CREATE TABLE dbo.Users (
    UserID      INT            IDENTITY(1,1) PRIMARY KEY,
    FirstName   NVARCHAR(50)   NOT NULL,
    LastName    NVARCHAR(50)   NOT NULL,
    Email       NVARCHAR(100)  NOT NULL UNIQUE,
    CreatedAt   DATETIME2      NOT NULL DEFAULT GETDATE()
);
GO

-- --------------------------------------------------------
-- Products
-- --------------------------------------------------------
CREATE TABLE dbo.Products (
    ProductID   INT             IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(100)   NOT NULL,
    Category    NVARCHAR(50)    NOT NULL,
    Price       DECIMAL(10, 2)  NOT NULL CHECK (Price >= 0),
    Stock       INT             NOT NULL DEFAULT 0 CHECK (Stock >= 0)
);
GO

-- --------------------------------------------------------
-- Orders
-- --------------------------------------------------------
CREATE TABLE dbo.Orders (
    OrderID      INT            IDENTITY(1,1) PRIMARY KEY,
    UserID       INT            NOT NULL,
    OrderDate    DATETIME2      NOT NULL DEFAULT GETDATE(),
    Status       NVARCHAR(20)   NOT NULL DEFAULT 'Pending'
                                CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')),
    TotalAmount  DECIMAL(10, 2) NOT NULL DEFAULT 0,
    CONSTRAINT FK_Orders_Users FOREIGN KEY (UserID)
        REFERENCES dbo.Users (UserID)
        ON DELETE CASCADE
);
GO

-- --------------------------------------------------------
-- OrderItems
-- --------------------------------------------------------
CREATE TABLE dbo.OrderItems (
    OrderItemID  INT            IDENTITY(1,1) PRIMARY KEY,
    OrderID      INT            NOT NULL,
    ProductID    INT            NOT NULL,
    Quantity     INT            NOT NULL CHECK (Quantity > 0),
    UnitPrice    DECIMAL(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    CONSTRAINT FK_OrderItems_Orders   FOREIGN KEY (OrderID)
        REFERENCES dbo.Orders (OrderID)
        ON DELETE CASCADE,
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductID)
        REFERENCES dbo.Products (ProductID)
);
GO

PRINT 'Schema created successfully in TestDB.';
GO
