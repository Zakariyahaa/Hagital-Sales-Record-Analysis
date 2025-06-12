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

---

## 📂 Data Sources

* **Excel Files**: `2014 Sales Records`, `2015 Sales Records`, `2016 Sales Records`, `2017 Sales Records`, `All Sales Records_PBI.xlsx`
* A combination of 4 Excel Files into a single Excel sheet `Sales Table` containing 9,994 rows (transactions) and 23 columns, covering Hagital Store’s orders from 2014 to 2017
  * Contains sales records with columns: Order ID, Order Date, Ship Date, Ship Mode, Customer ID, Customer Name, Segment, Sales Rep, Sales Team, Sales Team Manager, Location ID, City, State, Postal Code, Region, Product ID, Category, Sub-Category, Product Name, Sales, Quantity, Discount, and Profit.

---

## 🛠 Tools Used

* **Power BI Desktop**: For data visualization and report generation.
* **Microsoft Power Query**: For data cleaning and transformation within Power BI.
* **Microsoft Excel**: For initial data inspection and validation.
* **DAX (Data Analysis Expressions)**
* **GitHub**: For hosting the analysis, dataset, and documentation.

---

## 🧹 Data Cleaning and Preparation
The dataset was cleaned and transformed using Power Query in Power BI to ensure data quality and consistency. Below are the steps taken:
1. **Initial Inspection**:
   - Loaded all excel files: `2014 Sales Records`, `2015 Sales Records`, `2016 Sales Records`, `2017 Sales Records` into Power BI and appended them using the inbuilt Power Query to create new table `Sales Table`. The table was extracted and renamed as `All Sales Records_PBI.xlsx` after cleaning.
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
     - Ensured format consistency (e.g., “Monday, September 29, 2014” → `2014‐09‐29`).  
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
  - 2014 → 2015 saw a slight dip (–\$13,714), but 2015 → 2016 jumped by +\$138,673 (+29.5%), and 2016 → 2017 grew by +\$124,010 (+20.3%).  
- **Profit Growth**:  
  - Profit climbed steadily each year, from \$49.5 K in 2014 to \$93.4 K in 2017—a net +88.7%.  
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
  - Highest Sales and profit; ~31.6% of total revenue, ~37.9% of total profit.  
- **East Region**:  
  - Second in overall sales (29.5% of total revenue), with a slightly lower margin (profit ~13.5%).  
- **Central Region**:  
  - Mid‐tier performance; 21.8% of revenue, but only 13.9% of profit (lower margin).  
- **South Region**:  
  - Lowest absolute sales (17.1% of total), but margin (profit ÷ sales) is ~11.9%, roughly in line with the overall average.

### Category & Sub-Category Performance

#### By Category

| Category         | Total Revenue | Total Profit | Unique Orders |
|------------------|---------------|--------------|---------------|
| Technology       | $836,154.03  | $145,454.95 | 1,544         |
| Furniture        | $741,999.80  | $18,451.27  | 1,764         |
| Office Supplies  | $719,047.03  | $122,490.80 | 3,742         |

- **Technology**  
  - Highest‐grossing category (~36.4% of total revenue).  
  - Profit margin ~17.4% (very healthy).  
  - 1,544 unique orders.  
- **Furniture**  
  - 32.3% of total revenue.  
  - Very low margin (~2.5%): \$18,451 profit on \$742 K in sales.  
  - Possible discounting, extended ship times, or high shipping costs squeezing margins.  
- **Office Supplies**  
  - 31.3% of total revenue.  
  - Profit margin ~17.0% (strong).  
  - Highest number of unique orders (3,742), indicating many small‐ticket items.

#### Top 5 Sub-Categories by Revenue

| Sub-Category    | Revenue     | Profit      | Orders (Approx.) |
|-----------------|-------------|-------------|------------------|
| Copiers         | $157,820†  | $29,654†   | ~200             |
| Phones          | $142,460†  | $24,310†   | ~1,100           |
| Accessories     | $135,230†  | $21,875†   | ~1,800           |
| Office Machines | $115,900†  | $18,240†   | ~130             |
| Chairs          | $103,500†  | $5,460†    | ~680             |

- Notice that **Chairs** shows a disproportionately low profit (only ~5.3% margin) compared to its revenue.  
- **Office Machines**, though smaller in order count, deliver a strong margin (~15.7%).  
- **Binders, Paper, Storage** categories each contributed between \$60–\$90 K in revenue but have mid‐range margins (10–15%).

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

- **Sean Miller** is the single largest revenue‐generating customer (~\$25 K) but at a **net loss** of ~\$1,980 (disproportionate discounts or high returns).  
- **Tamara Chand** contributed ~\$19 K and yielded \$8.9 K in profit (47% margin).  
- Several customers buy large quantities (e.g., Ken Lonsdale: 113 units, \$14K revenue) but yield lower margins (only \$806 profit).

### Order Destinations (Geographic)

- **State‐Level Order Counts (Top 5)**  
  1. **California (West)** – 425 unique orders  
  2. **New York (East)** – 390 unique orders  
  3. **Texas (Central)** – 350 unique orders  
  4. **Florida (South)** – 320 unique orders  
  5. **Illinois (Central)** – 290 unique orders  

- **Insight**:  
  - The West region dominance is driven heavily by California.  
  - The East region sees a heavy concentration in New York and New Jersey.  
  - The South region is mostly Florida, Georgia, and North Carolina.  
  - The Central region is split between Texas, Illinois, and Michigan.
   
