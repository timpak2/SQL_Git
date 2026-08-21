# B2B Sales & Territory Performance Analytics

This repository features advanced T-SQL queries and analytics models built on **AdventureWorksDW2019** to evaluate multi-channel sales performance, territory distribution, customer behavior, and organizational financial metrics.


I used the AdventureWorks sample databases:
https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver17&tabs=ssms

Use Visual Studio Code to connect to the database and run code.

---

## Project Modules & Core Capabilities

### 1. Customer Behavior & Order Frequency
> *Focus: Evaluating B2B/B2C customer retention, order frequency, and volume demand.*
* **Customer Purchase Volume:** Aggregates cumulative product units ordered per customer (`SUM`, `GROUP BY`).
* **Product Demand Ranking:** Measures total item demand across all digital sales channels.
* **Repeat Order Identification:** Highlights active customers placing $\ge 2$ distinct orders within a fiscal year (`HAVING`, `COUNT DISTINCT`).
* **Top Revenue Categories:** Identifies top-performing product categories driving overall gross revenue (`TOP 2`, `ORDER BY`).
* **Consolidated Order Valuation:** Calculates unified revenue per sales order combining B2C (Internet) and B2B (Reseller) channels (`UNION ALL`).
* **Departmental Expenditure Tracking:** Maps financial expenditure across corporate and parent-department hierarchy levels.

### 2. Core Business Operations & HR Metrics
> *Focus: Operational HR analytics, inventory valuation, and spatial location modeling.*
* **Employee Compensation Analytics:** Computes leave pay entitlements using HR dimension attributes (`DimEmployee`).
* **Profit Margin Analysis:** Evaluates net profit margins across digital sales channels (`FactInternetSales`).
* **Daily Asset & Inventory Valuation:** Tracks daily stock availability and total asset inventory value (`FactProductInventory`).
* **Spatial Geography Directory:** Constructs a unique location directory across global business territories (`DimGeography`).
* **High-Value Product Tiering:** Segments top 10% high-value catalog items based on price distribution logic (`DimProduct`).

### 3. Territory Performance & Multi-Channel Unification
> *Focus: Cross-channel order consolidation, territory regional performance, and demographic segmentation.*
* **Regional Territory Performance:** Isolates high-value transactions ($>1000) mapped to specific sales territories.
* **Price Tier Filtering:** Filters Bike product lines matching truncated integer list price tiers (`ListPrice = 3399`).
* **Promotional Campaign Tracking:** Identifies transactions with high promotional discounts ($\ge 20\%$).
* **Target Demographic Profiling:** Extracts contact records for high-earning demographics ($>150\text{k}$) in close proximity ($<5\text{ miles}$).
* **Customer Segmentation:** Bins customers into custom Income Brackets and Age Groups as of 2019-12-31 (`CASE WHEN`).
* **Cross-Channel Line Items:** Unifies order numbers across Internet and Reseller channels for targeted product lines (`UNION`).

### 4. Financial Scenario Filtering & Hierarchy Self-Joins
> *Focus: Anti-join logic for inventory, parent-child organizational structures, and scenario analysis.*
* **Promotional Order Mapping:** Correlates promotional discount tiers with order lines and product metadata.
* **Category Hierarchy Filtering:** Queries product sub-trees under specific divisions ('Clothing').
* **Unsold Inventory Anti-Joins:** Identifies active catalog items with zero historical sales using two technical patterns:
  * **Subquery Method:** Using `NOT IN` with explicit null checks.
  * **Outer Join Method:** Using `LEFT JOIN ... IS NULL` anti-joins for optimized execution plans.
* **Organizational Hierarchy Mapping:** Constructs parent-child department trees using `Self-Join` techniques on `DimDepartmentGroup`.
* **Financial Actuals Analysis:** Evaluates actual financial metrics across nested organizational nodes (`DimScenario`, `DimOrganization`).

### 5. Financial Metric Reconciliation (CTEs & Multi-Channel)
> *Focus: Monthly revenue reconciliation, window operations, and CTE-based aggregation.*
* **Compensation Benchmarking:** Calculates average base rates grouped by employee job title (`AVG`, `GROUP BY`).
* **Daily Sales Volume Summaries:** Computes daily aggregated order volumes (`FactInternetSales`).
* **Category Financial Performance:** Measures Revenue, Cost, and Profit Margins for 2012 categories with revenue thresholds ($>5000$).
* **Custom Grouping Aggregations:** Groups product colors into custom tiers ('Basic' vs. Others) to evaluate revenue contributions.
* **Monthly Multi-Channel Reconciliation:** Performs month-by-month revenue side-by-side comparisons between Internet and Reseller channels across all fiscal years using `CTE` and `FULL OUTER JOIN`.

### 6. B2B & B2C Repeat Customer Performance
> *Focus: In-depth metrics on customer retention, repeat orders, and channel contribution.*
* **Lifetime Customer Volume:** Measures lifetime unit demand per individual account.
* **Item-Level Demand Distribution:** Ranks overall product catalog performance.
* **High-Frequency Buyer Metrics:** Pinpoints top repeat buyers executing multiple orders in a single calendar year.
* **Category Revenue Share:** Analyzes category market share to inform inventory planning.
* **Unified Sales Stream Analysis:** Combines direct-to-consumer and business reseller order lines.
* **Parent-Child Financial Allocation:** Tracks operational spending across organizational hierarchy nodes.

---

## SQL Syntax Used
* **Database System:** Microsoft SQL Server / T-SQL (AdventureWorksDW)
* **Aggregations & Grouping:** `SUM`, `AVG`, `COUNT(DISTINCT)`, `GROUP BY`, `HAVING`
* **Relational Joins:** `INNER JOIN`, `LEFT JOIN`, `FULL OUTER JOIN`, `Self-Join`
* **Set Operators & Logic:** `UNION / UNION ALL`, `CASE WHEN`, `COALESCE / ISNULL`
* **Advanced Querying:** Common Table Expressions (`CTE`), Subqueries, Anti-Joins (`IS NULL`)
