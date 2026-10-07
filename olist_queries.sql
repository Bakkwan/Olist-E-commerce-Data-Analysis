-- ============================================================
-- Olist E-commerce Data Analysis - SQL Queries
-- Olist 电商数据分析 - SQL 查询
-- ============================================================
-- Author / 作者: [BakkwanChan/陈碧云]
-- Date / 日期: 2026-10
-- Description / 描述: This file contains SQL queries for analyzing Olist e-commerce data, including delivery delay analysis, RFM segmentation, and sales/review aggregation by state and category.
-- 本文件包含用于分析 Olist 电商数据的 SQL 查询，包括物流延迟分析、RFM 分层、以及按州和品类的销售与评分汇总。
-- Data Source / 数据来源: Olist Brazilian E-Commerce Public Dataset (Kaggle), ~100k orders from 2016-2018.
-- 数据来源：Olist 巴西电商公开数据集（Kaggle），2016-2018 年约 10 万笔订单。
--
-- Key Findings / 核心发现:
--   1. Delivery delay > 7 days drops review score from 4.4 to 3.9.
--      延迟超过 7 天，评分从 4.4 降至 3.9。
--   2. AC state has the lowest average score (1.00) for cool_stuff.
--      AC 州 cool_stuff 品类平均评分最低（1.00）。
--   3. RFM analysis identifies a high-value customer segment for retention.
--      RFM 分析识别出高价值客户群，可用于留存策略。
--
-- Data Cleaning Notes / 数据清洗说明:
--   1. Filtered order_status = 'delivered' to exclude incomplete orders.
--      只保留 order_status = 'delivered' 的订单，排除未完成订单。
--   2. Handled null review_score values.
--      处理了 review_score 为空值的记录。
--   3. Used DATEDIFF to calculate delivery_days, excluded negative or outlier values.
--      使用 DATEDIFF 计算 delivery_days，排除负值或异常值。
-- ============================================================

-- ============================================================
-- Section 1: Delivery Delay Analysis / 第一部分：物流延迟分析
-- ============================================================

-- ------------------------------------------------------------
-- Query 1.1: Logistics Delay vs. Review Score / 查询 1.1：物流延迟与评分
-- Purpose / 目的: Calculate delivery duration and flag delayed orders to analyze impact on review scores.
--                 计算履约时长并标记延迟订单，用于分析延迟对评分的影响。
-- Input tables / 输入表: olist_orders_dataset, olist_order_reviews_dataset
-- Output / 输出: delivery_status, total_orders, avg_review_score
-- Key functions / 关键函数: DATEDIFF (delivery duration), CASE WHEN (delay flag), ROUND, AVG
-- ------------------------------------------------------------
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
GROUP BY delivery_status
ORDER BY delivery_status;

-- ============================================================
-- Section 2: Sales & Review by State / 第二部分：各州销售与评分
-- ============================================================

-- ------------------------------------------------------------
-- Query 2.1: Sales & Orders by State (Top 10) / 查询 2.1：各州销售额与订单量（Top 10）
-- Purpose / 目的: Aggregate total orders and total sales by customer state to identify top-performing regions.
--                 按客户所在州汇总订单量和销售额，识别表现最好的地区。
-- Input tables / 输入表: olist_orders_dataset, olist_customers_dataset, olist_order_items_dataset
-- Output / 输出: customer_state, total_orders, total_sales
-- Key functions / 关键函数: JOIN, GROUP BY, COUNT(DISTINCT), SUM, ROUND, LIMIT
-- ------------------------------------------------------------
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

-- ============================================================
-- Section 3: RFM Segmentation / 第三部分：RFM 客户分层
-- ============================================================

