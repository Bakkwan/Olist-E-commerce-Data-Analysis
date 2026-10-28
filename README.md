
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
  注：商品销售额仅包含商品价格，不含运费；用户贡献总金额（GMV）包含商品价格+运费

### 5. Data Processing Notes / 数据处理说明

- Filtered `order_status = 'delivered'` to exclude incomplete orders.  
  只保留 `order_status = 'delivered'` 的订单，排除未完成订单。
- Used `julianday` to calculate `delivery_days`, excluded negative or outlier values.  
  使用 `julianday` 计算 `delivery_days`，排除负值或异常值。

## 🇨🇳 中文摘要

本项目分析 Olist 电商平台物流延迟对客户评分的影响，使用 SQL 进行数据清洗和 RFM 分层，Power BI 构建可视化仪表盘。  
核心发现：准时/提前(86,984单) 4.21分 → 延迟1–7 天（3,585单） 2.68分 → 延迟7天以上（2,781单） 1.69分；品类侧定位 bed_bath_table 为唯一“销量头部（9,272 单）+ 评分偏低（3.92）”的组合；RFM 识别出高价值客户群。  
建议：优先排查 bed_bath_table 品类的履约表现与客户评价，进一步确认其较低评分的可能原因，再评估是否需要针对性优化。


## 📌 Project Overview / 项目概述

Analyzed 93,358 orders from the Olist E-commerce dataset using SQL and Power BI to uncover business insights.  
使用 SQL 和 Power BI 分析 Olist 电商数据集中的 93,358 笔订单，挖掘业务洞察。

---

## 📌 Business Problem / 业务问题

What is the relationship between delivery delays and customer satisfaction?  
配送延迟与客户满意度有什么关系？

How should the platform identify and handle high-risk orders?
平台应该如何识别并处理高风险订单？


---

## 🛠 Methodology / 分析方法

1. **SQL ( Window Functions)** — calculated delivery time, flagged delays, performed RFM segmentation.  
   **SQL（窗口函数）** — 计算履约时长，标记延迟订单，进行 RFM 分层。

2. **Power BI (DAX, Star Schema)** — Build dynamic metrics using DAX and analyze score differences through interactive dashboards.
   **Power BI（DAX、星型模型）** — 使用 DAX 构建动态指标，并通过交互式仪表盘分析评分差异。



---

## 🔍 Key Insights / 核心发现

1. **On time/Early (86,984 orders) 4.21 points → Delayed 1–7 days (3,585 orders) 2.68 points → Delayed more than 7 days (2,781 orders) 1.69 points.It is recommended to first identify orders that may be delayed, and then decide whether to escalate intervention based on the level of risk.
   **准时/提前(86,984单) 4.21分 → 延迟1–7 天（3,585单） 2.68分 → 延迟7天以上（2,781单） 1.69分** 建议先识别可能延迟的订单，再根据风险程度决定是否升级干预处理。

2. **Sales Trends**: The three main markets are SP, RJ and MG.  
   **销售趋势**：三大主要市场包括 SP / RJ / MG。

3. **Customer Segmentation**: Built an RFM model to identify high-value customers.  
   **客户分层**：构建 RFM 模型识别高价值客户。

4. **Observed anomaly in AC state for cool_stuff**:
   Preliminary analysis shows that the average rating for the cool_stuff category in AC state is only 1.00, and it was once listed as an area requiring urgent attention. After reviewing the sample size, it was confirmed that this conclusion was based on only one order, and it has been retracted.
   **AC 州 cool_stuff 品类异常值观察**：
   初步分析显示 AC 州 cool_stuff 品类平均评分仅 1.00，一度被列为需紧急处理的区域，回溯样本量后确认该结论仅由 1 条订单构成，已撤回。

5. **RFM analysis identifies a high-value customer segment** — targeted retention strategies can improve LTV.  
   **RFM 分析识别出高价值客户群** — 针对性留存策略可提升客户终身价值（LTV）。

--注：物流时效以日期（Date）粒度计算，不考虑具体时分秒；实际送达日期不晚于承诺送达日期的订单归类为“准时/提前”，晚于承诺送达日期的订单按自然日差进行延迟分组。

---

## 📁 Repository Structure / 仓库结构

- `olist_queries.sql`: SQL scripts for business logic (joins,  window functions).  
  `olist_queries.sql`：业务逻辑 SQL 脚本（联结、窗口函数）。

- `olist_Data_analysis.pdf` (or `images/`): Power BI dashboard screenshots.  
  `olist_Data_analysis.pdf`（或 `images/`）：Power BI 仪表盘截图。
- `Dashboard_notes.md` : Dashboard 逐页解读与商业建议（中英双语）

---

## 📊 Dashboard Preview / 仪表盘预览

 - [查看仪表盘 PDF / View Dashboard PDF](<Olist 电商平台履约时效与客户满意度分析.pdf>)
 - [View Dashboard Notes (中英双语)](Dashboard_notes.md)
