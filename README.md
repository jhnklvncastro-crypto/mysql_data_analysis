[q1_top_customers.sql.txt](https://github.com/user-attachments/files/32203063/q1_top_customers.sql.txt)# mysql_data_analysis
My portfolio for mysql data analytics course
[README.md](https://github.com/user-attachments/files/32203047/README.md)

# Olist SQL Analysis

## Overview

This project analyzes the **Brazilian E-Commerce Public Dataset by Olist** using MySQL. The goal is to turn e-commerce data into business insights about customer spending, revenue trends, product performance, and purchasing behavior.

The dataset is commonly distributed as nine related CSV tables. This analysis uses `customers`, `orders`, `order\_payments`, `order\_items`, `products`, and `product\_category\_name\_translation`. The order data spans approximately **September 2016 through September 2018**.

Data-quality considerations include orders with different statuses, possible missing product-category translations, and the distinction between `customer\_id` (a customer record associated with an order) and `customer\_unique\_id` (used to identify a customer across orders). Revenue calculations also depend on the selected measure: the queries below use payment value for customer/monthly revenue and item price for product-category revenue.

\---

## Business Questions

1. **Who are the top 10 customers by total amount spent?** Uses customer, order, and payment data; the query filters to delivered orders.
2. **What is the monthly revenue trend?** Aggregates payment value by purchase month.
3. **What is the month-over-month change in revenue?** Uses a CTE and `LAG()` to compare each month with the previous month.
4. **Which product categories generate the most revenue?** Joins order items to products and English category translations, then ranks categories by item price revenue.
5. **What are the top 3 products within each category?** Uses `ROW\_NUMBER()` with `PARTITION BY` category to rank products by revenue.
6. **How can customers be segmented by spending level?** Uses a CTE and `CASE WHEN` to classify customers as Low, Medium, or High spenders.
7. **How many customers are repeat buyers versus one-time buyers?** Counts orders per `customer\_unique\_id` and groups customers by purchase frequency.
8. **What percentage of total revenue comes from the top category?** Uses `SUM() OVER ()` to calculate each category's share of total category revenue, then returns the leading category.

\---

## Key Findings

### 1\. Revenue varies by product category

Q4 ranks product categories by revenue, and Q8 calculates the leading category's percentage of total category revenue. Use the result rows from these queries to identify the category with the greatest revenue contribution. A high share means the business may be especially sensitive to changes in that category's demand, pricing, or product availability.

### 2\. Customer spending levels differ

Q1 identifies the ten customers with the highest total payment value among delivered orders, while Q6 assigns customers to spending tiers. Together, these results help distinguish high-value customers from lower-spending customers and show where targeted retention efforts may be worthwhile. The Q6 thresholds (`<100`, `<500`, and `>=500`) are illustrative and should be adjusted if the project defines different thresholds.

### 3\. Repeat purchasing can support growth

Q7 counts customers who placed one order versus more than one order, using `customer\_unique\_id` to recognize customers across multiple customer records. The result indicates the scale of the repeat-purchase opportunity. Q2 and Q3 add monthly context by showing revenue trends and month-over-month changes, which can help identify periods for evaluating promotions or customer-engagement campaigns.

> \*\*Note:\*\* Replace these general findings with the exact category name, revenue amounts, percentages, and customer counts returned by your SQL queries before publishing the project. No query output values were provided for this README.

\---

## Recommendations

### 1\. Focus on leading product categories

Use the category rankings in Q4 and the contribution percentage in Q8 to prioritize inventory monitoring and marketing for the highest-revenue categories. Review the leading category's performance regularly so that stock shortages or changes in demand can be addressed early.

### 2\. Encourage repeat purchases and retain valuable customers

Use Q1 and Q6 to identify high-value customers for relevant retention offers, and use Q7 to target one-time buyers with follow-up campaigns or product recommendations. Compare monthly revenue in Q2 and Q3 before and after campaigns to assess whether they coincide with improved performance.

\---

## Tools \& Skills

### Tools

* MySQL
* MySQL Workbench
* SQL
* GitHub

### SQL Skills Demonstrated

* `SELECT`, `JOIN`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, and `LIMIT`
* Aggregate functions: `SUM()` and `COUNT()`
* Date formatting with `DATE\_FORMAT()`
* Common Table Expressions (CTEs)
* Conditional logic with `CASE WHEN`
* Window functions: `LAG()`, `ROW\_NUMBER()`, and `SUM() OVER ()`
* `PARTITION BY` for ranking within groups
* Revenue analysis, customer segmentation, ranking, month-over-month analysis, and percent-of-total analysis

\---

## Data Notes

* Q1 filters to `order\_status = 'delivered'`; Q2, Q3, Q4, Q5, Q6, Q7, and Q8 do not apply that same filter unless you add it.
* Q2 and Q3 use `order\_payments.payment\_value`, which can include payment amounts beyond item prices.
* Q4, Q5, and Q8 use `order\_items.price`, excluding shipping fees.
* Q6 uses example spending thresholds: Low is below 100, Medium is 100 to below 500, and High is 500 or more.
* Q7 groups by `customer\_unique\_id` so repeat orders across customer records are counted together.
* The first month in Q3 has no previous month, so its month-over-month comparison is `NULL`.

\---

## Files

|File|Description|
|-|-|
|`README.md`|Project overview, business questions, findings, and recommendations|
|`olist\_analysis.sql`|SQL queries used to answer Q1–Q8 (add this file to the repository)|
|`dataset/`|Dataset CSV files (include only if permitted by the dataset's terms)|

\---

## Author



**John Kelvin Castro**

SQL Data Analysis Project  
Brazilian E-Commerce Public Dataset by Olist
