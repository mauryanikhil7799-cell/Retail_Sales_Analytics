/*
Project- Retail_Sales_Analytics

Stage 6 — Advanced Query

Use a CTE to calculate customer lifetime sales.
Use ROW_NUMBER to find each customer's latest order.
Use running totals for monthly revenue.
Use LAG to compare monthly sales with the previous month.


*/
USE Retail_Sales_Analytics

---Use a CTE to calculate customer lifetime sales.---
WITH Life_time_sales AS(
SELECT
c.Customer_Id,
c.Customer_Name,
SUM(od.Quantity) AS Life_Time_sales_by_Quantity,
SUM(od.Gross_sales) AS Life_Time_sales_by_Amount
FROM Customers AS c
JOIN Orders AS o
ON o.Customer_id=c.Customer_Id
JOIN Order_Details AS od
ON o.Order_id=od.Order_id
GROUP BY c.Customer_Id,c.Customer_Name
)
SELECT*
FROM Life_time_sales
ORDER BY Life_Time_sales_by_Quantity,  Life_Time_sales_by_Amount DESC

---Use ROW_NUMBER to find each customer's latest order.---
WITH Order_Rank AS
(
SELECT
c.Customer_Id,
o.Order_date,
ROW_NUMBER()OVER(PARTITION BY c.Customer_Id ORDER BY o.Order_date DESC) AS Ranks_by_Order_Date
FROM Customers AS c
JOIN Orders AS o
ON c.Customer_Id=o.Customer_id
GROUP BY c.Customer_Id,o.Order_date
)
SELECT
Customer_Id,
Order_Date AS Latest_Order,
Ranks_by_Order_Date
FROM Order_Rank
WHERE Ranks_by_Order_Date=1

----Use running totals for monthly revenue.---
WITH Running_Sales AS (
    SELECT
        DATEFROMPARTS(YEAR(o.Order_Date), MONTH(o.Order_Date), 1) AS Month_Name,
        SUM(od.Sales_Amount) AS Total_Sales
    FROM Order_Details AS od
    JOIN Orders AS o
        ON o.Order_Id = od.Order_Id
    GROUP BY
        YEAR(o.Order_Date),
        MONTH(o.Order_Date)
)
SELECT
    DATENAME(MONTH, Month_Name) AS Sales_Month,
    YEAR(Month_Name) AS Sales_Year,
    Total_Sales,
    SUM(Total_Sales) OVER (
        ORDER BY Month_Name
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Running_Total
FROM Running_Sales
ORDER BY Month_Name;

---Use LAG to compare monthly sales with the previous month.--
WITH Sales_details AS
(
    SELECT
    DATEFROMPARTS(
                    YEAR(o.Order_date),
                    MONTH(o.Order_date),1
    ) AS Month_of_sales,
    SUM(od.Gross_sales) AS Monthly_sales
    FROM Order_Details AS od
    JOIN Orders AS o
    ON o.Order_id=od.Order_id
    GROUP BY  DATEFROMPARTS(
                    YEAR(o.Order_date),
                    MONTH(o.Order_date),1
    )
)
SELECT
YEAR(Month_of_sales) AS Sale_Year,
DATENAME(MONTH,Month_of_sales)AS Sale_Month,
Monthly_sales,
LAG(Monthly_sales)OVER(ORDER BY Month_of_sales) AS Previous_Month_sales,
(Monthly_sales-LAG(Monthly_sales)OVER(ORDER BY Month_of_sales)) AS Monthly_Growth
FROM Sales_details
ORDER BY YEAR(Month_of_sales),
MONTH(Month_of_sales)
