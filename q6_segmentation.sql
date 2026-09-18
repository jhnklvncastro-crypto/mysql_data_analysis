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