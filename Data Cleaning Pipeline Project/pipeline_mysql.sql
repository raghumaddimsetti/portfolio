DELIMITER $$

DROP PROCEDURE IF EXISTS run_data_cleaning_pipeline$$

CREATE PROCEDURE run_data_cleaning_pipeline()
BEGIN
    DECLARE v_run_id INT;
    DECLARE v_row_count INT DEFAULT 0;
    DECLARE v_valid_rows INT DEFAULT 0;
    DECLARE v_invalid_rows INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO error_log(run_id, error_message, error_stage)
        VALUES (v_run_id, 'Unexpected pipeline failure', 'pipeline');

        UPDATE processing_runs
        SET completed_at = NOW(), status = 'FAILED'
        WHERE run_id = v_run_id;
    END;

    INSERT INTO processing_runs(status) VALUES ('RUNNING');
    SET v_run_id = LAST_INSERT_ID();

    INSERT INTO error_log(run_id, error_message, error_stage)
    SELECT v_run_id,
           CONCAT('Invalid row removed: ', id),
           'validation'
    FROM raw_customer_data
    WHERE TRIM(COALESCE(customer_name, '')) = ''
       OR TRIM(COALESCE(email, '')) = ''
       OR email NOT REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';

    INSERT INTO cleaned_customer_data (id, customer_name, email, country, signup_date, revenue, status, source)
    WITH cleaned_cte AS (
        SELECT
            id,
            TRIM(customer_name) AS customer_name,
            LOWER(TRIM(email)) AS email,
            CASE WHEN TRIM(COALESCE(country, '')) = '' THEN 'Unknown' ELSE TRIM(country) END AS country,
            CASE
                WHEN TRIM(COALESCE(signup_date, '')) = '' THEN NULL
                ELSE STR_TO_DATE(TRIM(signup_date), '%Y-%m-%d')
            END AS signup_date,
            CASE WHEN revenue IS NULL THEN 0 ELSE revenue END AS revenue,
            CASE WHEN TRIM(COALESCE(status, '')) = '' THEN 'Unknown' ELSE TRIM(status) END AS status,
            CASE WHEN TRIM(COALESCE(source, '')) = '' THEN 'Manual' ELSE TRIM(source) END AS source,
            ROW_NUMBER() OVER (
                PARTITION BY LOWER(TRIM(email))
                ORDER BY id
            ) AS rn
        FROM raw_customer_data
    )
    SELECT
        id,
        customer_name,
        email,
        country,
        signup_date,
        revenue,
        status,
        source
    FROM cleaned_cte
    WHERE rn = 1
      AND TRIM(COALESCE(customer_name, '')) <> ''
      AND TRIM(COALESCE(email, '')) <> ''
      AND email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';

    SELECT COUNT(*) INTO v_row_count FROM raw_customer_data;
    SELECT COUNT(*) INTO v_valid_rows FROM cleaned_customer_data;
    SELECT COUNT(*) INTO v_invalid_rows FROM error_log WHERE run_id = v_run_id;

    UPDATE processing_runs
    SET completed_at = NOW(), row_count = v_row_count, valid_rows = v_valid_rows, invalid_rows = v_invalid_rows, status = 'COMPLETED'
    WHERE run_id = v_run_id;
END$$

DELIMITER ;

CALL run_data_cleaning_pipeline();
