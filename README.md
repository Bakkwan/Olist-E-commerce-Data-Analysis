# Olist E-commerce Data Analysis


## 📝 Code Documentation

- Each SQL query includes a comment: `-- Purpose: ...; Input tables: ...; Output: ...`
- Key functions explained: `NTILE(4)` for quartile segmentation, `DATEDIFF` for delivery duration.
- Data cleaning note: filtered `order_status = 'delivered'` to exclude incomplete orders.

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