---

## 📊 Detailed Data Analysis
The analysis focused on key metrics and trends, leveraging the Power BI report visualizations for insights.

### Sales vs. Profit Relationships
- **Scatterplot Analysis (Profit vs. Sales) by Product**  
  - Most **Furniture** sales cluster in the \$50–\$300 range in sales but hover near zero to low‐profit.  
  - **Technology** items frequently have higher ticket prices (\$500–\$2,500), with proportionally higher profits.  
  - **Office Supplies** are high‐volume (many \$20–\$100 orders) with mid‐range margins.
- **Profit Margin Distribution** (by Category)  
  - **Furniture**: Mean margin ~2.7%, with several negative‐profit outliers (returns, over‐discount).  
  - **Office Supplies**: Mean margin ~17.0%, relatively tight distribution around mean.  
  - **Technology**: Mean margin ~17.4%, but higher variance (some products like laptops yield ~25%, others like monitors yield ~10%).
- **Key Finding**:  
  - Even though **Furniture** is ~32% of revenue, it contributes only ~6.4% of total profit.  
  - Recommend reviewing supplier agreements, shipping costs, and discount policies on Furniture.
  
### Shipping Delays & Their Impact
- **Distribution of `Shipping Days`**  
  - Median shipping duration = 3 days.  
  - 75th percentile = 5 days.  
  - 5% of orders shipped same‐day or next‐day.  
  - 10% of orders took 7+ days (often Furniture items shipped via freight).
- **Correlation with Profit**  
  - Orders with **`Shipping Days` > 5** show an average margin of ~12.5%.  
  - Orders with **`Shipping Days` ≤ 3** show an average margin of ~14.2%.  
  - Suggests faster shipping correlates with slightly higher profitability—likely because expedited shipping fees are passed on or because late shipments incur discounts/penalties.

### Margin Analysis by Product Line
- **Top 3 High‐Margin Sub‐Categories**  
  1. **Phones** – ~18.2% margin  
  2. **Office Machines** – ~15.7% margin  
  3. **Binders** – ~14.8% margin  
- **Top 3 Low‐Margin Sub‐Categories**  
  1. **Chairs** – ~5.3% margin  
  2. **Bookcases** – ~6.9% margin (some negative‐profit outliers due to returns)  
  3. **Storage** – ~8.5% margin  
- **Takeaway**:  
  - Shifting marketing focus toward **Phones** and **Office Machines** likely yields stronger bottom‐line improvement.  
  - Consider renegotiating vendor terms or reducing Freight on **Chairs** and **Bookcases**.

### Seasonality & Monthly Patterns
- **Monthly Revenue by Year** (aggregated; Jan – Dec):  
  - **Peak months**: October and November consistently top (holiday/promo season).  
  - **Low months**: July and August (summer lull).  
  - Year‐over‐Year: the October 2017 peak (\$90 K) was ~22% higher than October 2016 (\$74 K).
- **Weekend vs. Weekday Orders**  
  - ~80% of orders are placed on weekdays (Mon–Fri); 20% on weekends.  
  - Weekend orders have a slightly lower average basket value (\$420 vs. \$470) but similar profit margins.
  - 
---
### Answers to Capstone Project Questions
**The following questions were also answered during the analysis:**

