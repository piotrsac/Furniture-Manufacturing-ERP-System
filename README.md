# Furniture Manufacturing ERP System

### Integrated Supply Chain, Production Planning & Sales Management

A robust **MS SQL Server** database solution designed for a specialized furniture manufacturer (desks, ergonomic chairs, and office equipment). This project simulates a real-world ERP/MRP environment, featuring automated production scheduling, capacity-aware lead time estimation, and a dynamic business rule engine.

---

## 👥 Authors

_Alicja Czeleń_ [[Qumixx]](https://github.com/Qumixx)  
_Piotr Sączawa_ [[loschrix]](https://github.com/loschrix)  
_Patrycja Zborowska_ [[piotrsac]](https://github.com/piotrsac)

---

## 🚀 Key Features

### 1. Intelligent Order Orchestration (`AddOrder`)

- **Bulk Processing:** Utilizes **User-Defined Table Types (TVP)** to process entire shopping carts in a single ACID-compliant transaction.
- **Real-time Inventory Check:** Automatically verifies stock levels for finished goods during the ordering process.
- **On-Demand Production:** If stock is insufficient, the system automatically generates production plans and allocates future output to specific orders.

### 2. Automated MRP Logic & Capacity Scheduling

- **Capacity-Aware Estimations:** Calculates delivery dates based on `AssemblyCapacity` and `ProductionCapacity` constraints.
- **Working Calendar Integration:** A dedicated `CalculateEndDate` function skips weekends and holidays defined in the `DaysOff` table to provide realistic fulfillment dates.
- **Quality Control Tracking:** Records daily production progress including quality statuses (Pass/Fail) to monitor manufacturing efficiency.

### 3. Dynamic Business Rule Engine

- **Singleton Configuration:** A global `Parameters` table allows administrators to adjust profit margins, discount thresholds, and maximum rebates "on-the-fly" without code changes.
- **Automated Pricing:** Utilizes scalar functions to automatically determine `ProductionCost` and `SellingPrice` based on the Bill of Materials (BOM) and current margins.

### 4. Advanced Analytics & Reporting

- **Management Dashboard:** High-level views providing monthly and quarterly sales performance and production cost aggregations.
- **Inventory Intelligence:** Real-time tracking of raw materials (Parts) vs. finished products.
- **Customer Insights:** Detailed historical analysis of order patterns and applied discounts over various time periods.

---

## 🛠 Technical Stack

- **Engine:** Microsoft SQL Server (T-SQL)
- **Architecture:** Relational Schema with 14 normalized tables.
- **Logic Layers:**
  - **Stored Procedures:** Complex business workflows with `TRY...CATCH` error handling and transaction management.
  - **Triggers:** Integrity enforcement for production status transitions.
  - **Security:** Role-Based Access Control (RBAC) with 4 distinct roles (Management, Sales, Planning, Warehouse).

---

## 📂 Database Schema Overview

The system is built on five core modules:

| Module              | Key Tables                                                       |
| :------------------ | :--------------------------------------------------------------- |
| **Sales**           | `Orders`, `OrderDetails`, `Clients`, `Status`                    |
| **Production**      | `ProductionPlans`, `ProductionDailyLog`, `ProductionAllocations` |
| **Inventory (BOM)** | `Products`, `ProductParts`, `Parts`, `PartTypes`, `Categories`   |
| **Business Logic**  | `Parameters` (Global Settings)                                   |
| **Logistics**       | `DaysOff` (Holiday/Downtime Calendar)                            |

<img width="1460" height="736" alt="database scheme" src="./database scheme.png" />

---

## 💻 Setup & Installation

1. Open **SQL Server Management Studio (SSMS)**.
2. Execute the schema script to generate the 14-table structure.
3. Load the stored procedures, functions, and triggers to enable business logic.

---

_Developed as a Final Project for the Database Systems course (2025/2026) at AGH UST._
