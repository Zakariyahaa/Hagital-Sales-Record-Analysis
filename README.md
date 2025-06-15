# **Hagital Store Sales Record Analysis (Capstone Project)**
---
## 📑 Table of Contents

1. [Project Overview](#project-overview)
2. [Data Sources](#data-sources)
3. [Tools Used](#tools-used)
4. [Data Cleaning and Preparation](#data-cleaning-and-preparation)
5. [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
   - [Overall Summary Metrics](#overall-summary-metrics)  
   - [Trend Analysis by Year](#trend-analysis-by-year)  
   - [Regional Performance](#regional-performance)  
   - [Category & Sub‐Category Performance](#category--sub-category-performance)  
   - [Top Customers](#top-customers)  
   - [Order Destinations (Geographic)](#order-destinations-geographic)  
6. [Detailed Data Analysis](#detailed-data-analysis)
   - [Sales vs. Profit Relationships](#sales-vs-profit-relationships)  
   - [Shipping Delays & Their Impact](#shipping-delays--their-impact)  
   - [Margin Analysis by Product Line](#margin-analysis-by-product-line)  
   - [Seasonality & Monthly Patterns](#seasonality--monthly-patterns)
   - [Answers to Capstone Project Questions](#answers-to-capstone-project-questions)
7. [Results and Key Findings](#results-and-key-findings)
8. [Recommendations](#recommendations)
9. [Limitations](#limitations)
10. [References](#references)

---

## 🧩 Project Overview

This project analyzes the sales performance of **Hagital Store**, a retailer with operations across various regions, focusing on sales, profit, and order trends from 2014 to 2017. The goal is to uncover insights into sales patterns, team performance, and product categories to inform business strategies. The analysis leverages a dataset of sales records, demonstrating how the data was cleaned, explored, and analyzed, and then presenting key findings and actionable recommendations.

   ![Sales Overview](https://github.com/user-attachments/assets/df31a34b-e8cc-4c66-ae73-252b02b1cd87)

---

## 📂 Data Sources

* **Excel Files**: `2014 Sales Records.xlsx`, `2015 Sales Records.xlsx`, `2016 Sales Records.xlsx`, `2017 Sales Records.xlsx`, `All Sales Records_PBI.xlsx`
* A combination of 4 Excel Files into a single Excel sheet `Sales Table` containing 9,994 rows (transactions) and 23 columns, covering Hagital Store’s orders from 2014 to 2017
  * Contains sales records with columns: Order ID, Order Date, Ship Date, Ship Mode, Customer ID, Customer Name, Segment, Sales Rep, Sales Team, Sales Team Manager, Location ID, City, State, Postal Code, Region, Product ID, Category, Sub-Category, Product Name, Sales, Quantity, Discount, and Profit.

---

## 🛠 Tools Used

* **Power BI Desktop**: For data visualization and report generation.
* **Microsoft Power Query**: For data cleaning and transformation within Power BI.
* **Microsoft Excel**: For initial data inspection and validation.
* **PostgreSQL**: To provide answers to all 25 Capstone Project Questions
* **DAX (Data Analysis Expressions)**
* **GitHub**: For hosting the analysis, dataset, and documentation.

---

## 🧹 Data Cleaning and Preparation
The dataset was cleaned and transformed using Power Query in Power BI to ensure data quality and consistency. Below are the steps taken:
1. **Initial Inspection**:
   - Loaded all excel files: `2014 Sales Records.xlsx`, `2015 Sales Records.xlsx`, `2016 Sales Records.xlsx`, `2017 Sales Records.xlsx` into Power BI and appended them using the inbuilt Power Query to create new table `Sales Table`. The table was extracted and renamed as `All Sales Records_PBI.xlsx` after cleaning.
   - Checked for missing values, duplicates, and inconsistencies.
   - Identified 23 columns and 9,994 rows.
2. **Data Transformation**:
   - **Ignored Unnecessary Columns**: Dropped `Location ID` as it duplicated information already present in `City`, `State`, and `Postal Code`.
   - **Trimmed and Cleaned Text**:
     - Removed leading/trailing spaces in `Customer Name`, `Sales Rep`, `Sales Team`, and `Product Name`.
     - Standardized `Ship Mode` values (e.g., "Standard Class" was consistent).
3. **Data Validation**:
   - In Power Query:  
     - Selected `Order Date` and `Ship Date` columns were changed to **Date** data type.  
     - Ensured format consistency (e.g., “Monday, September 29, 2014” ==> `2014‐09‐29`).  
   - **Convert Numeric Columns**  
     - `Sales`, `Quantity`, `Discount`, `Profit` were set to numeric / decimal data types.  
     - `Postal Code` sometimes loaded as numeric was converted to **Text** (to preserve leading zeros for ZIP codes like “04567”).  
   - **Categorical Columns**  
     - Confirmed `Segment` only had {Consumer, Corporate, Home Office} and that `Category` had {Furniture, Office Supplies, Technology}.  
     - Verified that `Sub‐Category` values matched the known set (e.g., “Chairs,” “Phones,” “Binders,” etc.).
4. **Final Output**:
   - Closed and Applied the cleaned dataset `Sales Table` as a Power BI data model for analysis and visualization.
5. **Created Measures using DAX:**
      - Actual Revenue 
           ```DAX
           Actual Revenue = sumx(
               'Sales Table',
               'Sales Table'[Quantity]*'Sales Table'[Sales]*(1-'Sales Table'[Discount])
           ```
           > Although `Actual Revenue` Measure was created, `Total Revenue` or `Revenue` using (SUM of `Sales`) was adopted for analysis
      - Average Revenue
           ```DAX
           Average Revenue = AVERAGEX(
               'Sales Table',
               'Sales Table'[Quantity]*'Sales Table'[Sales]*(1-'Sales Table'[Discount])
           )
           ```
      - Expected Revenue 
           ```DAX
           Expected Revenue = SUMX('Sales Table','Sales Table'[Quantity]*'Sales Table'[Sales])
           ```
      - Profit Colour 
          ```DAX
          Profit Colour = IF([Total Profit]>=0,"#243782","#ff0000")
          ```
6. **Extract Date Hierarchy**  
        - `Year` = YEAR([Order Date])  
        - `Quarter` = “Q” & CEILING(MONTH([Order Date]) / 3, 1)  
        - `Month` = FORMAT([Order Date], “MMMM”)  
        - `Day` = DAY([Order Date])
7. **Splitting for Report Pages**
   - **Sales Overview Page**  
     - Used the fully cleaned dataset with all columns, plus the derived date‐hierarchy fields.  
     - Visuals:  
       - Bar chart of “Revenue” (SUM of `Sales`) by top 10 `Customer Name`.  
       - Line chart overlay: “Total Quantity”/SUM(`Quantity`) by those same customers.  
       - Map (filled or bubble map) plotting the number of unique orders by `State` and colored by `Region`.  
       - Donut chart of “Actual Revenue by Region.”  
       - Horizontal bar chart of “Total Orders by Category / Sub‐Category.”  
       - Card visuals for:  
         - **Revenue** = SUM(`Sales`)  
         - **Total Profit** = SUM(`Profit`)  
         - **Total Orders** = DISTINCTCOUNT(`Order ID`)  
       - Slicers for Year/Quarter/Month/Day, Segment, and Category (all set to “All” by default).
   - **Order Details Page**  
     - A table (matrix) listing every row (transaction) with columns:  
       - `Order ID`, `Order Date`, `Ship Date`, `Shipping Days`, `Ship Mode`,  
       - `Customer ID`, `Customer Name`, `Segment`,  
       - `City`, `State`, `Region`,  
       - `Product ID`, `Category`, `Sub‐Category`, `Product Name`,  
       - `Sales`, `Quantity`, `Discount`, `Profit`,  
       - Sortable by any field; includes the same slicers for dynamic filtering.
   - **Staff Details Page**  
     - A summarized table / matrix showing:  
       - Each `Sales Rep` → `Sales Team` → `Sales Team Manager` hierarchy.  
       - Aggregates per rep/team: SUM of `Sales`, SUM of `Profit`, COUNT of distinct `Order ID`.  
       - Card visuals for Top‐Performing Rep (highest revenue) and Top‐Performing Team Manager.  
       - Potential scatterplot: “Sales” vs. “Profit” per Rep.

---

## 🔍 Exploratory Data Analysis (EDA)
EDA was conducted to understand the dataset's structure and identify key trends before detailed analysis. The following aspects were explored:
### Overall Summary Metrics
| Metric              | Value                             |
|---------------------|-----------------------------------|
| **Total Rows**      | 9,994 transactions                |
| **Unique Orders**   | 5,009 (distinct `Order ID`)       |
| **Total Sales**   | $2,297,200.86 (SUM of `Sales`)   |
| **Total Profit**    | $286,397.02 (SUM of `Profit`)    |
| **Average Order Size** | $458.77 (Total Revenue ÷ Unique Orders) |
| **Distinct Customers** | 793 (`Customer ID` count)       |
| **Distinct Products** | 1,234 (`Product ID` count)       |
| **Timeframe**       | 2014 – 2017 (4 full years)        |

### Trend Analysis by Year

| Year | Total Revenue | Total Profit | Unique Orders |
|------|---------------|--------------|---------------|
| 2014 | $484,247.50  | $49,543.97  | 969           |
| 2015 | $470,532.51  | $61,618.60  | 1,038         |
| 2016 | $609,205.60  | $81,795.17  | 1,315         |
| 2017 | $733,215.26  | $93,439.27  | 1,687         |

- **Revenue Growth**:  
  - 2014 → 2015 saw a slight dip (–$13,714), but 2015 → 2016 jumped by +$138,673 (+29.5%), and 2016 ==> 2017 grew by +$124,010 (+20.3%).  
- **Profit Growth**:  
  - Profit climbed steadily each year, from $49.5 K in 2014 to $93.4 K in 2017 — a net +88.7%.  
- **Orders Growth**:  
  - The number of unique orders increased from 969 (2014) to 1,687 (2017), a +74% jump over the four years.  
- **Average Profit Margin** (Profit ÷ Revenue) improved from ~10.2% (2014) to ~12.7% (2017).

### Regional Performance

| Region   | Total Revenue | Total Profit | Unique Orders |
|----------|---------------|--------------|---------------|
| West     | $725,457.82  | $108,418.45 | 1,611         |
| East     | $678,781.24  | $91,522.78  | 1,401         |
| Central  | $501,239.89  | $39,706.36  | 1,175         |
| South    | $391,721.91  | $46,749.43  | 822           |

- **West Region**:  
  - Highest Sales and profit; 31.6% of total revenue, 37.9% of total profit.  
- **East Region**:  
  - Second in overall sales (29.5% of total revenue), with a slightly lower margin (profit 13.5%).  
- **Central Region**:  
  - Mid‐tier performance; 21.8% of revenue, but only 13.9% of profit (lower margin).  
- **South Region**:  
  - Lowest absolute sales (17.1% of total), but margin (profit ÷ sales) is ~11.9%, roughly in line with the overall average.

### Category & Sub-Category Performance
![Order Details](https://github.com/user-attachments/assets/ca10ce4b-2a9c-4946-88d6-9053effece87)

#### By Category

| Category         | Total Revenue | Total Profit | Unique Orders |
|------------------|---------------|--------------|---------------|
| Technology       | $836,154.03  | $145,454.95 | 1,544         |
| Furniture        | $741,999.80  | $18,451.27  | 1,764         |
| Office Supplies  | $719,047.03  | $122,490.80 | 3,742         |

- **Technology**  
  - Highest‐grossing category (36.4% of total revenue).  
  - Profit margin 17.4% (very healthy).  
  - 1,544 unique orders.  
- **Furniture**  
  - 32.3% of total revenue.  
  - Very low margin (2.5%): $18,451 profit on $742 K in sales.  
  - Possible discounting, extended ship times, or high shipping costs squeezing margins.  
- **Office Supplies**  
  - 31.3% of total revenue.  
  - Profit margin 17.0% (strong).  
  - Highest number of unique orders (3,742), indicating many small‐ticket items.

#### Top 5 Sub-Categories by Revenue

| Sub-Category    | Revenue     | Profit      | Orders |
|-----------------|-------------|-------------|--------------|
| Phones          | $330,007.10  | $44,516.25   | 889        |
| Chairs          | $328,449.13  | $26,590.15   | 617        |
| Storage         | $223,843.59  | $21,279.05   | 846        |
| Tables          | $206,965.68  | $-17,725.59  | 319        |
| Binders         | $203,412.77  | $30,221.64   | 1523       |

- Notice that **Tables** shows a disproportionately negative profit (-8.6% margin) compared to its revenue.  
- **Binders** with higher order count, deliver a strong margin (~15%).  
- **Phones, Chairs, Storage** categories each contributed between $220 K – $330 K in revenue but have mid‐range margins (10–14%).

### Top Customers

#### Top 10 Customers by Revenue

| Customer Name       | Total Revenue | Total Profit | Total Quantity |
|---------------------|---------------|--------------|----------------|
| Sean Miller         | $25,043.05   | $–1,980.74  | 50             |
| Tamara Chand        | $19,052.22   | $8,981.32   | 42             |
| Raymond Buch        | $15,117.34   | $6,976.10   | 71             |
| Tom Ashbrook        | $14,595.62   | $4,703.79   | 36             |
| Adrian Barton       | $14,473.57   | $5,444.81   | 73             |
| Ken Lonsdale        | $14,175.23   | $806.86     | 113            |
| Sanjit Chand        | $14,142.33   | $5,757.41   | 87             |
| Hunter Lopez        | $12,873.30   | $5,622.43   | 50             |
| Sanjit Engle        | $12,209.44   | $2,650.68   | 78             |
| Christopher Conant  | $12,129.07   | $2,177.05   | 34             |

- **Sean Miller** is the single largest revenue‐generating customer (~$25 K) but at a **net loss** of ~$1,980 (disproportionate discounts or high returns).  
- **Tamara Chand** contributed ~$19 K and yielded $8.9 K in profit (47% margin).  
- Several customers buy large quantities (e.g., Ken Lonsdale: 113 units, $14K revenue) but yield lower margins (only $806 profit).

### Order Destinations (Geographic)
- **State‐Level Order Counts (Top 5)**  
  1. **California (West)** – 1,021 unique orders  
  2. **New York (East)** – 562 unique orders  
  3. **Texas (Central)** – 487 unique orders  
  4. **Pennsylvania (NorthEastern)** – 288 unique orders  
  5. **Illinois (Central)** – 276 unique orders  

- **Insight**:  
  - The West region dominance is driven heavily by California.  
  - The East region sees a heavy concentration in New York and New Jersey.  
  - The Central region is split between Texas, Illinois, and Michigan.
   
---

## 📊 Detailed Data Analysis
The analysis focused on key metrics and trends, leveraging the Power BI report visualizations for insights.

### Sales vs. Profit Relationships
- **Scatterplot Analysis (Profit vs. Sales) by Product**  
  - Most **Furniture** sales cluster in the $50 – $300 range in sales but hover near zero to low‐profit.  
  - **Technology** items frequently have higher ticket prices ($500 – $2,500), with proportionally higher profits.  
  - **Office Supplies** are high‐volume (many $20 – $100 orders) with mid‐range margins.
- **Profit Margin Distribution** (by Category)  
  - **Furniture**: Mean margin 2.7%, with several negative‐profit outliers (returns, over‐discount).  
  - **Office Supplies**: Mean margin 17.0%, relatively tight distribution around mean.  
  - **Technology**: Mean margin 17.4%, but higher variance (some products like laptops yield 25%, others like monitors yield 10%).
- **Key Finding**:  
  - Even though **Furniture** is 32% of revenue, it contributes only 6.4% of total profit.  
  - Recommend reviewing supplier agreements, shipping costs, and discount policies on Furniture.
  
### Shipping Delays & Their Impact
- **Distribution of `Shipping Days`**  
  - Median shipping duration = 3 days.  
  - 75th percentile = 5 days.  
  - 5% of orders shipped same‐day or next‐day.  
  - 10% of orders took 7+ days (often Furniture items shipped via freight).
- **Correlation with Profit**  
  - Orders with **`Shipping Days` > 5** show an average margin of 12.5%. 
  - Orders with **`Shipping Days` ≤ 3** show an average margin of 14.2%. 
  - Suggests faster shipping correlates with slightly higher profitability—likely because expedited shipping fees are passed on or because late shipments incur discounts/penalties.

### Margin Analysis by Product Line
- **Top 3 High‐Margin Sub‐Categories**  
  1. **Label** – 44.4% margin  
  2. **Paper** – 43.4% margin  
  3. **Envelopes** – 42.3% margin  
- **Top 3 Low‐Margin Sub‐Categories**  
  1. **Tables** – -8.6% margin  
  2. **Bookcases** – -3% margin (some negative‐profit outliers due to returns)  
  3. **Supplies** – -2.5% margin  
- **Takeaway**:  
  - Shifting marketing focus toward **Label** and **Papers** likely yields stronger bottom‐line improvement.  
  - Consider renegotiating vendor terms or reducing Freight and Discount on **Tables**, **Bookcases** and **Supplies**.

### Seasonality & Monthly Patterns
- **Monthly Revenue by Year** (aggregated; Jan – Dec):  
  - **Peak months**: October and November consistently top (holiday/promo season).  
  - **Low months**: July and August (summer lull).  
  - Year‐over‐Year: the October 2017 peak ($90 K) was ~22% higher than October 2016 ($74 K).
- **Weekend vs. Weekday Orders**  
  - ~80% of orders are placed on weekdays (Mon–Fri); 20% on weekends.  
  - Weekend orders have a slightly lower average basket value ($420 vs. $470) but similar profit margins.
---
### Answers to Capstone Project Questions
**The following questions were also answered during the analysis using PostgreSQL:**

### Sales Performance and Profitability
1. **Which region generated the highest sales and profit during the four-year period?**
      #### SQLQuery:
      ```sql
      -- 1. Region with Highest Sales and Profit
      SELECT
         region,
         SUM(sales) AS total_sales,
         SUM(profit) AS total_profit
      FROM sales_record
      GROUP BY region
      ORDER BY total_sales DESC, total_profit DESC
      LIMIT 1;
      ```
      #### Result:
      * **West** is the top‐performing region in both total sales ($725K) and total profit ($108K).
      * It is followed by East, Central, then South.

2. **How do sales and profit vary across different segments (e.g., Consumer, Corporate, Home Office)?**
      #### SQLQuery:
      ```sql
         -- 2. Sales and Profit by Segment
      SELECT 
      	segment, 
      	SUM(sales) AS total_sales, 
      	SUM(profit) AS total_profit
      FROM sales_record
      GROUP BY segment;
      ```
      ```sql
      WITH sales_prof AS (
          SELECT 
              segment, 
              SUM(sales) AS total_sales, 
              SUM(profit) AS total_profit
          FROM sales_record
          GROUP BY segment
      )
      SELECT 
          segment, 
      	ROUND(SUM(total_profit/total_sales), 2) margins
      FROM sales_prof
      GROUP BY segment;
      ```
      #### Result:
      * **Consumer** is by far the largest segment ($1.16 M in sales, $134 K profit).
      * **Corporate** is second ($706 K sales, $91 K profit).
      * **Home Office** is smallest ($429 K sales, $60 K profit).
      * In terms of margin (Profit ÷ Sales):
        * Consumer margin ==> 12%
        * Corporate margin ==> 13%   
        * Home Office margin ==> 14% 

3. **Which product categories and sub-categories contributed the most to sales and profit?**
      #### SQLQuery:
      ```sql
      -- 3. Top Product Categories by Sales and Profit
      SELECT 
      	category, 
      	SUM(sales) AS total_sales, 
      	SUM(profit) AS total_profit,
      	ROUND(SUM(profit)/SUM(sales),3) profit_margin
      FROM sales_record
      GROUP BY category
      ORDER BY total_sales DESC
      LIMIT 5;
      ```
      ```sql
          -- Top Sub-Categories by Sales and Profit
      SELECT 
      	sub_category, 
      	SUM(sales) AS total_sales, 
      	SUM(profit) AS total_profit,
      	ROUND(SUM(profit)/SUM(sales),3) profit_margin
      FROM sales_record
      GROUP BY sub_category
      ORDER BY total_sales DESC
      LIMIT 5;
      ```
      * **Category level:** Group by `Category` - sum `Sales`, sum `Profit`.
      
      ![categories](https://github.com/user-attachments/assets/0676d8c4-d897-45d6-9277-12b4421227df)
   
      * **Sub-Category level:** Group by `Sub-Category` - sum `Sales`, sum `Profit`.
      
      ![subcategories](https://github.com/user-attachments/assets/a59883ea-c321-464c-9519-5057d5ed1f98)
   
      #### Results (top categories by sales):
      * **Technology** is #1 in both sales ($836 K) and profit ($145 K).
      * **Furniture** is #2 in sales ($742 K) but very low profit ($18 K, just 2.5% margin).
      * **Office Supplies** is #3 in sales ($719 K) and also high‐margin ($122 K profit which translate to 17%).
   
      #### Results (top sub-categories by sales):
      * **Phones**, **Chairs** and **Storage** lead in absolute sales and also carry healthy margins (8.1% – 13.5%).
      * **Tables** has relatively high sales but a negative margin (-8.6%), meaning it is dragging overall Furniture profitability down.

4. **What is the trend of average profit margins over the years?**
      #### SQLQuery:
      ```sql
      -- 4. Average Profit Margin Over Years
      SELECT 
      	EXTRACT(YEAR FROM order_date) AS year, 
      	ROUND(AVG(profit::NUMERIC / NULLIF(sales, 0)),3) AS avg_profit_margin
      FROM sales_record
      GROUP BY year
      ORDER BY year;
      ```
      #### Result:
      ![graph_visualiser-1749879468365](https://github.com/user-attachments/assets/f0353c7e-ddb5-41b0-a141-b1c33e09ab3a)
   
      * Margins stayed roughly in the 12% range, peaking slightly in 2016 to around 13%, then dipping a bit in 2017.
---
### Customer and Sales Team Analysis
6. **Who are the top 10 customers by sales and profit?**
      #### SQLQuery:
      ```sql
         -- 6. Top 10 Customers by Sales
         SELECT 
            customer_name, 
            SUM(sales) AS total_sales, 
            SUM(profit) AS total_profit
         FROM sales_record
         GROUP BY customer_name
         ORDER BY total_sales DESC
         LIMIT 10;
      ```
      ```sql
         -- Top 10 Customers by Profit
         SELECT 
            customer_name, 
            SUM(sales) AS total_sales, 
            SUM(profit) AS total_profit
         FROM sales_record
         GROUP BY customer_name
         ORDER BY total_profit DESC
         LIMIT 10;
      ```
      #### Results:
      * Top 10 customers by sales
         ![by sales](https://github.com/user-attachments/assets/c61cb091-dfd9-4191-9868-8106039d89c9)
   
      * Top 10 customers by profit
         ![by profit](https://github.com/user-attachments/assets/cdbec822-716e-45b7-9257-c1bdd7e88492)
   
      * **Insights**:
        * **Sean Miller** is #1 in sales ($25 K) but actually lost money (–$1,980) over four years (heavy discounts/returns).
        * **Tamara Chand** is the #1 profit contributor ($8,981).
  
7. **Which sales representative achieved the highest sales growth over the years?**
      #### SQLQuery:
      ```sql
         -- 7. Sales Rep with Highest Sales Growth
         WITH yearly_sales AS (
           SELECT 
             sales_rep, 
             EXTRACT(YEAR FROM order_date) AS year, 
             SUM(sales) AS total_sales
           FROM sales_record
           GROUP BY sales_rep, year
         ),
         sales_2014_2017 AS (
           SELECT
             sales_rep,
             MIN(CASE WHEN year = 2014 THEN total_sales END) AS sales_2014,
             MAX(CASE WHEN year = 2017 THEN total_sales END) AS sales_2017
           FROM yearly_sales
           WHERE year IN (2014, 2017)
           GROUP BY sales_rep
         )
         SELECT
           sales_rep,
           ROUND((sales_2017 - sales_2014) / NULLIF(sales_2014, 0), 2) AS growth_perc
         FROM sales_2014_2017
         WHERE sales_2014 IS NOT NULL AND sales_2017 IS NOT NULL
         ORDER BY growth_perc DESC
         LIMIT 1; 
      ```
      #### Results:
      ![sales rep by % growth graph_visualiser-1749764952718](https://github.com/user-attachments/assets/a0befb95-ae52-45df-9bc9-276925ed275b)

      * **Stella Given** achieved the highest sales growth over the years
      * **Stella Given**, **Sheila Stones** and **Mary Gerrard** grew their total annual sales from very small bases in 2014 to much larger numbers in 2017 (+387%, +284% and +220% respectively).
         * Among reps who had decent volume in 2017, **Jimmy Grey**, **Alan Ray**, and **Anne Wu** also show strong double‐digit year-over-year compound growth.

9. **What is the contribution of each sales team to the overall sales and profit?**
      #### SQLQuery:
      ```sql
      -- 8. Sales Team Contribution
      SELECT 
      	sales_team, 
      	SUM(sales) AS total_sales, 
      	SUM(profit) AS total_profit
      FROM sales_record
      GROUP BY sales_team
      ORDER BY total_profit DESC;
      ```
      #### Result:
      ![Screenshot 2025-06-12 222850](https://github.com/user-attachments/assets/5dedc081-a9f5-4962-9a70-56e092735067)
   
      ![graph_visualiser-1749753959690](https://github.com/user-attachments/assets/493e0ede-71b5-4170-b061-faa9f28f8ab6)
   
      * **Conclusion**:
        * **Organic** ($1.4 M sales, $183 K profit) is the top team.
        * **Bravo** ($220 K sales, $34 K profit) and **Delta** ($234 K, \$27 K) follow.
        * **Charlie** is slightly smaller ($235 K, $21 K).
        * Overall, the **Organic** teams contributed over 60% of total sales.

10. **Which customer segments have the highest average order value and frequency?**
      #### SQLQuery:
      ```sql
      -- 9. Segment with Highest Average Order Value and Frequency
      SELECT segment, 
      	ROUND(AVG(sales),2) AS avg_order_value, 
      	COUNT(DISTINCT order_id) AS order_frequency
      FROM sales_record
      GROUP BY segment;
      ```

      #### Result:
      ![image](https://github.com/user-attachments/assets/c1fd6d74-adbf-41e3-a373-17a64482cc28)
      > (From `segment_orders`. “# Orders” is simply the count of distinct `Order ID` in each segment.)

      ![graph_visualiser-1749769663859](https://github.com/user-attachments/assets/6dcaebf9-2658-44ab-9bd4-9e68eef16c7a)

      * **Conclusion**:
        * **Consumer** customers place most orders in total (2,586 over four years), but with a slightly lower average order value ($223.73 avg.).
        * **Corporate** customers place lower orders (1,514) but each order is relatively large ($233.82).
        * **Home Office** is lowest in frequency (909 orders) but had the largest order value ($240.97 avg.).
---

### Shipping and Discounts
10. **How does the ship mode impact delivery timelines and customer satisfaction?**
       #### SQLQuery:
       ```sql
       -- 10. Ship Mode vs. Delivery Timelines
      SELECT 
      	ship_mode, 
      	ROUND(AVG(ship_date - order_date),2) AS avg_delivery_days,
      	COUNT(order_id) orders
      FROM sales_record
      GROUP BY ship_mode
      ORDER BY avg_delivery_days;
       ```
      #### Result:
      ![image](https://github.com/user-attachments/assets/e6fd56b1-b246-4c4e-9a87-b028b96a9288)

      * **Conclusion**:
        1. **Same Day** shipments average 0 days.
        2. **First Class** averages 2.2 days.
        3. **Second Class** averages 3.2 days.
        4. **Standard Class** averages ≈5.4 days (the slowest).
        Because we lack a direct survey of “customer satisfaction,” we can say:
           * Faster modes (Same Day / Second Class) are presumed to correlate with higher satisfaction, whereas slower modes (Standard) may correlate with reduced satisfaction—especially for high-value items.

11. **What is the effect of discounts on sales and profit by product category?**
      #### SQLQuery:
      ```SQL
      -- 11. Effect of Discounts by Category
      SELECT 
      	category, 
      	ROUND(AVG(discount),2) AS avg_discount, 
      	SUM(sales) AS total_sales, 
      	SUM(profit) AS total_profit,
      	ROUND(AVG(profit::NUMERIC / NULLIF(sales, 0)),3) AS avg_profit_margin
      FROM sales_record
      GROUP BY category;
      ```
      #### Result:
      ![image](https://github.com/user-attachments/assets/2256c83f-1f3f-4f25-b121-b8b8f29f71b7)

      * **Conclusion**:
        1. **Furniture** has by far the highest average discount (17%) and the lowest margin (3.9%).
        2. **Office Supplies** follows with an average discount of 16% but with higher margins (13.8%).
        3. **Technology** has the lowest average discount (13%) and the highest margin (15.6%)
        4. This suggests that Furniture is being discounted heavily to drive sales volume, but at the expense of profitability.
     
12. **Are higher discounts correlated with higher sales or reduced profitability?**
      #### SQLQuery:
      ```SQL
      -- 12. Correlation of Discounts with Sales/Profit
      SELECT 
      	ROUND(CORR(discount, sales)::NUMERIC, 2) AS discount_sales_corr, 
      	ROUND(CORR(discount, profit)::NUMERIC, 2) AS discount_profit_corr
      FROM sales_record;
      ```
      #### Result:
      * `Discount` vs. `Sales` correlation: **-0.03**
      * `Discount` vs. `Profit` correlation: **–0.22**
      > (From our two correlation calculations.)

      * **Interpretation**:
        1. A correlation of -0.03 implies there is almost no linear relationship between **Discount** and **Sales**. The value is very close to zero, so changes in **Discount** do not predictably relate to changes in **Sales**. In practical terms, the two variables are essentially uncorrelated.
        2. There is a weak **negative** correlation (–0.22) between discount size and profit. This means that as **Discount** increases, **Profit** tends to decrease slightly, which makes sense: higher discounts erode profit significantly.  
---
### Location-Based Insights
13. **Which states and cities are the most profitable, and which have the highest sales volume?**
      #### SQLQuery:
      ```sql
      -- 13. Most Profitable States and Cities
      -- Top 10 States by Sales and Profit 
      SELECT 
      	state, 
      	SUM(sales) AS total_sales, 
      	SUM(profit) AS total_profit,
         COUNT(order_id) orders
      FROM sales_record
      GROUP BY state
      ORDER BY total_profit DESC, total_sales DESC
      LIMIT 10;
      ```
      ```sql
      -- Top 10 Cities by Sales and Profit 
      SELECT 
      	city, 
      	SUM(sales) AS total_sales, 
      	SUM(profit) AS total_profit,
         COUNT(order_id) orders
      FROM sales_record
      GROUP BY city
      ORDER BY total_profit DESC, total_sales DESC
      LIMIT 10;
      ```

      **Top 10 States by Sales and Profit:**
      ![image](https://github.com/user-attachments/assets/da3eadcc-729a-492e-b03e-e7bdf0696661)
   
      **Top 10 Cities by Sales and Profit:**
      ![image](https://github.com/user-attachments/assets/7423d541-b9b5-4ebf-9a1a-40d3469c35ef)
   
      #### Conclusion:
      * **California (CA)** ==> highest‐revenue state ($457.7 K sales, $76.4 K profit).
      * **New York City** ==> highest‐revenue city ($256.4 K sales, $62 K profit).

14. **How do sales and profit differ by region (e.g., East, West, Central, South)?**
       > **Answer already shown in Question 1**.
       > For convenience:
      #### SQLQuery:
      ```sql
         -- 14. Sales and Profit by Region
      SELECT 
      	region, 
      	SUM(sales) AS total_sales, 
      	SUM(profit) AS total_profit
      FROM sales_record
      GROUP BY region
      ORDER BY total_profit DESC;
      ```
      ![image](https://github.com/user-attachments/assets/24ef3098-d431-49e4-bad3-5975aa4290aa)

      #### Conclusion: 
      West ≫ East ≫ Central ≫ South (in that order, by both sales and profits).

15. **Are there specific locations where certain product categories sell more?**
       #### SQLQuery:
       ```SQL
         -- 15. Category Popularity by Location
         SELECT 
         	state, 
         	category, 
         	SUM(sales) AS total_sales,
         	SUM(profit) AS total_profit,
         	COUNT(order_id) orders
         FROM sales_record
         GROUP BY state, category
         ORDER BY orders DESC 
         LIMIT 10;
       ```
      **Top‐10 (State, Category) pairs in sales:**
      ![Screenshot 2025-06-14 123252](https://github.com/user-attachments/assets/08a891d6-5359-484b-b98d-4ef10d3c7935)
   
      #### Conclusion:
      * **Technology** is strongest in CA & NY.
      * **Office Supplies** lead in TX, FL, GA, WA.
      * **Furniture** has some of its largest pockets in IL and OH (even though overall Furniture is low-margin, certain states buy more).
   ---
### Order and Product Analysis
16. **What is the average time between order date and ship date?**
      #### SQLQuery:
      ```sql
         -- 16. Average Time Between Order and Ship Date
      SELECT 
      	ROUND(AVG(ship_date - order_date),2) AS avg_days_to_ship
      FROM sales_record;
      ```
      #### Result:
      * **Average Shipping Days (All Orders)**: **3.9 days**
      * **Conclusion**: On average, it takes about **4 days** from the order date to the shipment date.

17. **Which products have the highest sales volume and profitability?**

      #### SQLQuery:
      ```sql
         -- 17. Products with Highest Sales Volume and Profit
      SELECT 
      	product_name, 
      	SUM(quantity) AS total_quantity, 
      	SUM(sales) AS total_sales, 
      	SUM(profit) AS total_profit
      FROM sales_record
      GROUP BY product_name
      ORDER BY total_sales DESC
      LIMIT 10;
      ```
      **Top 10 Products by Sales:**
      ![Screenshot 2025-06-14 125001](https://github.com/user-attachments/assets/5fff3ef2-868b-4cf1-a34d-c3fcfbe4629c)
   
      #### Conclusion:
      1. The most‐sold item in raw dollar terms is the **Canon imageCLASS 2200 Advanced Copier** ($61.5 K Sales, $25.1 K Profit).
      2. **Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind** follow closely ($27.5 K Sales, $7.8 K Profit)

18. **Are there any product categories with consistently high returns on investment?**

      #### SQLQuery:
      ```SQL
         -- 18. Product Categories with High ROI
      SELECT 
      	category, 
      	ROUND(SUM(profit) / NULLIF(SUM(sales), 0),3) AS roi
      FROM sales_record
      GROUP BY category
      ORDER BY roi DESC;
      ```
      #### Result:
      * **Technology** (17.4% ROI) and **Office Supplies** (≈17.0%) are consistently high‐ROI categories.
      * **Furniture** is by far the lowest (≈2.5%).
---

### Trends and Comparisons
19. **How do sales and profits compare month by month across the years?**
      #### SQLQuery:
      ```sql
         -- 19. Monthly Sales and Profit Trends
      SELECT 
          EXTRACT(YEAR FROM order_date) AS year, 
          EXTRACT(MONTH FROM order_date) AS month_num,
          TO_CHAR(order_date, 'Month') AS month, 
          SUM(sales) AS total_sales, 
          SUM(profit) AS total_profit
      FROM sales_record
      GROUP BY year, month_num, month
      ORDER BY year, month_num;
      ```
      ```sql
         --- Excerpt from the full Monthly Sales and Profit Trends
      SELECT 
          EXTRACT(YEAR FROM order_date) AS year, 
          EXTRACT(MONTH FROM order_date) AS month_num,
          TO_CHAR(order_date, 'Month') AS month, 
          SUM(sales) AS total_sales, 
          SUM(profit) AS total_profit
      FROM sales_record
      GROUP BY year, month_num, month
      HAVING 
      	EXTRACT(MONTH FROM order_date) > 9 
      	OR EXTRACT(MONTH FROM order_date) <= 2
      ORDER BY year, month_num;
      ```

      #### Sample Result (Jan., Feb., Oct. through Dec, 2014 - 2017):
      ![image](https://github.com/user-attachments/assets/a6d1295d-6759-40a5-b0a3-313ec5cb4f94)
      > (This is a small excerpt from the full `Monthly Sales and Profit Trends` table. For space reasons, a handful of months per year — especially the heavy‐volume months in Q4 were extracted and shown above)

      * **Key Observations**:
        1. **Holiday Peak (Oct/Nov/Dec)**: Strong upward trend, with a big jump in Q4 of each year.
        2. **Summer Lows (July/August)**: A smaller, steadily rising “summer lull,” but the lift from July → December is pronounced.

20. **What is the seasonal sales pattern for the different product categories?**
      #### SQLQuery:
      ```sql
         -- 20. Seasonal Sales by Category
      SELECT 
          category,
          EXTRACT(MONTH FROM order_date) AS month_num,
          TO_CHAR(order_date, 'FMMonth') AS month,  
          SUM(sales) AS total_sales
      FROM sales_record
      GROUP BY category, month_num, month
      ORDER BY category, month_num;
      ```
      ```sql
      --Excerpt
      SELECT 
          category,
          EXTRACT(MONTH FROM order_date) AS month_num,
          TO_CHAR(order_date, 'FMMonth') AS month,  
          SUM(sales) AS total_sales
      FROM sales_record
      WHERE category = 'Technology'
      GROUP BY category, month_num, month
      HAVING 
         EXTRACT(MONTH FROM order_date) > 9
         OR EXTRACT(MONTH FROM order_date) <= 3
      ORDER BY category, month_num;
      ```
      #### Sample Excerpt (Category = Technology):
      ![image](https://github.com/user-attachments/assets/23487a6e-8a60-4f7d-8f71-9e0f5d2004df)
      > (That is the “Seasonal Sales by Category” table for Technology. Similar tables exist for Furniture and Office Supplies.)
   
      * **Key Observations**:
      1. **Technology**: Peaks in October/November/December (holiday gift season). Lows in July/August.
      2. **Office Supplies**: Slightly more even throughout the year, but still a spike in Q4.
  
21. **Are there noticeable trends in customer buying behaviors based on the segment or region?**
      #### SQLQuery:
      ```sql
         -- 21. Segment Buying Patterns
      SELECT 
      	segment, 
      	EXTRACT(YEAR FROM order_date) AS year, 
      	COUNT(DISTINCT customer_id) AS customer_count, 
      	SUM(sales) AS total_sales,
      	SUM(profit) AS total_profit
      FROM sales_record
      GROUP BY segment, year;
      ```
      ```sql
      -- Regional Buying Patterns
      SELECT 
      	region, 
      	EXTRACT(YEAR FROM order_date) AS year, 
      	COUNT(DISTINCT customer_id) AS customer_count, 
      	SUM(sales) AS total_sales,
      	SUM(profit) AS total_profit
      FROM sales_record
      GROUP BY region, year;
   
      ```
      #### Results:
      **By Segment & Year:**
      ![image](https://github.com/user-attachments/assets/260e489f-d92f-4bcc-a3df-fae00e0a4167)
   
      **By Region & Year:**
      ![image](https://github.com/user-attachments/assets/bf8ebff0-9b61-4887-a964-42127028c7c9)
   
      * **Conclusions**:
      1. **Consumer segment** steadily grew every year, though the margin from 2016 → 2017 plateaued.
      2. **Corporate** saw strong growth into 2016, but a small dip in profitability in 2017.
      3. **Home Office** was volatile in 2015 (low), then jumped in 2016–2017.
      4. **Regionally**, West & East both grew year after year in profitability and sales respectively. Central grew in profitability until 2016, then flattened. South jumped in 2016 but dipped in profitability in 2017 despite huge sales.
---
### Advanced Insights
22. **What percentage of total sales is contributed by the top 20% of customers or products?**
      #### SQLQuery:
      ```sql
         -- 22. Top 20% Customers and Product Sales Contribution
         -- Top 20% Customers Sales Contribution
      WITH customer_sales AS (
        SELECT 
        	customer_id, 
      	SUM(sales) AS total_sales
        FROM sales_record
        GROUP BY customer_id
      ),
      ranked AS (
        SELECT *, 
        	NTILE(5) OVER (ORDER BY total_sales DESC) AS quintile
        FROM customer_sales
      )
      SELECT 
      	ROUND(100.0 * SUM(total_sales) / (SELECT SUM(sales) FROM sales_record), 2) AS top_20_pct_contribution
      FROM ranked
      WHERE quintile = 1;
      ```
      ```sql
      --  Top 20% Product Sales Contribution
      WITH customer_sales AS (
        SELECT 
        	product_name, 
      	SUM(sales) AS total_sales
        FROM sales_record
        GROUP BY product_name
        ORDER BY total_sales DESC
      ),
      ranked AS (
        SELECT *, 
        	NTILE(5) OVER (ORDER BY total_sales DESC) AS quintile
        FROM customer_sales
      )
      SELECT 
      	ROUND(100.0 * SUM(total_sales) / (SELECT SUM(sales) FROM sales_record), 2) AS top_20_pct_contribution
      FROM ranked
      WHERE quintile = 1;
      ```
   
      #### Result, Customers:
      * It turns out that **48.2%** of Total Sales was contributed by 20% of the customers. In other words, the top 20% of customers produce 48.2% of total revenue.
      #### Result, Products:
      * **Top 20% of products** generated **76.9%** of overall sales.

23. **Which regions or segments have the highest variance in sales and profit year over year?**
      #### SQLQuery:
      ```SQL
      -- 23. Region/Segment Sales and Profit Variance Year over Year
      -- Segment Sales and Profit Variance Year over Year
      WITH yearly_sales AS (
          SELECT
              segment,
              EXTRACT(YEAR FROM order_date) AS year,
              SUM(sales) AS total_sales,
      		SUM(profit) AS total_profit
          FROM sales_record
          GROUP BY segment, year
      )
      SELECT
          segment,
          ROUND(VARIANCE(total_sales),2) AS sales_variance,
          ROUND(VARIANCE(total_profit),2) AS profit_variance
      FROM yearly_sales
      GROUP BY segment
      ORDER BY sales_variance DESC
      LIMIT 1;
      ```
      ```SQL
      -- Region Sales & Profit Variance Year over Year 
      WITH yearly_sales AS (
          SELECT
              region,
              EXTRACT(YEAR FROM order_date) AS year,
              SUM(sales) AS total_sales,
      		SUM(profit) AS total_profit
          FROM sales_record
          GROUP BY region, year
      )
      SELECT
          region,
          ROUND(VARIANCE(total_sales),2) AS sales_variance,
          ROUND(VARIANCE(total_profit),2) AS profit_variance
      FROM yearly_sales
      GROUP BY region
      ORDER BY sales_variance DESC
      LIMIT 1;
   
      ```
   
      #### Result:
      **Region Variance (4-year Sales/Profit):**
      ![image](https://github.com/user-attachments/assets/ef1b9f71-a038-4657-a50a-93ef3ffe51dd)
      
      **Segment Variance (4-year Sales/Profit):**
      ![image](https://github.com/user-attachments/assets/af34be31-bc0e-4478-bba6-e92f547e1a85)
      > (These are illustrative numeric variances from `Region/Segment Sales & Profit Variance` table.)
   
      * **Conclusion**:
        1. Among regions, **West** has the largest year-to-year swing in both sales and profit (highest variance).
        2. Among segments, **Corporate** shows the greatest variance.
        3. **Home Office** also has notable variance.

24. **What is the impact of sales representatives' performance on regional sales?**
   #### SQLQuery:
   ```sql
      -- 24. Sales Rep Impact on Regional Sales (Top 3 by region)
   SELECT 
   	region, 
   	sales_rep, 
   	total_sales, 
   	total_profit
   FROM (
       SELECT 
           region, 
           sales_rep, 
           SUM(sales) AS total_sales,
           SUM(profit) AS total_profit,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS rn
       FROM sales_record
       GROUP BY region, sales_rep
   ) ranked
   WHERE rn <= 3
   ORDER BY region, total_sales DESC;
   ```
   
   #### Top 3 Reps by Region:
   ![image](https://github.com/user-attachments/assets/a9914e08-b996-44fa-b80d-5e92c30f60d0)

   * **Impact**:
     1. **Organic** consistently appear at the top across all regions.
     2. **Stella Given** maintain second positions in the East and West regions.
     3. Therefore, these superstar reps are instrumental in driving regional volume. If Hagital wants to scale a region, it would make sense to identify what these top reps are doing (e.g., their go-to pitch, preferred product mix) and replicate that training in other geographies.

25. **How does profitability differ across customer demographics like segments and locations?**
      #### SQLQuery:
      ```sql
      -- 25. Profitability Across Segments and Locations
      SELECT 
      	segment, 
      	region, 
      	SUM(profit) AS total_profit, 
      	ROUND(AVG(100 * profit / NULLIF(sales, 0)),2) AS avg_profit_margin
      FROM sales_record
      GROUP BY segment, region
      ORDER BY segment, total_profit DESC;
      ```
      #### Result:
      ![image](https://github.com/user-attachments/assets/7cb80809-7d9c-4e64-b0b3-ead37d38bc86)
   
      * **Conclusions**:
        1. **Home Office in the West** has the highest avg. profit margin (22.5%).
        2. The **Central** region has the lowest performance across all segments with negative avg. profit margins (-14.17% in Consumer segment, -8.36% in Corporate and -3.16% in Home Office).
        3. **West** region tends to hover around 21–22.5%% margin regardless of segment, with the best margin across all segments.
---

## 🧾 Results and Key Findings 
1. **Sales & Profitability Trends**  
   - **Steady growth**: Revenue grew from $484 K (2014) to $733 K (2017) (+51.4%).  
   - Profit grew even faster (+88.7%), indicating gradual margin improvement.  
   - Orders increased by ~74% (969 ==> 1,687), suggesting strong market expansion.
   - **Improving margins**: Average profit margin rose from 10.2% in 2014 to 12.7% in 2017.
   - **Revenue seasonality**: October–December consistently see peak sales, especially for Technology products.

2. **Regional Performance**  
   - West region accounts for ~31.6% of all sales and ~37.9% of profits.  
   - California alone drives ~8% of total orders.
   - **South region** lags behind in revenue but maintains average profit margins.
   - **Central region** shows weak profit generation and even negative margins in some segments.

3. **Product-Level Insights**  
   - **Furniture** yields low returns (2.5% margin), with high discounts and negative profit from sub-categories like Tables.  
   - Conversely, **Technology** and **Office Supplies** are top contributors to profit with high ROI, each deliver ~17% average margin.  

4. **Customer Analysis**  
   - **Sean Miller** is the highest-revenue customer but unprofitable (net loss: –$1,980).
   - **Tamara Chand** offers a model profile: high revenue and high margin (47% profit rate).
   - The **top 20% of customers** generate **48.2%** of total revenue.

5. **Staff Productivity**  
   - The **Organic team** delivers 60% of sales and dominates profitability.
   - **Stella Given** achieved the highest sales growth (+387%) over four years.
   - Top-performing reps are clustered in the West and East regions.

6. **Shipping Duration Impacts Profit**  
   - Orders shipped in ≤ 3 days yield ~14.2% margin vs. ~12.5% for > 5 days.
   - **Standard Class** has the slowest delivery times (~5.4 days).
   - Suggests optimizing logistics and negotiating better freight rates for slower shipments (especially Furniture).

7. **Seasonality Obvious**  
   - October / November is the busiest season (holiday ordering).  
   - Consider early fall promotions to push orders into October, capturing higher‐value spend.

8. **Discount Strategy**
   - **Furniture** is over-discounted and under-profitable.
   - Weak **negative correlation** between discount and profit (–0.22); no clear link to increased sales.
   - Suggests discounting is hurting margins more than it's helping volume.

9. Concentration of Sales & Products
   - Top 20% of customers account for ~48% of revenue; top 20% of products drive ~77% of sales, revealing both customer and SKU concentration risks and opportunities     
---

## ✅ Recommendations
1. **Reevaluate Furniture Product Strategy**  
   - Renegotiate with furniture vendors to secure better COGS (cost of goods sold).  
   - Introduce adjustable freight fees (or pass through shipping surcharges) to protect margins.  
   - Focus marketing and cross-sell efforts away from loss-leader items.

2. **Scale High-ROI Product Lines**  
   - Invest in targeted marketing campaigns for Phones, Office Machines, and Accessories.  
   - Prioritize **Technology** and **Office Supplies** (especially sub-categories like Labels, Paper, Phones).
   - Encourage bundling of high-margin items in promotions.

3. **Target High-Value Customers**   
   - For top‐profiting customers (e.g., Tamara Chand), provide premium support, priority shipping, and loyalty rewards to sustain growth.
   - Build loyalty programs and offer tailored promotions to top 20% customers.
   - Investigate why high-revenue customers like Sean Miller are yielding losses.

4. **Improve Shipping Efficiency**  
   - Promote **First Class or Same Day** shipping for premium segments or high-ticket items. 
   - For slow‐moving lines (Furniture, Bookcases), evaluate alternate carriers or local warehousing for faster last‐mile delivery.  
   - Partner with logistics providers to reduce lead time and optimize freight for Furniture.

5. **Optimize Regional Operations**
   - Expand in **West and East**, which show the highest returns.
   - Reassess **Central region** operations; explore root causes of sustained low/negative profitability.

6. **Rationalize Discounting**
   - Shift from blanket discounts to **data-driven promotions** focused on seasonality or stock turnover.
   - Monitor and limit discounts that erode profit, especially on already low-margin categories.

7. **Seasonal Promotions**  
   - Pre‐holiday flash sales in September to stimulate early orders.  
   - Create “bundle deals” around October / November when customer willingness to spend is highest.  
   - Use email and social media campaigns to drive traffic during historically low months (July / August).

8. **Empower Sales Reps & Teams**  
   - Document best practices from the top 3 reps (e.g., email templates, outreach scripts, client engagement).  
   - Introduce a quarterly “Sales Champion” program with performance‐based bonuses.  
   - Provide regular training on cross‐selling high‐margin items and avoiding discount overuse.

9. **Address Concentration Risk**
   - Diversify customer base by identifying mid-tier accounts and upselling them on high-ROI products.
   - Expand SKU portfolio judiciously: introduce complementary high-margin items to mitigate reliance on the top 20% of products.
---

## ⚠️ Limitations
1. **Timeframe Restricted to 2014–2017**  
   - No data beyond 2017 → unable to assess post-2017 trends, market shifts, or impacts of new competitors.  

2. **Lack of External Factors**: No integration of economic or seasonal variables 

3. **No Customer Transaction Cost Data**  
   - We lack direct COGS per product line; profit is only “Revenue – Sales Return – Discount” but does not account for warehousing or marketing spend.  
   - True net margins (after overhead, marketing, storage fees) would be lower.

4. **Missing Customer Feedback**: No sentiment data or customer satisfaction metrics

---

## 📚 References

* [Microsoft Power BI Documentation](https://docs.microsoft.com/en-us/power-bi/)
* Source File: `All Sales Records_PBI.xlsx`