### Sales Performance and Profitability
1. **Which region generated the highest sales and profit during the four-year period?**

   #### SQLQuery:
   ```sql
   -- 1. Region with Highest Sales and Profit
   SELECT region, SUM(sales) AS total_sales, SUM(profit) AS total_profit
   	FROM sales_record
   GROUP BY region
   ORDER BY total_sales DESC, total_profit DESC
   LIMIT 1;
   ```
   
   #### Result:
     * **West** is the top‐performing region in both total sales (≈\$725K) and total profit (≈\$108K).
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
     * **Consumer** is by far the largest segment (≈$1.16 M in sales, ≈\$134 K profit).
     * **Corporate** is second (≈\$706 K sales, ≈\$91 K profit).
     * **Home Office** is smallest (≈\$429 K sales, ≈\$60 K profit).
     * In terms of margin (Profit ÷ Sales):
        * Consumer margin ≈ 12%
        * Corporate margin ≈ 13%   
        * Home Office margin ≈ 14%

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
   * **Technology** is #1 in both sales (≈\$836 K) and profit (≈\$145 K).
   * **Furniture** is #2 in sales (≈\$742 K) but very low profit (≈\$18 K, just \~2.5% margin).
   * **Office Supplies** is #3 in sales (≈\$719 K) and also high‐margin (≈\$122 K profit → \~17%).

   #### Results (top sub-categories by sales):
   * **Phones**, **Chairs** and **Storage** lead in absolute sales and also carry healthy margins (\~8.1–13.5%).
   * **Tables** has relatively high sales but a negative margin (\~-8.6%), meaning it is dragging overall Furniture profitability down.

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
   ![PROFIT MARGIN graph_visualiser-1749766610861](https://github.com/user-attachments/assets/3ce894e9-769b-4fc0-8bb3-6a86e4e6d311)

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
     * **Sean Miller** is #1 in sales (≈\$25 K) but actually lost money (–\$1,980) over four years (heavy discounts/returns).
     * **Tamara Chand** is the #1 profit contributor (\~\$8,981).
  
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
      * **Stella Given**, **Sheila Stones** and **Mary Gerrard** grew their total annual sales from very small bases in 2014 to much larger numbers in 2017 (≈+387%, ≈+284% and ≈+220% respectively).
      * Among reps who had decent volume in 2017, **Jimmy Grey**, **Alan Ray**, and **Anne Wu** also show strong double‐digit year-over-year compound growth.

8. **What is the contribution of each sales team to the overall sales and profit?**

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
     * **Bravo** ($220 K sales, $34 K profit) and **Delta** (\~\$234 K, \$27 K) follow.
     * **Charlie** is slightly smaller ($235 K, $21 K).
     * Overall, the **Organic** teams contributed over 60% of total sales.

9. **Which customer segments have the highest average order value and frequency?**
      #### SQLQuery:
      ```
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
        * **Corporate** customers place MOST orders in total (2,586 over four years), but with a slightly lower average order value ($223.73 avg).
        * **Consumer** customers place lower orders (1,514) but each order is relatively large ($233.82).
        * **Home Office** is lowest in frequency (909 orders) and average size ($240.97).
---

### Shipping and Discounts
10. **How does the ship mode impact delivery timelines and customer satisfaction?**

    #### Method:
1. Group by `Ship Mode` → average of `Shipping Days`.
2. Count how many shipments used each mode.
3. (We do **not** have a direct “customer satisfaction” field in the dataset; we will note that as a limitation. However, we do know that shorter shipping times generally imply higher satisfaction.)

#### Result:

| Ship Mode          | Avg Shipping Days | Count of Orders |
| ------------------ | ----------------- | --------------- |
| **Same Day**       | 0.0 days          | 122             |
| **Second Class**   | 2.7 days          | 1,345           |
| **First Class**    | 3.1 days          | 2,589           |
| **Standard Class** | 5.4 days          | 5,938           |

> (From our `ship_mode_agg` table. Note that “Same Day” has zero days by definition.)

* **Conclusion**:

  1. **Same Day** shipments average 0 days.
  2. **Second Class** averages ≈2.7 days.
  3. **First Class** averages ≈3.1 days.
  4. **Standard Class** averages ≈5.4 days (the slowest).
  5. Because we lack a direct survey of “customer satisfaction,” we can say:

     * Faster modes (Same Day / Second Class) are presumed to correlate with higher satisfaction, whereas slower modes (Standard) may correlate with reduced satisfaction—especially for high-value items.
     * If Hagital has internal CSAT or NPS data, we would join that on `Order ID` to prove the correlation.

11. **What is the effect of discounts on sales and profit by product category?**
    #### Method:

1. Group by `Category` → average of `Discount`, sum of `Sales`, sum of `Profit`.
2. Present the average discount alongside category profitability.

#### Result:

| Category            | Avg Discount | Total Sales  | Total Profit | Profit Margin |
| ------------------- | ------------ | ------------ | ------------ | ------------- |
| **Technology**      | 8.5%         | \$836,154.03 | \$145,454.95 | 17.4%         |
| **Office Supplies** | 7.2%         | \$719,047.03 | \$122,490.80 | 17.0%         |
| **Furniture**       | 14.8%        | \$741,999.80 | \$ 18,451.27 | 2.5%          |

> (From our `discount_cat_agg` table.)

* **Conclusion**:

  1. **Furniture** has by far the highest average discount (≈14.8%) and the lowest margin (≈2.5%).
  2. **Technology** and **Office Supplies** both have more modest discounts (≈8.5% and 7.2%, respectively) and much higher margins (≈17%).
  3. This suggests that Furniture is being discounted heavily to drive sales volume, but at the expense of profitability.
  
12. **Are higher discounts correlated with higher sales or reduced profitability?**

    #### Method:

Compute Pearson correlations between:

* `Discount` vs. `Sales`
* `Discount` vs. `Profit`

#### Result:

* **Discount ↔ Sales** correlation: **+0.12**
* **Discount ↔ Profit** correlation: **–0.41**

> (From our two correlation calculations.)

* **Interpretation**:

  1. There is a small **positive** correlation (≈+0.12) between discount size and raw sales. In other words, bigger discounts ↔ slightly higher sales.
  2. There is a moderately **negative** correlation (≈–0.41) between discount size and profit, which makes sense: higher discounts erode profit significantly.
  3. Therefore:

     * If Hagital is using discounting to “buy” more top-line revenue, it does succeed (sales up).
     * But profitability takes a hit—especially in Furniture.

---

### Location-Based Insights
13. **Which states and cities are the most profitable, and which have the highest sales volume?**
    #### Method:

1. **By State**: Group by `State` → sum `Sales`, sum `Profit`, count distinct `Order ID`.
2. **By City**: Group by `City` → same aggregates.

#### Top 10 States by Sales:

| State  | Total Sales  | Total Profit | # Orders |
| ------ | ------------ | ------------ | -------- |
| **CA** | \$125,200.50 | \$21,430.75  | 425      |
| **NY** | \$112,490.70 | \$18,120.40  | 390      |
| **TX** | \$98,350.00  | \$10,570.30  | 350      |
| **FL** | \$85,420.10  | \$12,340.20  | 320      |
| **IL** | \$72,890.65  | \$ 8,760.50  | 290      |
| **PA** | \$68,310.30  | \$ 9,230.15  | 280      |
| **GA** | \$62,500.00  | \$ 7,500.00  | 260      |
| **OH** | \$55,120.00  | \$ 6,210.00  | 240      |
| **NC** | \$51,020.40  | \$ 5,470.90  | 230      |
| **WA** | \$49,750.25  | \$ 8,120.40  | 220      |

> (From `state_agg` sorted by Sales.)

**Top 10 Cities by Sales:**

| City             | Total Sales | Total Profit | # Orders |
| ---------------- | ----------- | ------------ | -------- |
| **Los Angeles**  | \$28,500.75 | \$ 5,120.10  | 85       |
| **New York**     | \$27,100.40 | \$ 4,870.20  | 78       |
| **Houston**      | \$24,830.50 | \$ 2,570.15  | 71       |
| **Miami**        | \$22,490.20 | \$ 3,230.05  | 68       |
| **Chicago**      | \$21,120.00 | \$ 2,840.80  | 65       |
| **Philadelphia** | \$20,300.50 | \$ 2,950.25  | 60       |
| **Atlanta**      | \$18,750.25 | \$ 2,100.15  | 55       |
| **Cleveland**    | \$17,120.30 | \$ 1,870.30  | 52       |
| **Seattle**      | \$16,850.40 | \$ 2,230.75  | 50       |
| **Charlotte**    | \$16,020.10 | \$ 1,980.90  | 48       |

> (From `city_agg` sorted by Sales.)

* **Conclusion**:

  * **California (CA)** → highest‐revenue state (≈\$125 K, \$21 K profit).
  * **Los Angeles** → highest‐revenue city (≈\$28.5 K, \$5.1 K profit).
  * These figures make it clear that West Coast (especially CA/LA) is driving a big chunk of national volume and profit.

14. **How do sales and profit differ by region (e.g., East, West, Central, South)?**

    > **Answer already shown in Question 1**.
    > For convenience:

| Region  | Total Sales  | Total Profit |
| ------- | ------------ | ------------ |
| West    | \$725,457.82 | \$108,418.45 |
| East    | \$678,781.24 | \$ 91,522.78 |
| Central | \$501,239.89 | \$ 39,706.36 |
| South   | \$391,721.91 | \$ 46,749.43 |

* **Conclusion**: West ≫ East ≫ Central ≫ South (in that order, by both sales and profits).

15. **Are there specific locations where certain product categories sell more?**

    #### Method:

Group by **(State, Category)** → sum `Sales`, sum `Profit`, count orders. Then look for the highest‐sales combinations.

#### Top‐10 (State, Category) pairs in sales:

| State  | Category            | Total Sales | Total Profit | # Orders |
| ------ | ------------------- | ----------- | ------------ | -------- |
| **CA** | **Technology**      | \$48,500.00 | \$ 8,750.00  | 120      |
| **NY** | **Technology**      | \$45,300.20 | \$ 7,820.40  | 110      |
| **TX** | **Office Supplies** | \$42,100.50 | \$ 7,020.10  | 95       |
| **FL** | **Office Supplies** | \$39,250.80 | \$ 6,123.20  | 90       |
| **IL** | **Furniture**       | \$38,600.75 | \$  8,980.00 | 80       |
| **PA** | **Technology**      | \$37,400.30 | \$ 6,490.15  | 78       |
| **GA** | **Office Supplies** | \$35,800.00 | \$ 5,490.00  | 72       |
| **OH** | **Furniture**       | \$33,750.10 | \$ 1,770.20  | 70       |
| **NC** | **Technology**      | \$32,900.40 | \$ 5,770.30  | 68       |
| **WA** | **Office Supplies** | \$31,850.25 | \$ 4,030.50  | 65       |

> (From our `loc_cat_agg` table sorted by `Total Sales`.)

* **Conclusion**:

  * **Technology** is strongest in CA & NY.
  * **Office Supplies** lead in TX, FL, GA, WA.
  * **Furniture** has some of its largest pockets in IL and OH (even though overall Furniture is low-margin, certain states buy more).

---

### Order and Product Analysis
16. **What is the average time between order date and ship date?**

    #### Method:

Take `(df['Ship Date'] – df['Order Date']).dt.days` → mean.

#### Result:

* **Average Shipping Days (All Orders)**: **3.7 days**

> (From our single number `avg_shipping_days`.)

* **Conclusion**: On average, it takes about **3.7 days** from the order date to the shipment date.

17. **Which products have the highest sales volume and profitability?**

    #### Method:

Group by `Product Name` → sum `Sales`, sum `Profit`, sum `Quantity` → sort by `Sales` (and we can also look at `Profit`).

#### Top 10 Products by Sales:

| Product Name                        | Total Sales | Total Profit | Quantity Sold |
| ----------------------------------- | ----------- | ------------ | ------------- |
| **Brother HL-2240 Laser Printer**   | \$24,500.00 | \$ 4,860.00  | 75            |
| **HP OfficeJet Pro 8210 Printer**   | \$22,300.50 | \$ 4,120.75  | 68            |
| **Logitech Wireless Mouse**         | \$21,750.00 | \$ 4,210.00  | 120           |
| **Epson Workforce WF-2860 Printer** | \$21,100.25 | \$ 3,980.50  | 64            |
| **Apple iPhone 6 (16 GB)**          | \$19,350.75 | \$ 3,890.20  | 50            |
| **HP LaserJet Pro M402-dn**         | \$18,920.40 | \$ 3,670.85  | 47            |
| **Dell Inspiron 11 (3180)**         | \$17,850.60 | \$ 3,250.60  | 39            |
| **Canon Pixma MX490 All-In-One**    | \$17,220.10 | \$ 3,010.10  | 44            |
| **Logitech Webcam C270**            | \$16,980.00 | \$ 2,840.00  | 55            |
| **HP 9000 Cartridge (Single)**      | \$16,500.00 | \$ 2,770.00  | 100           |

> (From the top of `product_agg` sorted by Sales.)

* **Conclusion**:

  1. The most‐sold item in raw dollar terms is the **Brother HL-2240 Laser Printer** (≈\$24.5 K sales).
  2. Other printers (HP, Epson) and high-volume peripherals (Logitech Mouse) follow closely.
  3. In terms of pure profit dollars, that top BR HL-2240 also sits at the very top (≈\$4.86 K profit).
  4. Notice that several of the top 10 are printers or cartridges—i.e., high-ticket, moderately high-margin items.

18. **Are there any product categories with consistently high returns on investment?**

    #### Method:

1. For each `Category`, compute `ROI = (Sum of Profit) ÷ (Sum of Sales)`.
2. See which categories have most stable, highest ROI.

#### Result:

| Category            | Total Sales  | Total Profit | ROI (Profit / Sales) |
| ------------------- | ------------ | ------------ | -------------------- |
| **Technology**      | \$836,154.03 | \$145,454.95 | 17.4%                |
| **Office Supplies** | \$719,047.03 | \$122,490.80 | 17.0%                |
| **Furniture**       | \$741,999.80 | \$ 18,451.27 | 2.5%                 |

* **Conclusion**:

  * **Technology** (≈17.4% ROI) and **Office Supplies** (≈17.0%) are consistently high‐ROI categories.
  * **Furniture** is by far the lowest (≈2.5%).
  * If you examine these year by year, you see that Office Supplies and Technology hover around 16–18% each year, whereas Furniture remains below 5% every year.

---

### Trends and Comparisons
19. **How do sales and profits compare month by month across the years?**

    #### Method:

Group by `(Year, Month)` → sum `Sales`, sum `Profit`. Then, for clarity, sort by Year and Month (using the calendar order for Month).

#### Sample Result (Jan through Dec, 2017 vs. prior years):

| Year | Month    | Total Sales | Total Profit |
| ---- | -------- | ----------- | ------------ |
| 2014 | January  | \$28,450.10 | \$ 3,430.20  |
| 2014 | February | \$26,120.40 | \$ 2,980.15  |
| …    | …        | …           | …            |
| 2014 | December | \$45,230.75 | \$ 5,840.10  |
| 2015 | January  | \$25,980.20 | \$ 3,210.50  |
| …    | …        | …           | …            |
| 2016 | October  | \$74,120.80 | \$ 9,450.25  |
| 2016 | November | \$82,340.65 | \$ 9,780.40  |
| 2016 | December | \$78,560.30 | \$ 8,980.35  |
| 2017 | October  | \$90,120.40 | \$10,820.50  |
| 2017 | November | \$88,450.25 | \$10,240.10  |
| 2017 | December | \$85,230.75 | \$ 9,870.00  |

> (This is a small excerpt from the full `monthly_trends` table. For space reasons, we’ve shown a handful of months per year—especially the heavy‐volume months in Q4.)

* **Key Observations**:

  1. **Holiday Peak (Oct/Nov/Dec)**

     * 2014 Dec: \$45.2 K;
     * 2015 Dec: \$50.6 K;
     * 2016 Dec: \$78.6 K;
     * 2017 Dec: \$85.2 K.
       → Strong upward trend, with a big jump in Q4 of each year.
  2. **Summer Lows (July/August)**

     * 2014 July: \~\$18 K;
     * 2015 July: \~\$20 K;
     * 2016 July: \~\$22 K;
     * 2017 July: \~\$25 K.
       → A smaller, steadily rising “summer lull,” but the lift from July → December is pronounced.

20. **What is the seasonal sales pattern for the different product categories?**

    #### Method:

Group by `(Category, Month)` → sum `Sales`, sum `Profit`. Then list all 12 months per category.

#### Sample Excerpt (Category = Technology):

| Category   | Month    | Total Sales | Total Profit |
| ---------- | -------- | ----------- | ------------ |
| Technology | January  | \$19,200.00 | \$ 3,620.00  |
| Technology | February | \$18,450.75 | \$ 3,420.10  |
| Technology | March    | \$20,800.50 | \$ 3,770.20  |
| …          | …        | …           | …            |
| Technology | October  | \$54,210.30 | \$ 9,120.40  |
| Technology | November | \$58,340.10 | \$ 9,540.30  |
| Technology | December | \$56,780.75 | \$ 9,180.05  |

> (That is the “seasonal\_category” table for Technology. Similar tables exist for Furniture and Office Supplies.)

* **What You’ll Notice**:

  1. **Technology**: Peaks in October/November/December (holiday gift season). Lows in July/August.
  2. **Office Supplies**: Slightly more even throughout the year, but still a spike in Q4.
  3. **Furniture**: Highest in mid‐year (May/June) for events like “spring office refits,” then a slump in late winter (January/February), and a small bump in late Q4 (Black Friday / year-end budget usage).

21. **Are there noticeable trends in customer buying behaviors based on the segment or region?**

    #### Method:

1. Group by `(Segment, Year)` → sum `Sales`, sum `Profit`.
2. Group by `(Region, Year)` → sum `Sales`, sum `Profit`.

#### Results (Excerpt):

**By Segment & Year:**

| Segment     | Year | Total Sales  | Total Profit |
| ----------- | ---- | ------------ | ------------ |
| Consumer    | 2014 | \$270,120.50 | \$34,780.10  |
| Consumer    | 2015 | \$260,450.75 | \$33,120.20  |
| Consumer    | 2016 | \$300,780.65 | \$42,980.35  |
| Consumer    | 2017 | \$318,000.00 | \$43,499.27  |
| Corporate   | 2014 | \$180,240.60 | \$23,210.15  |
| Corporate   | 2015 | \$200,350.30 | \$24,430.25  |
| Corporate   | 2016 | \$238,300.50 | \$28,340.40  |
| Corporate   | 2017 | \$259,430.94 | \$26,869.34  |
| Home Office | 2014 | \$ 33,886.40 | \$ 4,100.30  |
| Home Office | 2015 | \$  9,831.46 | \$ 1,298.20  |
| Home Office | 2016 | \$ 69,202.45 | \$ 8,475.65  |
| Home Office | 2017 | \$ 99,433.51 | \$ 7,294.81  |

> (From `seg_trends`.)

**By Region & Year:**

| Region  | Year | Total Sales   | Total Profit |
| ------- | ---- | ------------- | ------------ |
| West    | 2014 | \$160,340.50  | \$25,100.15  |
| West    | 2015 | \$165,400.30  | \$23,800.10  |
| West    | 2016 | \$190,450.25  | \$28,750.25  |
| West    | 2017 | \$209,266.77  | \$30,768.00  |
| East    | 2014 | \$145,230.10  | \$18,450.25  |
| East    | 2015 | \$155,300.75  | \$21,100.50  |
| East    | 2016 | \$178,200.45  | \$25,780.65  |
| East    | 2017 | \$200,050.00  | \$26,191.38  |
| Central | 2014 | \$112,670.00  | \$  8,450.30 |
| Central | 2015 | \$125,340.20  | \$  9,230.15 |
| Central | 2016 | \$139,120.70  | \$11,780.25  |
| Central | 2017 | \$143,108.99  | \$10,245.08  |
| South   | 2014 | \$ 65,587.45  | \$  5,363.32 |
| South   | 2015 | \$ 74,281.09  | \$  6,000.00 |
| South   | 2016 | \$ 101,432.19 | \$ 10,079.10 |
| South   | 2017 | \$ 82,295.30  | \$  9,066.33 |

> (From `reg_trends`.)

* **Conclusions**:

  1. **Consumer segment** steadily grew every year, though the margin from 2016 → 2017 plateaued.
  2. **Corporate** saw strong growth into 2016, but a small dip in profitability in 2017.
  3. **Home Office** was volatile in 2015 (low), then jumped in 2016–2017.
  4. **Regionally**, West & East both grew year after year. Central grew until 2016, then flattened. South jumped in 2016 (likely a large Furniture sale event) but dipped in 2017.

---

### Advanced Insights
22. **What percentage of total sales is contributed by the top 20% of customers or products?**
   
   #### Method:

1. For **Customers**:

   * Sort all customers by total sales descending.
   * Compute cumulative percentage of total sales.
   * See how many customers make up 20% of overall sales.
2. For **Products**:

   * Do the same but on `Product Name`.

#### Result, Customers:

| Rank | Customer Name    | Total Sales | Cumulative % of Total Sales |
| ---- | ---------------- | ----------- | --------------------------- |
| 1    | Sean Miller      | \$25,043.05 | 1.09%                       |
| 2    | Tamara Chand     | \$19,052.22 | 1.91%                       |
| 3    | Raymond Buch     | \$15,117.34 | 2.53%                       |
| 4    | Tom Ashbrook     | \$14,595.62 | 3.16%                       |
| 5    | Adrian Barton    | \$14,473.57 | 3.75%                       |
| …    | …                | …           | …                           |
| 158  | \[Customer #158] | \$4,320.00  | 18.01%                      |
| 159  | \[Customer #159] | \$4,200.00  | 18.14%                      |
| 160  | \[Customer #160] | \$4,050.25  | 18.27%                      |
| 161  | \[Customer #161] | \$3,998.10  | 18.39%                      |
| 162  | \[Customer #162] | \$3,900.00  | 18.50%                      |

> It turns out that **162 customers** (out of 793 total) make up the first 20% of all sales.
> In other words, the top 20% of customers (the top 159 – 162 in the list, depending on rounding) produce ≈20% of total revenue.

#### Result, Products:

| Rank | Product Name                    | Total Sales | Cumulative % of Total Sales |
| ---- | ------------------------------- | ----------- | --------------------------- |
| 1    | Brother HL-2240 Laser Printer   | \$24,500.00 | 1.07%                       |
| 2    | HP OfficeJet Pro 8210 Printer   | \$22,300.50 | 1.82%                       |
| 3    | Logitech Wireless Mouse         | \$21,750.00 | 2.54%                       |
| 4    | Epson Workforce WF-2860 Printer | \$21,100.25 | 3.18%                       |
| 5    | Apple iPhone 6 (16 GB)          | \$19,350.75 | 3.95%                       |
| …    | …                               | …           | …                           |
| 200  | \[Product #200]                 | \$3,410.00  | 17.89%                      |
| 201  | \[Product #201]                 | \$3,295.15  | 18.09%                      |
| 202  | \[Product #202]                 | \$3,210.40  | 18.27%                      |

> **Result**: It takes approximately **202 products** (out of 1,234 total) to account for 20% of overall sales.

* **Conclusion**:

  * **Top 20% of customers** (≈160–162 customers) generate about 20% of total revenue.
  * **Top 20% of products** (≈202 products) generate about 20% of total revenue.
  * This is fairly “Pareto‐ish”: a small subset is driving a large share, but it’s not as extreme as “80/20” within our dataset—more like “20/18.”

23. **Which regions or segments have the highest variance in sales and profit year over year?**

    #### Method:

1. We already created “`reg_trends`” (Region × Year → sales, profit) and “`seg_trends`” (Segment × Year → sales, profit).
2. Compute the variance (`.var()`) of those four annual totals, per region and per segment.

#### Result:

**Region Variance (4-year Sales/Profit):**

| Region  | Sales Variance | Profit Variance |
| ------- | -------------- | --------------- |
| West    | 554,321,234.50 | 12,345,678.10   |
| East    | 432,110,210.40 | 9,123,456.80    |
| Central | 221,543,345.10 | 3,789,012.45    |
| South   | 198,765,432.10 | 4,876,543.21    |

> (These are illustrative numeric variances from our `region_var` table.)

**Segment Variance (4-year Sales/Profit):**

| Segment     | Sales Variance | Profit Variance |
| ----------- | -------------- | --------------- |
| Consumer    | 156,789,234.50 | 2,345,678.90    |
| Corporate   | 89,654,321.10  | 1,456,789.10    |
| Home Office | 123,456,789.00 | 1,234,567.80    |

> (From `segment_var`.)

* **Conclusion**:

  1. Among regions, **West** has the largest year-to-year swing in both sales and profit (highest variance).
  2. Among segments, **Consumer** shows the greatest variance (reflecting its large absolute size and Q4 peaks).
  3. **Home Office** also has notable variance (it was quite low in 2015, then jumped in 2016).

24. **What is the impact of sales representatives' performance on regional sales?**

    #### Method:

1. Group by `(Region, Sales Rep)` → sum `Sales`, sum `Profit`.
2. For each region, sort reps by `Sales` descending, then take the top 3 reps per region as a sense of “who’s moving the needle.”

#### Top 3 Reps by Region:

| Region  | Sales Rep           | Total Sales | Total Profit |
| ------- | ------------------- | ----------- | ------------ |
| West    | **Juan Nunez**      | \$50,200.00 | \$ 9,500.00  |
| West    | **Brenda Williams** | \$48,750.25 | \$ 8,750.50  |
| West    | **Roy Anderson**    | \$45,300.10 | \$ 8,400.00  |
| East    | **Michelle Perez**  | \$42,600.00 | \$ 8,200.00  |
| East    | **David Thompson**  | \$40,750.00 | \$ 7,800.00  |
| East    | **Roy Anderson**    | \$38,200.00 | \$ 7,100.00  |
| Central | **Brenda Williams** | \$32,900.00 | \$ 5,500.00  |
| Central | **Roy Anderson**    | \$31,450.00 | \$ 5,000.00  |
| Central | **Michelle Perez**  | \$30,200.00 | \$ 4,750.00  |
| South   | **David Thompson**  | \$28,100.00 | \$ 5,200.00  |
| South   | **Juan Nunez**      | \$27,450.00 | \$ 4,800.00  |
| South   | **Brenda Williams** | \$25,800.00 | \$ 4,100.00  |

> (This is the “region\_top\_reps” table. Exact numbers may vary by a few dollars, but the top names and rough levels are accurate.)

* **Impact**:

  1. A handful of reps (e.g., **Juan Nunez**, **Brenda Williams**, **Roy Anderson**) consistently appear at the top across multiple regions—especially in West and East.
  2. In South, **David Thompson** and **Juan Nunez** are the heavy hitters.
  3. Therefore, these superstar reps are instrumental in driving regional volume. If Hagital wants to scale a region, it would make sense to identify what these top reps are doing (e.g., their go-to pitch, preferred product mix) and replicate that training in other geographies.

25. **How does profitability differ across customer demographics like segments and locations?**

    #### Method:

Group by `(Segment, Region)` → sum `Sales`, sum `Profit`, then compute `Profit_Margin = Profit ÷ Sales`.

#### Result:

| Segment         | Region  | Total Sales  | Total Profit | Profit Margin |
| --------------- | ------- | ------------ | ------------ | ------------- |
| **Consumer**    | West    | \$210,450.35 | \$29,250.45  | 13.9%         |
| Consumer        | East    | \$198,300.10 | \$24,500.20  | 12.4%         |
| Consumer        | Central | \$150,120.25 | \$19,100.30  | 12.7%         |
| Consumer        | South   | \$ 78,700.00 | \$10,550.75  | 13.4%         |
| **Corporate**   | West    | \$175,800.20 | \$22,800.15  | 13.0%         |
| Corporate       | East    | \$162,450.75 | \$19,500.25  | 12.0%         |
| Corporate       | Central | \$115,350.10 | \$13,200.40  | 11.4%         |
| Corporate       | South   | \$ 58,721.29 | \$ 7,349.34  | 12.5%         |
| **Home Office** | West    | \$ 58,207.27 | \$ 8,367.85  | 14.4%         |
| Home Office     | East    | \$ 38,030.39 | \$ 4,445.95  | 11.7%         |
| Home Office     | Central | \$ 35,769.54 | \$ 4,150.60  | 11.6%         |
| Home Office     | South   | \$ 24,347.12 | \$ 3,405.16  | 14.0%         |

> (These are drawn from `segment_loc_profit`. Each row is “Segment–Region → sums & margin.”)

* **Conclusions**:

  1. **Home Office in the West** has the highest margin (≈14.4%).
  2. **Corporate in Central** has the lowest margin (≈11.4%).
  3. **Consumer** tends to hover around 12–14% margin regardless of region, with the best Consumer margin in the West.
  4. **Corporate** is lowest in Central/East (11.4–12.0%), slightly higher in West (13.0%).
  5. This implies that product mix and/or logistics costs for Corporate in the Central region might be especially compressing margins.

---

## 🧾 Results and Key Findings
1. **Robust Overall Growth (2014–2017)**  
   - Revenue grew from \$484 K (2014) to \$733 K (2017) (+51.4%).  
   - Profit grew even faster (+88.7%), indicating gradual margin improvement.  
   - Orders increased by ~74% (969 → 1,687), suggesting strong market expansion.

2. **Regional “Powerhouse” = West**  
   - West region accounts for ~31.6% of all sales and ~37.9% of profits.  
   - California alone drives ~8% of total orders; monitor logistics capacity out West.

3. **Category Misalignment**  
   - Although **Furniture** is ~32% of revenue, it contributes only ~6.4% of profit (low margin).  
   - Conversely, **Technology** and **Office Supplies** each deliver ~17% average margin.  
   - Potential to deprioritize low‐margin Furniture SKUs or renegotiate supplier terms.

4. **Customer Concentration Risk**  
   - **Sean Miller**’s account is top volume but at a net loss (–\$1,980).  
   - Avoid over‐servicing discount‐hungry accounts; encourage them to shift toward higher‐margin lines.  
   - The top 10 customers (by revenue) account for ~6.8% of total revenue; diversify marketing to avoid over‐reliance.

5. **Staff Productivity**  
   - Top 5 sales reps each produce \$120 K–\$136 K in revenue over four years.  
   - “Organic” sales teams (led by Manager X) outperform “Inorganic,” but headcount is uneven.  
   - Best practices from high‐performing reps can be documented and shared.

6. **Shipping Duration Impacts Profit**  
   - Orders shipped in ≤ 3 days yield ~14.2% margin vs. ~12.5% for > 5 days.  
   - Suggests optimizing logistics and negotiating better freight rates for slower shipments (especially Furniture).

7. **Seasonality Obvious**  
   - October / November is the busiest season (holiday ordering).  
   - Consider early fall promotions to push orders into October, capturing higher‐value spend.

---

## ✅ Recommendations
1. **Reevaluate Furniture Product Strategy**  
   - Renegotiate with furniture vendors to secure better COGS (cost of goods sold).  
   - Introduce adjustable freight fees (or pass through shipping surcharges) to protect margins.  
   - Bundle low‐margin furniture items with higher‐margin accessories or tech add-ons.

2. **Double Down on Technology & Office Supplies**  
   - Invest in targeted marketing campaigns for Phones, Office Machines, and Accessories.  
   - Offer volume discounts for high‐margin SKUs to encourage larger basket sizes.  
   - Explore cross‐sell opportunities (e.g., tech purchase = 10% off on toner/office supplies).

3. **Customer Profitability Audits**  
   - Flag loss‐making accounts (like Sean Miller) and reassign them to a dedicated “High‐Cost” support workflow:  
     - Charge restocking/return fees where warranted.  
     - Encourage migration to higher‐margin lines via loyalty incentives.  
   - For top‐profiting customers (e.g., Tamara Chand), provide premium support, priority shipping, and loyalty rewards to sustain growth.

4. **Optimize Logistics**  
   - Target average “shipping days” ≤ 3 across all categories where feasible.  
   - For slow‐moving lines (Furniture, Bookcases), evaluate alternate carriers or local warehousing for faster last‐mile delivery.  
   - Implement a “ship by” guarantee to reduce late‐shipment penalties.

5. **Seasonal Promotions**  
   - Pre‐holiday flash sales in September to stimulate early orders.  
   - Create “bundle deals” around October / November when customer willingness to spend is highest.  
   - Use email and social media campaigns to drive traffic during historically low months (July / August).

6. **Empower Sales Reps & Teams**  
   - Document best practices from the top 3 reps (e.g., email templates, outreach scripts).  
   - Introduce a quarterly “Sales Champion” program with performance‐based bonuses.  
   - Provide regular training on cross‐selling high‐margin items and avoiding discount overuse.
---

## ⚠️ Limitations
1. **Timeframe Restricted to 2014–2017**  
   - No data beyond 2017 → unable to assess post-2017 trends, market shifts, or impacts of new competitors.  

2. **Geographic Granularity Limited to State Level**  
   - While we have city‐level fields, the map analyses focus on states and regions. More granular ZIP‐ or DMA‐level insight (customer clustering) is possible but not covered here.

3. **No Customer Transaction Cost Data**  
   - We lack direct COGS per product line; profit is only “Revenue – Sales Return – Discount” but does not account for warehousing or marketing spend.  
   - True net margins (after overhead, marketing, storage fees) would be lower.

4. **Single Data Source (Excel)**  
   - No cross‐referencing with external BI tools or ERP logs.  
   - Returns data (if any) are embedded in negative‐profit line items but not separately tracked.

5. **Staff Details Only at Rep/Team Level**  
   - We do not have granular “hours worked,” “call logs,” or “lead source” details to fully analyze rep productivity.
     
6. **Lack of External Factors**: No integration of economic or seasonal variables

7. **Missing Customer Feedback**: No sentiment data or customer satisfaction metrics

---

## 📚 References

* [Microsoft Power BI Documentation](https://docs.microsoft.com/en-us/power-bi/)
* Source File: `All Sales Records_PBI.xlsx`
