# **Hagital Store Sales Record Analysis**
---
## 📑 Table of Contents

1. [Project Overview](#project-overview)
2. [Data Sources](#data-sources)
3. [Tools Used](#tools-used)
4. [Data Cleaning and Preparation](#data-cleaning-and-preparation)
5. [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
6. [Detailed Data Analysis](#detailed-data-analysis)
7. [Results and Key Findings](#results-and-key-findings)
8. [Recommendations](#recommendations)
9. [Limitations](#limitations)
10. [References](#references)

---

## 🧩 Project Overview

This project focuses on analyzing the sales performance of **Hagital Store**, using historical sales records to extract insights into customer behavior, product performance, regional profitability, and sales team contributions. The goal is to assist stakeholders in making informed decisions to boost profitability and efficiency.

---

## 📂 Data Sources

* **Excel File**: `All Sales Records_PBI.xlsx`
  * Contains all transactional sales data (customer details, order details, sales reps, product categories).
---

## 🛠 Tools Used

* **Power BI Desktop**
* **Microsoft Power Query (for data cleaning and transformation)**
* **Microsoft Excel**
* **DAX (Data Analysis Expressions)**
* **GitHub (for project documentation and versioning)**

---

## 🧹 Data Cleaning and Preparation

Performed in **Power Query Editor**:
* **Removed Duplicates**: Eliminated redundant rows across tables.
* **Column Normalization**: Standardized naming conventions and data formats (dates, numbers).
* **Data Types**: Corrected data types for key columns (e.g., Date, Profit, Quantity).
* **Filtering Nulls**: Removed rows with critical nulls (e.g., missing region or category).
* **Merged Tables**: Joined Sales, Customer, Region, and Product data for unified analysis.
* **Created Calculated Columns**:

  * `Revenue = Quantity x Unit Price`
  * `Profit Margin = (Profit / Revenue) * 100`

---

## 🔍 Exploratory Data Analysis (EDA)

### 1. **Sales Overview Page**
* Visuals:
  * KPI Cards: Revenue (\$9.89M), Profit (\$286.40K), Orders (5009)
  * Bar Chart: Top 10 Customers by Revenue
  * Line & Bar Combo: Yearly Orders vs Profit (2014–2017)
  * Donut Chart: Revenue by Region (East dominates)
  * Map: Orders by State and Region
  * Horizontal Bar: Top Product Categories (Copiers, Phones, Accessories)

### 2. **Order Details Page**
* Insights into:
  * Product-level performance
  * Order quantity trends
  * Delivery status and customer satisfaction (assumed based on table structure)

### 3. **Staff Details Page**
* Focus on:
  * Sales rep performance
  * Revenue contribution by staff
  * Regional assignments and output

---

## 📊 Detailed Data Analysis

* **Top Customers**: Adrian Barton generated the highest revenue (\~\$150K+)
* **Product Leaders**: Copiers and Phones lead sales volume
* **Profit Trends**: Steady growth from 2014 to 2017 with peak profit and order volume in 2017
* **Regional Insights**:
  * **East Region**: Highest number of orders
  * **West Region**: Moderate revenue, low order frequency
* **Sales Staff Performance**: Likely ranking based on revenue contribution and order handling (details from Staff Details page)

---

## 🧾 Results and Key Findings

* **Revenue**: \$9.89M total revenue with significant customer and product concentration
* **Profit**: \$286.4K, indicating moderate margin; potential pricing optimization needed
* **Geographic Performance**: East region outperforms others in orders and revenue
* **Customer Base**: Top 10 customers drive a disproportionately large share of sales
* **Yearly Growth**: Clear upward trend in both orders and profit, especially post-2015

---

## ✅ Recommendations

1. **Expand Sales in Underperforming Regions**: Focus marketing in Central and West
2. **Retain Top Customers**: Personalized incentives for Adrian Barton and other high-value clients
3. **Optimize Product Mix**: Invest more in high-demand categories like Phones and Copiers
4. **Evaluate Pricing Strategy**: Margins are tight; assess profit leakage
5. **Incentivize Top-Performing Staff**: Use Staff Details insights for performance bonuses

---

## ⚠️ Limitations

* **Dataset Timeframe**: Ends in 2017; trends may not reflect current conditions
* **Lack of External Factors**: No integration of economic or seasonal variables
* **Missing Customer Feedback**: No sentiment data or customer satisfaction metrics

---

## 📚 References

* [Microsoft Power BI Documentation](https://docs.microsoft.com/en-us/power-bi/)
* Source File: `All Sales Records_PBI.xlsx`
