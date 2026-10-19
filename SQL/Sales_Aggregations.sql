/*
Project Retail_Sales_Analytics

Stage 3 — Aggregations

Calculate total orders by status.
Calculate total quantity sold by product category and also Profit.
Calculate revenue and profit by sales channel and oe=rder high to low profit.
Find average order value by category.
Find categories with total sales above ₹100,000 and the profit of these category.

*/

---Calculate total orders by status.---
SELECT
Order_status,
COUNT(*) AS Total_Orders
FROM Orders
GROUP BY Order_status;

---Calculate total quantity sold by product category and also Profit.----
SELECT
p.Category,
SUM(od.Quantity) AS Total_Sold_Quantity,
SUM(od.Profit) AS Total_Profit
FROM Order_Details AS od
JOIN Products AS p
ON p.Product_id=od.Product_id
GROUP BY p.Category


---Calculate revenue and profit by sales channel and oe=rder high to low profit ---
SELECT
o.Sales_channel,
SUM(od.Profit) AS Total_Profit,
SUM(od.Sales_amount) AS Revenue
FROM Order_Details AS od
JOIN Orders AS o
ON o.Order_id=od.Order_id
GROUP BY o.Sales_channel
ORDER BY Total_Profit DESC;

---Find average order value by category---
SELECT
p.Category,
AVG(od.Gross_sales) AS Avg_order_value
FROM Order_Details as od
JOIN Products AS p
ON od.Product_id =p.Product_id
GROUP BY p.Category
ORDER BY Avg_order_value DESC

---Find categories with total sales above ₹100,000 and the profit of these category---
SELECT
p.Category,
SUM(od.Gross_Sales) AS Total_Sales,
SUM(od.Profit) AS Total_Profit
FROM Order_Details AS od
JOIN Products AS P
ON P.Product_id=od.Product_id
GROUP BY P.Category
HAVING SUM(od.Gross_Sales)>1000000