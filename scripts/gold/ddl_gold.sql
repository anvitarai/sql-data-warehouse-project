CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
    ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	ci.cst_marital_status AS marital_status,
	cl.CNTRY as country,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --CRM is the master data for gender
	ELSE COALESCE(ca.GEN,'n/a')
	END gender,
	ca.BDATE as birthdate,
	ci.cst_create_date as created_date
from silver.crm_cust_info as ci
LEFT JOIN silver.erp_cust_az12 ca
ON		  ci.cst_key=ca.CID
LEFT JOIN silver.erp_loc_a101 cl
ON        ci.cst_key=cl.CID
GO

CREATE VIEW gold.dim_product AS
SELECT
	ROW_NUMBER() OVER(ORDER BY pri.prd_start_dt,pri.prd_key) as product_key,
	pri.prd_id AS product_id,
	pri.prd_key AS product_number,
	pri.prd_nm AS product_name,
	pri.prd_cat_id AS category_id,
	prc.CAT AS category,
	prc.SUBCAT AS subcategory,
	prc.MAINTENANCE as maintenance,
	pri.prd_cost as product_cost,
	pri.prd_line as product_line,
	pri.prd_start_dt as start_date
FROM silver.crm_prd_info pri
LEFT JOIN silver.erp_px_cat_g1v2 prc
ON    pri.prd_cat_id=prc.ID    
WHERE prd_end_dt IS NULL   --Filter out all the historical data
GO

CREATE VIEW gold.fact_sales AS 
 SELECT sd.sls_ord_num as order_number,
 pr.product_key as product_key,
 cu.customer_key as customer_key,
 sd.sls_order_dt as order_date,
 sd.sls_ship_dt as shipping_date,
 sd.sls_due_dt as due_date,
 sd.sls_sales as sales_amount,
 sd.sls_quantity as quantity,
 sd.sls_price as price
 FROM silver.crm_sales_details as sd
LEFT JOIN gold.dim_product as pr
ON sd.sls_prd_key=pr.product_number
LEFT JOIN gold.dim_customers as cu
ON sd.sls_cust_id=cu.customer_id
