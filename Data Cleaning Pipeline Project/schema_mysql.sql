CREATE DATABASE IF NOT EXISTS data_cleaning_project;
USE data_cleaning_project;

DROP TABLE IF EXISTS error_log;
DROP TABLE IF EXISTS processing_runs;
DROP TABLE IF EXISTS cleaned_customer_data;
DROP TABLE IF EXISTS raw_customer_data;

CREATE TABLE raw_customer_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(255),
    country VARCHAR(100),
    signup_date VARCHAR(20),
    revenue DECIMAL(10,2),
    status VARCHAR(50),
    source VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cleaned_customer_data (
    id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(255),
    country VARCHAR(100),
    signup_date DATE,
    revenue DECIMAL(10,2),
    status VARCHAR(50),
    source VARCHAR(50),
    cleaned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE error_log (
    error_id INT AUTO_INCREMENT PRIMARY KEY,
    run_id INT,
    error_message VARCHAR(500),
    error_stage VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE processing_runs (
    run_id INT AUTO_INCREMENT PRIMARY KEY,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    row_count INT,
    valid_rows INT,
    invalid_rows INT,
    status VARCHAR(50)
);
