# AdventureWorks 2022 Sales Dashboard

## Project Overview
This is a sample data analysis project using the **AdventureWorks 2022** database.  
The goal is to clean and prepare data in **SQL Server**, then analyze and visualize it in **Excel** through interactive dashboards.

---

## Tools Used
- Microsoft SQL Server 2022  
- SQL Server Management Studio (SSMS)  
- Microsoft Excel  

## Dataset Used
- **AdventureWorks2022** (official Microsoft sample database)  
  Download link: [AdventureWorks2022.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak)

---

## Project Steps

### 1. Data Preparation (SQL)
Created several SQL views to clean and combine the data:

- **vw_CleanSales** – cleaned sales and revenue data  
- **vw_CleanCustomers** – combined customer and country information  
- **vw_CleanProducts** – calculated profit margin and stock level  
- **vw_FinalDashboardData** – merged all cleaned data into one view for Excel  

After creating the views, the final data from `vw_FinalDashboardData` was exported to Excel.

---

### 2. Excel Dashboard
Built an interactive Excel dashboard using PivotTables, Charts, and Slicers.

#### Dashboard Pages
1. **Sales Overview**
   - Shows total revenue, units sold, and yearly/monthly trends  
   - Charts: Annual Sales Trend, Monthly Comparison, Category Sales  

2. **Product Deep Dive**
   - Focuses on product performance and profitability  
   - Charts: Top 10 Products by Profit, Stock Levels, Profit vs. Revenue  

#### Common Slicers
All charts are connected to these slicers:
- Order Year  
- Order Month  
- Category  
- Country  

---

## How to Explore
1. Download and open **AdventureWorks_Sales_Dashboard.xlsx**.  
2. Use the slicers to filter by **Year**, **Month**, **Category**, or **Country**.  
3. Review KPIs, charts, and trends across both dashboard pages.  
4. No setup or database connection is required — all data is already included.

---


## Files Included
```
AdventureWorks_Sales_Project/
│
├── AdventureWorks_Dashboard_Views.sql # SQL script for creating the views
├── AdventureWorks_Sales_Dashboard.xlsx # Excel dashboard
├── Dashboard_Screenshots/ # Folder for dashboard preview images
│ ├── Sales_Overview_Dashboard.png # Screenshot of first dashboard page
│ └── Product_DeepDive_Dashboard.png # Screenshot of second dashboard page
└── README.md # Project documentation
```

---

## Dashboard Screenshots
Two high-quality images are included for quick preview:

1. **Sales_Overview_Dashboard.png** – Visualizes yearly and monthly sales trends with KPIs.  
2. **Product_DeepDive_Dashboard.png** – Shows product performance, profitability, and stock insights.