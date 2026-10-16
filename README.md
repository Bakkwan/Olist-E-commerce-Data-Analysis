
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
核心发现：延迟1–3 天 3.29分 → 延迟4–7 天 2.11分 → 延迟8–14 天 1.67分；品类侧定位 bed_bath_table 为唯一“销量头部（9,272 单）+ 评分偏低（3.92）”的组合；RFM 识别出高价值客户群。  
建议优先bed_bath_table的品类的体验改善以对整体满意度达成拉动最大化，并将预警阈值前移至“延迟满3天”触发客服主动介入。


## 📌 Project Overview / 项目概述

Analyzed 100k+ orders from the Olist E-commerce dataset using SQL and Power BI to uncover business insights.  
使用 SQL 和 Power BI 分析 Olist 电商数据集中的 10 万+ 订单，挖掘业务洞察。

---

## 📌 Business Problem / 业务问题

Does logistics delay significantly affect customer review scores on the Olist platform?  
物流延迟是否显著影响 Olist 平台的客户评分？

Which states and product categories are most affected?  
哪些州和产品品类受影响最大？

The goal is to identify key drivers of customer satisfaction and provide actionable recommendations.  
目标是识别客户满意度的关键驱动因素，并提供可落地的建议。

---

## 🛠 Methodology / 分析方法

1. **SQL (CTE, Window Functions)** — calculated delivery time, flagged delays, performed RFM segmentation.  
   **SQL（CTE、窗口函数）** — 计算履约时长，标记延迟订单，进行 RFM 分层。

2. **Power BI (DAX, Star Schema)** — built dynamic review attribution model, interactive dashboards.  
   **Power BI（DAX、星型模型）** — 构建动态评分归因模型，制作交互式仪表盘。

3. **Data Cleaning** — filtered, handled nulls and outliers. `order_status = 'delivered'`  
   **数据清洗** — 过滤数据，处理空值和异常值。`order_status = 'delivered'`

---

## 🔍 Key Insights / 核心发现

1. **Delay of 1–3 days: 3.29 points → Delay of 4–7 days: 2.11 points → Delay of 8–14 days: 1.67 points. Accordingly, it is recommended that the early warning threshold be brought forward to ‘a delay of three full days’ and that this trigger proactive intervention by customer service.  
   **延迟1–3 天 3.29分 → 延迟4–7 天 2.11分 → 延迟8–14 天 1.67分** 据此建议将预警阈值前移至“延迟满 3 天”并触发客服主动介入。

2. **Sales Trends**: The three main markets are SP, RJ and MG.  
   **销售趋势**：三大主要市场包括 SP / RJ / MG。

3. **Customer Segmentation**: Built an RFM model to identify high-value customers.  
   **客户分层**：构建 RFM 模型识别高价值客户。

4. **Observed anomaly in AC state for cool_stuff**:
   Based on a sample size threshold of ≥30, priority should be given to states with low ratings but sufficient sample sizes, such as MA (3.61). This highlights the importance of verifying data adequacy before drawing business conclusions; future analyses should set a minimum order threshold (e.g. >30 reviews) to ensure statistical significance. 
   **AC 州 cool_stuff 品类异常值观察**：
   基于样本量≥30阈值后，优先关注MA(3.61)等样本充足的低评分州。这凸显了在得出商业结论前验证数据充分性的重要性,未来分析应设定最低订单阈值（如 >30 条评价）以确保统计相关性。

5. **RFM analysis identifies a high-value customer segment** — targeted retention strategies can improve LTV.  
   **RFM 分析识别出高价值客户群** — 针对性留存策略可提升客户终身价值（LTV）。

---

## 📁 Repository Structure / 仓库结构

- `olist_queries.sql`: SQL scripts for business logic (joins, CTEs, window functions).  
  `olist_queries.sql`：业务逻辑 SQL 脚本（联结、CTE、窗口函数）。

- `olist_Data_analysis.pdf` (or `images/`): Power BI dashboard screenshots.  
  `olist_Data_analysis.pdf`（或 `images/`）：Power BI 仪表盘截图。
- `Dashboard_notes.md` : Dashboard 逐页解读与商业建议（中英双语）

---

## 📊 Dashboard Preview / 仪表盘预览

 - [View Dashboard PDF](olist_Data_analysis.pdf)
 - [查看仪表盘 PDF](olist_Data_analysis.pdf)
 - [View Dashboard Notes (中英双语)](Dashboard_notes.md)
