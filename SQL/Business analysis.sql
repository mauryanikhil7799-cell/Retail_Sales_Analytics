/*
Project Retail_Sales_Analytics

Stage 5 — Business analysis

Calculate monthly sales and month-over-month growth.
Rank the top 5 products in each category by sales.
Find each customer's first and most recent order date.
Identify repeat customers and their number of orders.
Calculate discount rate and compare profit margin by category.

*/

----Calculate monthly sales and month-over-month growth.-----
WITH Monthly_Sales AS(
	SELECT
	DATEFROMPARTS(YEAR(o.Order_date),MONTH(o.Order_date),1) AS Sales_Month,
	SUM(od.Gross_sales) AS Total_Sales
	FROM Orders AS o
	JOIN Order_Details AS od
	ON od.Order_id=o.Order_id
	GROUP BY DATEFROMPARTS(YEAR(o.Order_date),MONTH(o.Order_date),1)
),
Previous_Month AS
(
	SELECT
		Sales_Month,
		Total_Sales,
		LAG(Total_Sales)OVER(ORDER BY Sales_Month)AS Previous_Month_Sales
		FROM Monthly_Sales
)
SELECT
	DATENAME(MONTH,Sales_Month) AS Month_Name,
	YEAR(Sales_Month) AS Sales_Year,
	Total_Sales,
	Previous_Month_Sales,
	ROUND((Total_Sales-Previous_Month_Sales)*100.0/NULLIF(Previous_Month_Sales,0),2) AS Monthly_Growth
	FROM Previous_Month
	ORDER BY Sales_Month;

---Rank the top 5 products in each category by sales.---
WITH Product_Sales AS(
	SELECT 
	p.Category,
	p.Product_Name,
	SUM(od.Gross_Sales) AS Total_Sales
	FROM Products AS p
	JOIN Order_Details AS od
	ON od.Product_id=p.Product_id
	GROUP BY p.Category,p.Product_Name
),
Ranked_Products AS(
	SELECT 
	Category,
	Product_Name,
	Total_Sales,
	ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Total_Sales DESC) AS Product_Rank
	FROM Product_Sales
)
SELECT*
FROM Ranked_Products
WHERE Product_Rank<=5
ORDER BY Category,Product_Rank

---Alternative way to get the same result---
CREATE OR ALTER VIEW TOP_5_Product AS
SELECT 
p.Category,
p.Product_Name,
SUM(od.Gross_Sales) AS Total_Sales,
ROW_NUMBER() OVER (PARTITION BY p.Category ORDER BY SUM(od.Gross_Sales )DESC) AS Ranks
FROM Products AS p
JOIN Order_Details AS od
ON od.Product_id=p.Product_id
GROUP BY p.Category,p.Product_Name;

SELECT*
FROM TOP_5_Product
WHERE Ranks<=5
ORDER BY Category,Ranks ASC

----Find each customer's first and most recent order date.----
SELECT
c.Customer_Id,
c.Customer_Name,
MAX(o.Order_date) First_Order,
MIN(o.Order_date) Recent_Order
FROM Orders AS O
JOIN Customers AS c
ON c.Customer_Id=O.Customer_id
GROUP BY c.Customer_Id,c.Customer_Name

---Identify repeat customers and their number of orders.---
SELECT
c.Customer_Id,
c.Customer_Name,
COUNT(o.Order_id) AS number_of_orders
FROM Customers AS c
JOIN Orders AS o
ON c.Customer_Id=o.Customer_id
GROUP BY c.Customer_Id,c.Customer_Name
HAVING  COUNT(o.Order_id)>1

---Calculate discount rate and compare profit margin by category.---
SELECT
p.Category,
SUM(od.Discount_pct) AS Total_Discount,
SUM(od.Profit) AS Total_Profit,
SUM(od.Gross_sales) Total_Sales,
CAST(SUM(od.Profit)*100.0/NULLIF(SUM(od.Gross_sales),0) AS DECIMAL(10,2)) AS Profit_Margin
FROM Order_Details AS od
JOIN Products AS p
ON od.Product_id=p.Product_id
GROUP BY p.Category