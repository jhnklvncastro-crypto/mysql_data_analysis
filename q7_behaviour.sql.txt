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