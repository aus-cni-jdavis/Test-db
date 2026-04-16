# Test-db

A small SQL Server (T-SQL) e-commerce database for practicing queries in SSMS.

## Structure

```
Test-db/
├── schema/
│   └── 01_create_tables.sql   -- Creates TestDB and all 4 tables
├── seed/
│   └── 02_seed_data.sql       -- Inserts sample users, products, orders
└── queries/
    ├── 03_basic_selects.sql   -- SELECT, WHERE, ORDER BY, TOP
    ├── 04_joins.sql           -- INNER JOIN, LEFT JOIN, multi-table joins
    ├── 05_aggregations.sql    -- GROUP BY, COUNT, SUM, AVG, HAVING
    └── 06_advanced.sql        -- CTEs, subqueries, window functions
```

## Tables

| Table      | Description                              |
|------------|------------------------------------------|
| Users      | Customers with name, email, created date |
| Products   | Items with category, price, stock        |
| Orders     | Customer orders with status and total    |
| OrderItems | Line items linking orders to products    |

## Usage

Run the scripts in SSMS in order:

1. `schema/01_create_tables.sql` — creates the `TestDB` database and tables
2. `seed/02_seed_data.sql` — loads sample data
3. Any file(s) in `queries/` — run individually or all at once

Each script begins with `USE TestDB;` so you can run them from any context.
The schema script is re-runnable — it drops and recreates tables cleanly.