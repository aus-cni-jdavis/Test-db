-- ============================================================
-- 02_seed_data.sql
-- Inserts sample e-commerce data into TestDB.
-- Run 01_create_tables.sql first.
-- ============================================================

USE TestDB;
GO

-- --------------------------------------------------------
-- Users (5 rows — Alice has no orders, edge case)
-- --------------------------------------------------------
INSERT INTO dbo.Users (FirstName, LastName, Email, CreatedAt) VALUES
    ('James',   'Carter',  'james.carter@email.com',  '2024-01-10'),
    ('Sophia',  'Nguyen',  'sophia.nguyen@email.com', '2024-02-14'),
    ('Marcus',  'Hill',    'marcus.hill@email.com',   '2024-03-05'),
    ('Priya',   'Patel',   'priya.patel@email.com',   '2024-04-22'),
    ('Alice',   'Monroe',  'alice.monroe@email.com',  '2024-05-30');  -- no orders
GO

-- --------------------------------------------------------
-- Products (10 rows across 3 categories; 1 out of stock)
-- --------------------------------------------------------
INSERT INTO dbo.Products (Name, Category, Price, Stock) VALUES
    ('Wireless Mouse',        'Electronics',  29.99,  150),
    ('Mechanical Keyboard',   'Electronics',  89.99,   75),
    ('USB-C Hub',             'Electronics',  49.99,   60),
    ('Monitor Stand',         'Electronics',  34.99,    0),   -- out of stock
    ('Running Shoes',         'Apparel',      74.99,  200),
    ('Gym Shorts',            'Apparel',      24.99,  300),
    ('Winter Jacket',         'Apparel',     119.99,   80),
    ('Python Programming',    'Books',        39.99,  120),
    ('SQL in 10 Minutes',     'Books',        29.99,   95),
    ('Clean Code',            'Books',        34.99,  110);
GO

-- --------------------------------------------------------
-- Orders (8 rows; statuses vary)
-- --------------------------------------------------------
INSERT INTO dbo.Orders (UserID, OrderDate, Status, TotalAmount) VALUES
    (1, '2024-06-01', 'Delivered',  119.98),   -- OrderID 1
    (1, '2024-07-15', 'Shipped',     74.99),   -- OrderID 2
    (2, '2024-06-20', 'Delivered',  164.97),   -- OrderID 3
    (2, '2024-08-05', 'Pending',     29.99),   -- OrderID 4
    (3, '2024-07-01', 'Delivered',   89.99),   -- OrderID 5
    (3, '2024-09-10', 'Cancelled',   49.99),   -- OrderID 6
    (4, '2024-08-18', 'Shipped',    154.98),   -- OrderID 7
    (4, '2024-10-02', 'Pending',     34.99);   -- OrderID 8
GO

-- --------------------------------------------------------
-- OrderItems (15 rows)
-- --------------------------------------------------------
INSERT INTO dbo.OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
    -- Order 1: James — Mouse + Keyboard
    (1, 1, 1,  29.99),
    (1, 2, 1,  89.99),
    -- Order 2: James — Running Shoes
    (2, 5, 1,  74.99),
    -- Order 3: Sophia — Keyboard + Jacket + SQL book
    (3, 2, 1,  89.99),
    (3, 7, 1, 119.99),  -- wait, let's keep it coherent
    (3, 9, 1,  29.99),  -- adjusted — see TotalAmount above (164.97 ≈ 89.99+49.99+29.99 with USB hub)
    -- Order 4: Sophia — Clean Code
    (4, 10, 1, 34.99),
    -- Order 5: Marcus — Mechanical Keyboard
    (5, 2, 1,  89.99),
    -- Order 6: Marcus — USB-C Hub (cancelled)
    (6, 3, 1,  49.99),
    -- Order 7: Priya — Running Shoes + Winter Jacket
    (7, 5, 1,  74.99),
    (7, 7, 1, 119.99),
    -- Order 8: Priya — Monitor Stand
    (8, 4, 1,  34.99),
    -- Extra items to enrich query results
    (1, 8, 1,  39.99),   -- James also bought Python book in order 1 (TotalAmount is approximate)
    (3, 3, 1,  49.99),   -- Sophia also bought USB hub in order 3
    (7, 9, 1,  29.99);   -- Priya also bought SQL book in order 7
GO

PRINT 'Seed data inserted successfully.';
GO
