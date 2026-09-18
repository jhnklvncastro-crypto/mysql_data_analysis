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