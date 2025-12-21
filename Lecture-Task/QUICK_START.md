# ⚡ GreenStream Energy - ETL Dashboard & Pipeline

### 👤 Author: Abdelrahman Gadallah
**Framework:** Data Science Design | **Built with:** Lovable & Python Logic
**Status:** Live Prototype 🟢

---

## 📖 Project Overview
**GreenStream Energy** is a simulation dashboard and ETL pipeline designed to process high-velocity smart meter data. This project demonstrates a serverless architecture capable of handling **4.8 million daily readings** from **50,000+ smart meters** [1].

Using a custom **Lovable** interface, this application visualizes the transformation journey of energy data—from raw CSV ingestion to analytical Parquet storage—highlighting real-time data quality scoring and fault detection [2].

---

## 🔗 Live Demo
> **[https://abdelrahmangadallah.lovable.app/]**  
> *Click above to interact with the ETL dashboard and view real-time processing simulation.*

---

## 🏗️ Architecture Design

The system follows an event-driven flow ensuring low latency and high availability [2]:

| Layer | Component | Function |
| :--- | :--- | :--- |
| **Ingestion** | **S3 Landing Zone** | Ingests CSV files via Wi-Fi (`/raw-data/YYYY-MM-DD/`). |
| **Processing** | **Serverless Worker** | Parses CSV, standardizes units (W → kW), and scores quality. |
| **Storage** | **RDS (Structured)** | Stores transactional data with **90-day retention** [2]. |
| **Analytics** | **Data Lake** | Batch jobs convert data to **Snappy-compressed Parquet** (~70% size reduction) [3]. |

---

## ⚙️ Key Features & Business Logic

This project implements strict data governance rules visualized in the dashboard:

### 🔹 1. Unit Standardization (Auto-Fix)
*   **Logic:** Detects "W" (Watts) and divides by 1000 to convert to "kW" [3].
*   **Precision:** Rounds all values to **4 decimal places** [4].
*   **Validation:** Rejects invalid units (e.g., "Volts") instantly.

### 🔹 2. The "Quality Score" System (A-F)
A unique grading system assigns a score to every reading before storage [5]:

| Score Criteria | Points | Grade |
| :--- | :--- | :--- |
| **Completeness** | +40 | **A (90-100)** |
| **Validation Pass** | +30 | **B (75-89)** |
| **Physical Range** | +20 | **C (60-74)** |
| **Meter Reliability**| +10 | **F (< 60)** |

### 🔹 3. Advanced Fault Detection
The system automatically flags anomalies based on statistical thresholds:
*   **Stuck Meter:** Variance $< 0.01 \text{ kW}^2$ over 24h [6].
*   **Erratic Spikes:** Reading $> \text{Mean} + (4 \times \text{StdDev})$ [6].
*   **Zero Consumption:** 0 kW for >24 consecutive hours [7].

---

## 🔄 Scenario: Single Record Journey
*Ref: Task C - Traceability*

1.  **Ingestion:** Meter `SM-48291` sends `3250 W` at `18:45:00` [8].
2.  **Transformation:**
    *   Converts `3250 W` → **3.25 kW** [9].
    *   Tags period as **PEAK** (17:00-21:00) [5].
    *   Calculates Quality Score: **100/100 (Grade A)** [10].
3.  **Storage:** Committed to DB with Idempotency Key `SHA256(...)` [10].
4.  **Archival:** Aggregated into Data Lake for ML forecasting models [11].

---

## 💻 Tech Stack
*   **Frontend/UI:** Lovable.dev (React/Tailwind based)
*   **Logic:** Python (Pandas equivalent logic)
*   **Architecture Concepts:** Event-Driven, Serverless, Data Lakehouse
*   **Data Formats:** CSV (Ingest), Parquet (Analytics)

---

## 📸 Screenshots
*(GUI.png)*

---

*Designed & Implemented by **Abdelrahman Gadallah** - December 2024*
