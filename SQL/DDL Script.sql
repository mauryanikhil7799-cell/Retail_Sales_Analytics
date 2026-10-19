/* 
Creation of Database Retail_Sales_Analytics

Purpose
		(i)-Craetion of new Database and drop the Database if already Exist Database 
		(ii)- Creating of Table for the Database drop the Table if already exists
		(iii)- Insering data in to newly created Tables
		(iv)- Validation of data
Warning 
		Do not run this query it will delete the previous dataset and create a new one  with only single user
		It will delate all data permanently

*/

--- Drop the Privious Database (If Exists) and create a newone---

USE master;

GO

--- Drop the previous Database---
IF DB_ID ('Retail_Sales_Analytics') IS NOT NULL
	BEGIN
			ALTER DATABASE Retail_Sales_Analytics
			SET SINGLE_USER
			WITH ROLLBACK IMMEDIATE;
			DROP DATABASE Retail_Sales_Analytics
	END;

GO

--- Creating a new Database Retail_Sales_Analytics---

 CREATE DATABASE Retail_Sales_Analytics;

 GO

 USE Retail_Sales_Analytics;

--- Creating Table format for the Database Retail_Sales_Analytics---

--- Drop all the table---
DROP TABLE  IF EXISTS Customers;
DROP TABLE  IF EXISTS Orders;
DROP TABLE  IF EXISTS Order_Details;
DROP TABLE  IF EXISTS Products;
GO

---Writing table Craeting Script tablewise---

---Creating Customers Table---
CREATE TABLE Customers(
	Customer_Id VARCHAR(50),
	Customer_Name VARCHAR(50),
	Age INT,
	City VARCHAR(50),
	State VARCHAR(50),
	Signup_date Date,
	Customer_Segment VARCHAR(50)
);

---Creating Order_Details Table---
CREATE TABLE Order_Details(
	Order_detail_id VARCHAR(50),
	Order_id VARCHAR(50),
	Product_id VARCHAR(50),
	Quantity INT,
	Discount_pct DECIMAL(10,2),
	Gross_sales DECIMAL(10,2),
	Sales_amount DECIMAL(10,2),
	Unit_cost DECIMAL(10,2),
	Total_cost DECIMAL(10,2),
	Profit DECIMAL(10,2)
)

---Creating Table Products---
CREATE TABLE Products(
	Product_id VARCHAR(50),
	Product_name VARCHAR(50),
	Category VARCHAR(50),
	Unit_price INT,
	Unit_cost DECIMAL(10,2)
)

---Creating Table Orders---
CREATE TABLE Orders(
	Order_id VARCHAR(50),
	Customer_id VARCHAR(50),
	Order_date DATE,
	Sales_channel VARCHAR(50),
	Payment_method VARCHAR(50),
	Order_status VARCHAR(50)
	)
GO
----Inserting Data in to the newly created table and use Delate for refreshing data----

---Inserting data in the Customers Table---
DELETE FROM Customers;
BULK INSERT Customers
FROM 'C:\Users\Asus\Desktop\SQL Projects\Date 14 Oct 2026\retail_sales_sql_tableau_dataset\Customers.csv'
WITH(
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDQUOTE='"',
	TABLOCK
);

----Inserting data in the Orders table---
DELETE FROM Orders;
BULK INSERT Orders
FROM 'C:\Users\Asus\Desktop\SQL Projects\Date 14 Oct 2026\retail_sales_sql_tableau_dataset\Orders.csv'
WITH(
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDQUOTE='"',
	TABLOCK
);

----Insering data in the Products table----
DELETE FROM Products;
BULK INSERT Products
FROM 'C:\Users\Asus\Desktop\SQL Projects\Date 14 Oct 2026\retail_sales_sql_tableau_dataset\Products.csv'
WITH(
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDQUOTE='"',
	TABLOCK
);

----Inserting data in the Order_Details----
DELETE FROM Order_Details;
BULK INSERT Order_Details
FROM 'C:\Users\Asus\Desktop\SQL Projects\Date 14 Oct 2026\retail_sales_sql_tableau_dataset\Order_Details.csv'
WITH(
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDQUOTE='"',
	TABLOCK
);

---Validation of Imported data---
SELECT 'Customers' AS Table_Name, COUNT(*) AS Table_Rows
FROM Customers
UNION ALL
SELECT'Products',
COUNT(*)
FROM Products
UNION ALL
SELECT'Orders',
COUNT(*)
FROM Orders
UNION ALL
SELECT'Order_Details',
COUNT(*)
FROM Order_Details;


