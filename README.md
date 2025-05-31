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
| 2014 | \$484,247.50  | \$49,543.97  | 969           |
| 2015 | \$470,532.51  | \$61,618.60  | 1,038         |
| 2016 | \$609,205.60  | \$81,795.17  | 1,315         |
| 2017 | \$733,215.26  | \$93,439.27  | 1,687         |

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
| West     | \$725,457.82  | \$108,418.45 | 1,611         |
| East     | \$678,781.24  | \$91,522.78  | 1,401         |
| Central  | \$501,239.89  | \$39,706.36  | 1,175         |
| South    | \$391,721.91  | \$46,749.43  | 822           |

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
| Technology       | \$836,154.03  | \$145,454.95 | 1,544         |
| Furniture        | \$741,999.80  | \$18,451.27  | 1,764         |
| Office Supplies  | \$719,047.03  | \$122,490.80 | 3,742         |

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
| Copiers         | \$157,820†  | \$29,654†   | ~200             |
| Phones          | \$142,460†  | \$24,310†   | ~1,100           |
| Accessories     | \$135,230†  | \$21,875†   | ~1,800           |
| Office Machines | \$115,900†  | \$18,240†   | ~130             |
| Chairs          | \$103,500†  | \$5,460†    | ~680             |

- Notice that **Chairs** shows a disproportionately low profit (only ~5.3% margin) compared to its revenue.  
- **Office Machines**, though smaller in order count, deliver a strong margin (~15.7%).  
- **Binders, Paper, Storage** categories each contributed between \$60–\$90 K in revenue but have mid‐range margins (10–15%).

### Top Customers & Sales Representatives

#### Top 10 Customers by Revenue

| Customer Name       | Total Revenue | Total Profit | Total Quantity |
|---------------------|---------------|--------------|----------------|
| Sean Miller         | \$25,043.05   | \$–1,980.74  | 50             |
| Tamara Chand        | \$19,052.22   | \$8,981.32   | 42             |
| Raymond Buch        | \$15,117.34   | \$6,976.10   | 71             |
| Tom Ashbrook        | \$14,595.62   | \$4,703.79   | 36             |
| Adrian Barton       | \$14,473.57   | \$5,444.81   | 73             |
| Ken Lonsdale        | \$14,175.23   | \$806.86     | 113            |
| Sanjit Chand        | \$14,142.33   | \$5,757.41   | 87             |
| Hunter Lopez        | \$12,873.30   | \$5,622.43   | 50             |
| Sanjit Engle        | \$12,209.44   | \$2,650.68   | 78             |
| Christopher Conant  | \$12,129.07   | \$2,177.05   | 34             |

- **Sean Miller** is the single largest revenue‐generating customer (~\$25 K) but at a **net loss** of ~\$1,980 (disproportionate discounts or high returns).  
- **Tamara Chand** contributed ~\$19 K and yielded \$8.9 K in profit (47% margin).  
- Several customers buy large quantities (e.g., Ken Lonsdale: 113 units, \$14K revenue) but yield lower margins (only \$806 profit).

#### Top 5 Sales Representatives by Revenue

| Sales Rep       | Total Revenue | Total Profit | Unique Orders |
|-----------------|---------------|--------------|---------------|
| Juan Nunez      | \$135,500†    | \$24,300†    | 320           |
| Brenda Williams | \$128,750†    | \$22,150†    | 290           |
| Roy Anderson    | \$125,600†    | \$21,800†    | 305           |
| Michelle Perez  | \$123,400†    | \$19,900†    | 280           |
| David Thompson  | \$120,200†    | \$20,450†    | 260           |

- The top 5 reps each generate roughly \$120–\$136 K in sales (2014–2017), with margins between 15–18%.  
- **Sales Team Performance**  
  - “Organic” team (led by Manager X) contributed ~\$400 K in total, with ~\$60 K profit.  
  - “Inorganic” team (led by Manager Y) contributed ~\$320 K, with ~\$48 K profit.  
  - This suggests focusing on ramping up the Organic team’s best practices for the Inorganic side.

### Order Destinations (Geographic)

- **State‐Level Order Counts (Top 5)**  
  1. **California (West)** – 425 unique orders  
  2. **New York (East)** – 390 unique orders  
  3. **Texas (Central)** – 350 unique orders  
  4. **Florida (South)** – 320 unique orders  
  5. **Illinois (Central)** – 290 unique orders  

- **Map Visualization** (Power BI Sales Overview):  
  - Bubbles colored by `Region`.  
  - West (blue), East (purple), Central (orange), South (red).  
  - Largest bubble in California; then a cluster around New York and Texas.

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

---

## 🧾 Results and Key Findings
1. **Sales Growth**: Hagital Store saw consistent growth in sales and profits from 2014 to 2017, with a peak in 2017.
2. **Total Actual Revenue**: $9.89M total revenue with significant customer and product concentration
3. **Total Profit**: $286.4K, indicating moderate margin; potential pricing optimization needed
4. **Product Performance**: Technology and Office Supplies were the most profitable categories, while tables consistently underperformed, incurring a $-17,725.48 loss.
5. **Regional Dominance**: The Central region outperformed others in profit contribution, despite all data being from the West region (California).
6. **Team Performance**: The Organic team, led by Morris Garcia, was the top performer, while the Charlie team lagged.
7. **Seasonal Trends**: November and December were the strongest months, indicating a holiday sales boost.
8. **Shipping Efficiency**: Standard Class shipping was the most cost-effective, balancing speed and cost.
9. **Customer Base**: Top 10 customers drive a disproportionately large share of sales

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
1. **Optimize Product Offerings**:
   - Discontinue or reevaluate the bookcase sub-category due to consistent losses. Focus on high-profit categories like Technology and Office Supplies.
   - Promote top-selling products like staple envelopes and Canon printers through targeted marketing.
2. **Regional Strategy**:
   - Expand operations in the Central region, which shows the highest profit contribution, while maintaining a strong presence in California.
   - Investigate why West region profits are lower despite high sales volume.
3. **Sales Team Improvement**:
   - Provide additional training or incentives to the Charlie team to improve performance.
   - Replicate the Organic team's strategies (e.g., led by Morris Garcia) across other teams.
4. **Seasonal Marketing**:
   - Increase marketing efforts in Q4 (November and December) to capitalize on holiday sales trends.
   - Offer promotions in slower months (e.g., January, February) to balance yearly sales.
5. **Shipping Optimization**:
   - Encourage the use of Standard Class shipping for cost efficiency while maintaining customer satisfaction.
   - Explore faster shipping options for high-value orders to improve customer experience.
6. **Customer Engagement**:
   - Build loyalty programs for top customers like Tamara Chand to retain high-value clients.
   - Target the Consumer segment with tailored promotions, as they drive the majority of sales.
---
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
1. **Geographic Scope**: The dataset only includes sales from the West region (California), limiting insights into other regions' performance.
2. **Time Frame**: Data only spans 2014–2017, missing more recent trends that could affect recommendations.
3. **Granularity**: Lack of customer demographic data (e.g., age, gender) limits deeper customer segmentation.
4. **Lack of External Factors**: No integration of economic or seasonal variables
5. **Missing Customer Feedback**: No sentiment data or customer satisfaction metrics

---

## 📚 References

* [Microsoft Power BI Documentation](https://docs.microsoft.com/en-us/power-bi/)
* Source File: `All Sales Records_PBI.xlsx`
