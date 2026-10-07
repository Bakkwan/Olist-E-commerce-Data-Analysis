# Olist E-commerce Data Analysis


## 📝 Code Documentation / 代码文档

This section documents the key SQL queries and data cleaning steps used in this project.  
本节记录了项目中使用的关键 SQL 查询与数据清洗步骤。

### 1. Delivery Delay Analysis / 物流延迟分析

- **Purpose / 目的**: Calculate actual delivery duration and flag delayed orders to analyze impact on review scores.  
  计算实际履约时长并标记延迟订单，用于分析延迟对评分的影响。
- **Input tables / 输入表**: `olist_orders`, `olist_order_reviews`, `olist_order_delivered`
- **Output / 输出**: `order_id`, `delivery_days`, `delay_flag`, `review_score`

### 2. RFM Segmentation / RFM 客户分层

- **Purpose / 目的**: Perform RFM segmentation to identify high-value customers.  
  基于最近购买时间、购买频率、消费金额进行 RFM 分层，识别高价值客户。
- **Input tables / 输入表**: `olist_orders`, `olist_order_payments`, `olist_customers`
- **Output / 输出**: `customer_id`, `r_score`, `f_score`, `m_score`, `rfm_segment`

### 3. Sales & Review by State / 各州销售与评分

- **Purpose / 目的**: Aggregate sales, orders, and average review score by customer state to identify low-score regions.  
  按客户所在州汇总销售额、订单量和平均评分，找出低评分高风险地区。
- **Input tables / 输入表**: `olist_orders`, `olist_order_items`, `olist_customers`, `olist_order_reviews`
- **Output / 输出**: `customer_state`, `total_sales`, `total_orders`, `avg_review_score`

### 4. Sales & Review by Category / 品类销售与评分

- **Purpose / 目的**: Aggregate sales, orders, and average review score by product category to identify low-score categories.  
  按产品品类汇总销售额、订单量和平均评分，识别低评分品类。
- **Input tables / 输入表**: `olist_orders`, `olist_order_items`, `olist_products`, `olist_order_reviews`
- **Output / 输出**: `product_category`, `total_sales`, `total_orders`, `avg_review_score`

### 5. Data Cleaning Notes / 数据清洗说明

- Filtered `order_status = 'delivered'` to exclude incomplete orders.  
  只保留 `order_status = 'delivered'` 的订单，排除未完成订单。
- Handled null `review_score` values.  
  处理了 `review_score` 为空值的记录。
- Used `DATEDIFF` to calculate `delivery_days`, excluded negative or outlier values.  
  使用 `DATEDIFF` 计算 `delivery_days`，排除负值或异常值。

## 🇨🇳 中文摘要

本项目分析 Olist 电商平台物流延迟对客户评分的影响，使用 SQL 进行数据清洗和 RFM 分层，Power BI 构建可视化仪表盘。  
核心发现：延迟超过 7 天，评分从 4.4 降至 3.9；AC 州 cool_stuff 品类评分最低；RFM 识别出高价值客户群。  
建议优先优化 AC、AL、MA 等州的物流，并对高风险品类设置预警。

## 📌 Project Overview
Analyzed 100k+ orders from the Olist E-commerce dataset using SQL and Power BI to uncover business insights.

## 📌 Business Problem

Does logistics delay significantly affect customer review scores on the Olist platform?  
Which states and product categories are most affected?  
The goal is to identify key drivers of customer satisfaction and provide actionable recommendations.

## 🛠 Methodology
1. **SQL (CTE, Window Functions)** — calculated delivery time, flagged delays, performed RFM segmentation.
2. **Power BI (DAX, Star Schema)** — built dynamic review attribution model, interactive dashboards.
3. **Data Cleaning** — filtered `order_status = 'delivered'`, handled nulls and outliers.

## 📈 Key Insights
1. **Delivery delay > 7 days drops review score from 4.4 to 3.9** — a 0.5-point gap that directly impacts repeat purchase.
2. **Sales Trends**: Top product categories include cool_stuff, pet_shop, and consoles_games.
3. **Customer Segmentation**: Built an RFM model to identify high-value customers.
4. **AC state has the lowest average score (1.00) for cool_stuff** — urgent need to investigate local logistics.
5. **RFM analysis identifies a high-value customer segment** — targeted retention strategies can improve LTV.

## 📂 Repository Structure
- `queries.sql`: SQL scripts for business logic (joins, CTEs, window functions).
- `dashboard.pdf` (or images): Power BI dashboard screenshots.

## 📊 Dashboard Preview
- [View Dashboard PDF](olist_Data_analysis.pdf)

