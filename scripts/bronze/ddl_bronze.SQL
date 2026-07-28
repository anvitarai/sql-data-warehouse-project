IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE
);

IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE);

IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT);

IF OBJECT_ID('bronze.erp_cust_az12','U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
CID NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
CID NVARCHAR(50),
CNTRY NVARCHAR(50));

IF OBJECT_ID('bronze.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
ID NVARCHAR(50),
CAT	NVARCHAR(50),
SUBCAT NVARCHAR(50),
MAINTENANCE NVARCHAR(50)
);
GO
--insert data into table
EXEC bronze.load_bronze;
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME , @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '============================================';
		PRINT 'LOADING BRONZE LAYER';
		PRINT '============================================';

		PRINT '--------------------------------------------';
		PRINT 'LOADING CRM TABLES';
		PRINT '--------------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT '>>> TRUNCATING TABLE : bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>>> INSERTING DATA INTO : crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\SQL\DWH_project\datasets\source_crm\cust_info.csv'
		WITH(	
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '-----------------------------------'
		
		SET @start_time = GETDATE();
		PRINT '>>> TRUNCATING TABLE : bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>>> INSERTING DATA INTO : bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\SQL\DWH_project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '-----------------------------------'

		SET @start_time=GETDATE();
		PRINT '>>> TRUNCATING TABLE : bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>>> INSERTING DATA INTO : bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\SQL\DWH_project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '-----------------------------------'


		PRINT '------------------------------------------';
		PRINT 'LOADING ERP TABLES';
		PRINT '------------------------------------------';

		SET @start_time=GETDATE();
		PRINT '>>> TRUNCATING TABLE : bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>>> INSERTING DATA INTO : bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\SQL\DWH_project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '-----------------------------------'

		SET @start_time=GETDATE();
		PRINT '>>> TRUNCATING TABLE : bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>>> INSERTING DATA INTO : bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\SQL\DWH_project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '-----------------------------------'

		SET @start_time=GETDATE();
		PRINT '>>> TRUNCATING TABLE : bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>>> INSERTING DATA INTO : bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\SQL\DWH_project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '-----------------------------------'

		SET @batch_end_time = GETDATE();
		PRINT 'LOADING BRONZE LAYER IS COMPLETED!'
		PRINT ' TOTAL LOAD DURATION:' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '-----------------------------------'
	END TRY
	BEGIN CATCH
		PRINT '=================================================';
		PRINT 'ERROR OCCURED WHILE LOADING BRONZE LAYER';
		PRINT 'ERROR MESSAGE:'+ ERROR_MESSAGE();
		PRINT 'ERROR CODE:' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '=================================================';
	END CATCH
END
