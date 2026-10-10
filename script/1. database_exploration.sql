/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/
--explore all object in the database
select * from INFORMATION_SCHEMA.tables

--explore all column in the database
select * from INFORMATION_SCHEMA.columns
where table_name = 'dim_customers'
