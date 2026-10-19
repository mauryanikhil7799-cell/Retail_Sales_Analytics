/*
Project Retail_Sales_Analytics

Stage 2 — Basic queries

Show the first 10 customers from Uttar Pradesh.
List products priced above ₹1,500.
Find orders placed during 2025.
List unique sales channels and payment methods.
Show the 10 most expensive products.
*/

---Find out the first 10 Customer from Uttar pradesh based on the signup date who has placed atleast one order---
SELECT TOP 10 * 
FROM Customers AS c
WHERE c.State='Uttar Pradesh'
AND EXISTS(
			SELECT 1
			FROM Orders AS o
			WHERE o.Customer_id=c.Customer_Id
			)
ORDER BY Signup_date ASC;

----List products priced above ₹1,500and cost above ₹500----
SELECT*
FROM Products
WHERE Unit_price>=1500 AND Unit_cost>=500

---Show the 10 most expensive products.---
SELECT TOP 10 
Product_id,
Product_name,
Unit_price
FROM Products
ORDER BY Unit_price DESC

---List unique sales channels and payment methods and the no of time they are used.---
SELECT
Payment_method,
Sales_channel,
COUNT(*) AS No_of_times_used
FROM Orders
GROUP BY Payment_method,
Sales_channel
ORDER BY No_of_times_used DESC