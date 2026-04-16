# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Test-db (SQL Server Project)

Scripts must be executed sequentially in SQL Server Management Studio (SSMS):

1. `schema/01_create_tables.sql` — Creates the `TestDB` database and all tables
2. `seed/02_seed_data.sql` — Populates tables with sample data
3. `queries/03_basic_selects.sql` through `queries/06_advanced.sql` — Practice queries (run individually)

The schema script is re-runnable — it drops and recreates the database on each run.

### Schema

Four tables with referential integrity: `Users`, `Products`, `Orders` (FK → Users), `OrderItems` (FK → Orders + Products, CASCADE delete).
