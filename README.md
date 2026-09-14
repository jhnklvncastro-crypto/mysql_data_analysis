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

[Uploading q1_top_customerSELECT
    c.customer_unique_id,
    SUM(p.payment_value) AS total_amount_spent
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
JOIN order_payments AS p
    ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    c.customer_unique_id
ORDER BY
    total_amount_spent DESC
LIMIT 10;
s.sql.txt…]()

[q2_revenue_trends_sql.txt](https://github.com/user-attachments/files/32203068/q2_revenue_trends_sql.txt)
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS revenue_month,
    SUM(p.payment_value) AS total_revenue
FROM orders AS o
JOIN order_payments AS p
    ON o.order_id = p.order_id
GROUP BY
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY
    revenue_month ASC;

[q3_revenue_trends.sql.txt](https://github.com/user-attachments/files/32203077/q3_revenue_trends.sql.txt)


WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(
            o.order_purchase_timestamp,
            '%Y-%m'
        ) AS revenue_month,
        SUM(p.payment_value) AS total_revenue
    FROM orders AS o
    JOIN order_payments AS p
        ON o.order_id = p.order_id
    GROUP BY
        DATE_FORMAT(
            o.order_purchase_timestamp,
            '%Y-%m'
        )
),

revenue_comparison AS (
    SELECT
        revenue_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY revenue_month
        ) AS previous_month_revenue
    FROM monthly_revenue
)

SELECT
    revenue_month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_month_revenue, 2)
        AS previous_month_revenue,
    ROUND(
        total_revenue - previous_month_revenue,
        2
    ) AS mom_change,
    ROUND(
        (
            (total_revenue - previous_month_revenue)
             NULLIF(previous_month_revenue, 0)
        )  100,
        2
    ) AS mom_change_percentage
FROM revenue_comparison
ORDER BY revenue_month;

[q4_ranking.sql.txt](https://github.com/user-attachments/files/32203081/q4_ranking.sql.txt)
SELECT
    pct.product_category_name_english AS product_category,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items AS oi
JOIN products AS p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation AS pct
    ON p.product_category_name = pct.product_category_name
GROUP BY
    pct.product_category_name_english
ORDER BY
    total_revenue DESC;

[q5_ranking.sql.txt](https://github.com/user-attachments/files/32203089/q5_ranking.sql.txt)

WITH product_revenue AS (
    SELECT
        pct.product_category_name_english AS product_category,
        p.product_id,
        SUM(oi.price) AS total_revenue
    FROM order_items AS oi
    JOIN products AS p
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation AS pct
        ON p.product_category_name = pct.product_category_name
    GROUP BY
        pct.product_category_name_english,
        p.product_id
),

ranked_products AS (
    SELECT
        product_category,
        product_id,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY product_category
            ORDER BY total_revenue DESC
        ) AS rn
    FROM product_revenue
)

SELECT
    product_category,
    product_id,
    ROUND(total_revenue, 2) AS total_revenue,
    rn AS product_rank
FROM ranked_products
WHERE rn <= 3
ORDER BY
    product_category,
    product_rank;

[q6_segmentation.sql.txt](https://github.com/user-attachments/files/32203121/q6_segmentation.sql.txt)

WITH customer_spend AS (
    SELECT
        c.customer_unique_id,
        SUM(op.payment_value) AS total_spend
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    JOIN order_payments AS op
        ON o.order_id = op.order_id
    GROUP BY
        c.customer_unique_id
)

SELECT
    customer_unique_id,
    ROUND(total_spend, 2) AS total_spend,
    CASE
        WHEN total_spend < 100 THEN 'Low'
        WHEN total_spend < 500 THEN 'Medium'
        ELSE 'High'
    END AS spend_tier
FROM customer_spend
ORDER BY
    total_spend DESC;


[q7_behaviour.sql.txt](https://github.com/user-attachments/files/32203125/q7_behaviour.sql.txt)

    

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
)

SELECT
    CASE
        WHEN order_count > 1 THEN 'Repeat Buyer'
        ELSE 'One-Time Buyer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM customer_orders
GROUP BY
    CASE
        WHEN order_count > 1 THEN 'Repeat Buyer'
        ELSE 'One-Time Buyer'
    END
ORDER BY
    customer_count DESC;

[q8_behaviour.sql.txt](https://github.com/user-attachments/files/32203139/q8_behaviour.sql.txt)





WITH category_revenue AS (
    SELECT
        pct.product_category_name_english AS product_category,
        SUM(oi.price) AS total_revenue
    FROM order_items AS oi
    JOIN products AS p
        ON oi.product_id = p.product_id
    JOIN product_category_name_translation AS pct
        ON p.product_category_name = pct.product_category_name
    GROUP BY
        pct.product_category_name_english
),
category_percentage AS (
    SELECT
        product_category,
        total_revenue,
        SUM(total_revenue) OVER () AS overall_revenue
    FROM category_revenue
)
SELECT
    product_category,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        (total_revenue / overall_revenue) * 100,
        2
    ) AS revenue_percentage
FROM category_percentage
ORDER BY
    total_revenue DESC
LIMIT 1;
