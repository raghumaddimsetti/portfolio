IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'data_cleaning_project')
BEGIN
    CREATE DATABASE data_cleaning_project;
END
GO

USE data_cleaning_project;
GO

DROP TABLE IF EXISTS dbo.error_log;
DROP TABLE IF EXISTS dbo.processing_runs;
DROP TABLE IF EXISTS dbo.cleaned_customer_data;
DROP TABLE IF EXISTS dbo.raw_customer_data;
GO

CREATE TABLE dbo.raw_customer_data (
    id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name NVARCHAR(100),
    email NVARCHAR(255),
    country NVARCHAR(100),
    signup_date NVARCHAR(20),
    revenue DECIMAL(10,2),
    status NVARCHAR(50),
    source NVARCHAR(50),
    created_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE dbo.cleaned_customer_data (
    id INT PRIMARY KEY,
    customer_name NVARCHAR(100),
    email NVARCHAR(255),
    country NVARCHAR(100),
    signup_date DATE,
    revenue DECIMAL(10,2),
    status NVARCHAR(50),
    source NVARCHAR(50),
    cleaned_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE dbo.error_log (
    error_id INT IDENTITY(1,1) PRIMARY KEY,
    run_id INT,
    error_message NVARCHAR(500),
    error_stage NVARCHAR(100),
    created_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE dbo.processing_runs (
    run_id INT IDENTITY(1,1) PRIMARY KEY,
    started_at DATETIME2 DEFAULT GETDATE(),
    completed_at DATETIME2 NULL,
    row_count INT,
    valid_rows INT,
    invalid_rows INT,
    status NVARCHAR(50)
);
GO
