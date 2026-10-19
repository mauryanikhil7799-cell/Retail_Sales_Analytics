/*
Project Retail_Sales_Analytics

Stage 4 — Joins 

Show each order with customer name and city.
Show order lines with product name, category, quantity, sales, and profit.
Calculate sales and profit by city and Rank them by profit using Rank Function.
Calculate revenue by customer segment and Rank the by Revenue by using dense rank.
Find customers who have never placed an order.
*/
USE Retail_Sales_Analytics
--- find details of each order with customer name and city and payment method .---

SELECT
o.Order_id,
o.Payment_method,
c.Customer_Id,
c.Customer_Name,
c.State,
c.City
FROM Orders AS o
JOIN Customers AS c
ON c.Customer_Id=o.Customer_id;

---Show order lines with product name, category, quantity, sales, and profit.---
SELECT
DENSE_Rank() 
OVER( ORDER BY od.Order_id) AS Order_Line,
p.Product_name,
od.Order_id,
od.Order_detail_id,
od.Quantity,
p.Category,
od.Gross_sales,
od.Profit
FROM Order_Details AS od
JOIN Products AS p
ON od.Product_id=p.Product_id
ORDER BY Order_Line

---Calculate sales and profit by city and Rank them by profit using Rank Function.---
SELECT
RANK() OVER(ORDER BY SUM(Profit) DESC) AS Profit_Rank,
c.City,
SUM(od.Gross_Sales)Total_Sales,
SUM(Profit) AS Total_profit
FROM Customers AS c
JOIN Orders AS o
ON o.Customer_id=c.Customer_Id
JOIN Order_Details AS od
ON o.Order_id=od.Order_id
GROUP BY c.City;

---Calculate revenue by customer segment and Rank the by Revenue by using dense rank.---
SELECT
DENSE_RANK()OVER(ORDER BY SUM(od.Sales_amount) DESC) AS Rank_by_Revenue,
c.Customer_Segment,
SUM(od.Sales_amount) AS Total_Revenue
FROM Customers AS c
JOIN Orders AS o
ON c.Customer_Id=o.Customer_id
JOIN Order_Details AS od
ON o.Order_id=od.Order_id
GROUP BY c.Customer_Segment;

---Find customers who have never placed an order---
SELECT*
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.Customer_Id=o.Customer_id
WHERE o.Customer_Id IS NULL