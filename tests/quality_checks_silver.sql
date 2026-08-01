/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

--Check for Nulls and Duplicates in Primary key
--Expectation: No result

SELECT cst_id,
COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

--Check if there any unwanted spaces
--Expectation: No result

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname ! = TRIM(cst_firstname)

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname ! = TRIM(cst_lastname)

SELECT cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status ! = TRIM(cst_marital_status)

SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr ! = TRIM(cst_gndr)

--Data standardization and consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

-- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================

--Check for Nulls and Duplicates in Primary key
--Expectation: No result

SELECT prd_id,
COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--Check if there any unwanted spaces
--Expectation: No result

SELECT prd_key
FROM silver.crm_prd_info
WHERE prd_key ! = TRIM(prd_key)

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm ! = TRIM(prd_nm)

SELECT prd_line
FROM silver.crm_prd_info
WHERE prd_line ! = TRIM(prd_line)

--Data standardization and consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

--Check for nulls or negative numbers
--Expectation: no result
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--Check for invalid date orders
SELECT prd_key,prd_end_dt,prd_start_dt
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================

--Check for invalid dates
SELECT  NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) != 8 
OR sls_order_dt > 20500101 
OR sls_order_dt < 19000101

SELECT  NULLIF(sls_ship_dt,0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 
OR LEN(sls_ship_dt) != 8 
OR sls_ship_dt > 20500101 
OR sls_ship_dt < 19000101

SELECT  NULLIF(sls_due_dt,0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
OR LEN(sls_due_dt) != 8 
OR sls_due_dt > 20500101 
OR sls_due_dt < 19000101

--Check for invalid date orders
SELECT * FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
OR sls_order_dt > sls_due_dt

--Data check consistency between sales,quantity and price
-->Sales=quantity * Price
-->values must not be null, negative or zero


SELECT *
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales,sls_quantity,sls_price

-- ====================================================================
-- Checking 'silver.erp_cust_az12'
-- ====================================================================

--Identify out of range dates
SELECT BDATE
FROM silver.erp_cust_az12
WHERE BDATE < '1926-01-01' OR BDATE > GETDATE()

--Data Standardization and Consistency
SELECT DISTINCT GEN
FROM silver.erp_cust_az12

-- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================

--Data standardization and consistency
SELECT DISTINCT CNTRY
FROM silver.erp_loc_a101

-- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE CAT != TRIM(CAT) 
   OR SUBCAT != TRIM(SUBCAT) 
   OR MAINTENANCE != TRIM(MAINTENANCE);

-- Data Standardization & Consistency
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
