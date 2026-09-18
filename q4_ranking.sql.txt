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