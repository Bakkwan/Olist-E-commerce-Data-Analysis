-- 1. Logistics Delay vs. Review Score (物流延迟与评分关联)
SELECT 
    CASE 
        WHEN DATEDIFF(day, order_estimated_delivery_date, order_delivered_customer_date) <= 0 THEN 'On Time / Early'
        WHEN DATEDIFF(day, order_estimated_delivery_date, order_delivered_customer_date) <= 7 THEN 'Delayed 1-7 Days'
        ELSE 'Delayed > 7 Days'
    END AS delivery_status,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

-- 2. Sales & Orders by State (各州销售额与订单量 Top 10)
SELECT 
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_sales DESC
LIMIT 10;

-- 3. RFM Customer Segmentation (RFM客户价值分层)
WITH rfm_base AS (
    SELECT 
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS last_purchase_date,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price + oi.freight_value) AS monetary
    FROM olist_customers_dataset c
    JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_score AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY last_purchase_date DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency DESC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary DESC) AS m_score
    FROM rfm_base
)
SELECT 
    customer_unique_id,
    (r_score + f_score + m_score) AS rfm_total_score,
    CASE 
        WHEN (r_score + f_score + m_score) >= 10 THEN 'High Value'
        WHEN (r_score + f_score + m_score) >= 7 THEN 'Potential'
        ELSE 'Low Value / At Risk'
    END AS customer_segment
FROM rfm_score;
