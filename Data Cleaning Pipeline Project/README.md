# Data Cleaning Pipeline in SQL

This project demonstrates an end-to-end SQL data-cleaning pipeline for a customer dataset using CTEs, window functions, and stored procedures.

## What is included
- A raw customer data table
- A cleaned customer data table
- An error log table for rejected records
- A processing run table for audit tracking
- A MySQL pipeline script
- A SQL Server pipeline script
- Sample CSV data for import

## Files
- [schema_mysql.sql](schema_mysql.sql) - MySQL database and table setup
- [schema_sqlserver.sql](schema_sqlserver.sql) - SQL Server database and table setup
- [pipeline_mysql.sql](pipeline_mysql.sql) - MySQL cleaning pipeline stored procedure
- [pipeline_sqlserver.sql](pipeline_sqlserver.sql) - SQL Server cleaning pipeline stored procedure
- [sample_data.csv](sample_data.csv) - sample raw input data

## How to run
1. Import [sample_data.csv](sample_data.csv) into a table named `raw_customer_data`.
2. Run the appropriate schema file for your engine.
3. Run the appropriate pipeline file.
4. Query the `cleaned_customer_data` table.

## Example query
```sql
SELECT *
FROM cleaned_customer_data
ORDER BY id;
```
