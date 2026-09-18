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