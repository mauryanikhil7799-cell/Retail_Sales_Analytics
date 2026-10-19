/*
Project Retail_Sales_Analytics

Stage 1 — Data validation

Count rows in all four tables.
Find duplicate customer IDs, order IDs, product IDs, and order-detail IDs.
Check for NULL values in key columns.
Find order details whose order_id or product_id does not exist in its parent table.
Find the earliest and latest order date.
*/

---Count all row to verify all the data imported---
SELECT 'Customers'  AS Table_Name,COUNT(*) AS Table_Rows
FROM Customers
UNION ALL
SELECT 'Products',
COUNT(*)
FROM Products
UNION ALL
SELECT 'Order_Details',
count(*)
FROM Order_Details
UNION ALL
SELECT 'Orders',
COUNT(*)
FROM Orders
ORDER BY Table_Rows DESC;

---Check to verify duplicate primary key in diffrent table customer IDs, order IDs, product IDs, and order-detail IDs.---
--- Verify the diffrent table (With simple Query)---
SELECT
Customer_Name,
COUNT(*) Duplicate_Key
FROM Customers
GROUP BY Customer_Name
HAVING COUNT(*)>1;

SELECT
Order_id,
COUNT(*) AS Duplicate_Key
FROM Orders
GROUP BY Order_id
HAVING COUNT(*) >1;

SELECT
Order_detail_id,
COUNT(*) AS Duplicate_Key
FROM Order_Details
GROUP BY Order_detail_id
HAVING COUNT(*)>1;

SELECT
Product_id,
COUNT(*)Duplicate_Key
FROM Products 
GROUP BY Product_id
HAVING COUNT(*)>1

--- Verify the diffrent table (With CTE Query)---
WITH Dublicate_Key AS(
SELECT
Customer_Id,
COUNT(*) Duplicate_Key
FROM Customers
GROUP BY Customer_Id
HAVING COUNT(*) >1
)
SELECT*
FROM Dublicate_Key

---Checking the Null Values in our primary key in diffrent table---
SELECT*
FROM Customers
WHERE Customer_Id IS NULL;

SELECT*
FROM Products
WHERE Product_id IS NULL;

SELECT*
FROM Order_Details
WHERE Order_detail_id IS NULL;

SELECT*
FROM Orders
WHERE Order_id IS NULL;

---Find order details whose order_id or product_id does not exist in its parent table.---
SELECT*
FROM Order_Details AS od
LEFt JOIN Orders AS o
ON od.Order_id=o.Order_id
LEFT JOIN Products AS p
ON od.Product_id=p.Product_id
WHERE o.Order_id IS NULL OR p.Product_id IS NULL;

--- Find the earliest and latest order date to get the First and latest order date---
SELECT
MAX(Order_Date) AS  Last_Date,
MIN(Order_Date) ASFirst_Date
FROM Orders