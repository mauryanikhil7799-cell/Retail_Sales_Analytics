/*
Project- Retail_Sales_Analytics

---Create a final vie for the tableau dashboard---

*/

USE Retail_Sales_Analytics;

SELECT
c.Customer_Id,
c.Customer_Name,
c.Age,
c.State,
c.City,
c.Customer_Segment,
o.Order_id,
o.Order_date,
od.Order_detail_id,
od.Discount_pct,
od.Gross_sales,
od.Profit,
od.Quantity,
od.Sales_amount,
od.Total_cost,
p.Product_id,
p.Product_name,
p.Category,
o.Payment_method,
o.Order_status,
o.Sales_channel,
p.Unit_cost,
p.Unit_price
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.Customer_Id=o.Customer_id
JOIN Order_Details AS od
ON od.Order_id=o.Order_id
JOIN Products AS p
ON p.Product_id= od.Product_id