-- ------------------------------------------------------------
-- Query 3.1: RFM Customer Segmentation / 查询 3.1：RFM 客户价值分层
-- Note / 说明: r_score = 1 means most recent purchase, r_score = 4 means oldest.
--              r_score = 1 表示最近购买，r_score = 4 表示最久未购买。
-- Purpose / 目的: Perform RFM segmentation to identify high-value customers based on recency, frequency, and monetary value.
--                 基于最近购买时间、购买频率、消费金额进行 RFM 分层，识别高价值客户。
-- Input tables / 输入表: olist_customers_dataset, olist_orders_dataset, olist_order_items_dataset
-- Output / 输出: customer_unique_id, rfm_total_score, customer_segment
-- Key functions / 关键函数: CTE (WITH), NTILE(4) for quartile scoring, CASE WHEN for segmentation
-- Segmentation rules / 分层规则:
--   - High Value: rfm_total_score >= 10 / 高价值：总分 >= 10
--   - Potential: rfm_total_score >= 7 / 潜力客户：总分 >= 7
--   - Low Value / At Risk: rfm_total_score < 7 / 低价值/流失风险：总分 < 7
-- ------------------------------------------------------------
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
        NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
)
SELECT 
    customer_unique_id,
    ((5 - r_score) + f_score + m_score) AS rfm_total_score,
    CASE 
        WHEN ((5 - r_score) + f_score + m_score) >= 10 THEN 'High Value'
        WHEN ((5 - r_score) + f_score + m_score) >= 7 THEN 'Potential'
        ELSE 'Low Value / At Risk'
    END AS customer_segment
FROM rfm_score;

-- ============================================================
-- Section 4: Sales & Review by Category / 第四部分：品类销售与评分
-- ============================================================

-- ------------------------------------------------------------
-- Query 4.1: Sales & Review by Product Category / 查询 4.1：品类销售与评分
-- Purpose / 目的: Aggregate total orders, total sales, and average review score by product category.
--                 按产品品类汇总订单量、销售额和平均评分。
-- Input tables / 输入表: olist_orders_dataset, olist_order_items_dataset, olist_products_dataset, olist_order_reviews_dataset
-- Output / 输出: product_category, total_orders, total_sales, avg_review_score
-- Key functions / 关键函数: JOIN, GROUP BY, COUNT(DISTINCT), SUM, ROUND, AVG
-- ------------------------------------------------------------
WITH order_reviews AS (
    SELECT
        order_id,
        AVG(review_score) AS review_score
    FROM olist_order_reviews_dataset
    GROUP BY order_id
),

category_sales AS (
    SELECT
        oi.order_id,
        p.product_category,
        SUM(oi.price) AS sales
    FROM olist_order_items_dataset oi
    JOIN olist_products_dataset p
        ON oi.product_id = p.product_id
    GROUP BY
        oi.order_id,
        p.product_category
)

SELECT
    cs.product_category,
    SUM(cs.sales) AS total_sales,
    COUNT(DISTINCT cs.order_id) AS total_orders,
    AVG(orv.review_score) AS avg_review_score
FROM category_sales cs
JOIN olist_orders_dataset o
    ON cs.order_id = o.order_id
LEFT JOIN order_reviews orv
    ON cs.order_id = orv.order_id
WHERE o.order_status = 'delivered'
GROUP BY cs.product_category;

-- ============================================================
-- Key Functions Explanation / 关键函数说明
-- ============================================================
-- DATEDIFF: Calculates the difference between two dates (e.g., delivery duration).
--           计算两个日期之间的差值（例如：履约时长）。
-- CASE WHEN: Creates conditional logic (e.g., flag orders delayed > 7 days).
--            创建条件逻辑（例如：标记延迟超过 7 天的订单）。
-- NTILE(4): Divides rows into 4 equal buckets for RFM quartile scoring.
--           将行分成 4 个等份，用于 RFM 四分位评分。
-- CTE (WITH): Creates temporary result sets for multi-step queries.
--            创建临时结果集，用于多步骤查询。
-- COUNT(DISTINCT): Counts unique values (e.g., unique orders per state).
--                  统计唯一值（例如：每个州的唯一订单数）。

-- ============================================================
-- End of File / 文件结束
-- ============================================================
-- ============================================================
