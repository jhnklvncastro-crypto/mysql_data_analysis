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