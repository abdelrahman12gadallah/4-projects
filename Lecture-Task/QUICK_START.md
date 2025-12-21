--------------------------------------------------------------------------------
# ⚡ GreenStream Energy - Serverless ETL Pipeline

### 👤 Author: Abdelrahman Gadallah
**Framework:** Data Science Design | **Date:** December 2024

---

## 📖 Project Overview
**GreenStream Energy** is a scalable, serverless ETL architecture designed to ingest and process smart meter data at scale. The system handles **4.8 million daily readings** from **50,000+ smart meters**, converting raw CSV streams into analytical Parquet datasets [1].

Unlike standard pipelines, this project implements a **"Quality Scoring System"** that grades every data point (A-F) in real-time, ensuring that only high-quality data feeds the BI dashboards and ML models [2].

---

## 🏗️ System Architecture

The pipeline follows an event-driven flow ensuring low latency and high availability [1, 3, 4]:

| Layer | Component | Function & Details |
| :--- | :--- | :--- |
| **1. Ingestion** | **Smart Meters & S3** | Ingests CSV files via Wi-Fi into S3 Landing Zone (`/raw-data/YYYY-MM-DD/`). |
| **2. Orchestration** | **Event Engine** | Triggered by `New File Creation`. Handles validation, routing, and duplicate detection. |
| **3. Transformation** | **Serverless Workers** | Parses CSV, standardizes units, applies business rules, and calculates quality scores. |
| **4. Storage (Ops)** | **RDS (Structured)** | Stores transactional data (`meter_readings`) with **90-day retention**. |
| **5. Analytics** | **Data Lake (S3)** | Batch jobs convert data to **Snappy-compressed Parquet** (~70% size reduction) for long-term analysis. |

---

## ⚙️ Business Rules & Logic (The Core)

The pipeline enforces strict data governance through 6 categories of rules [2, 4-6]:

### 🔹 1. Unit Standardization
*   **Logic:** If unit is "W" (Watts), divide by 1000 to get "kW".
*   **Precision:** All values rounded to **4 decimal places** to prevent floating-point errors [7].
*   **Guardrails:** Strict allow-list validation (rejects units like "Volts") [4].

### 🔹 2. Advanced Fault Detection
*   **Stuck Meter:** Flags variance $< 0.01 \text{ kW}^2$ over a 24-hour window [6].
*   **Erratic Spikes:** Detects anomalies where Reading $> \text{Mean} + (4 \times \text{StdDev})$ [6].
*   **Communication Gaps:** Alerts if missing rate $> 20\%$ over 7 days [2].

### 🔹 3. The "Quality Score" System (Unique Feature)
Every record starts with **0 points** and earns points based on quality checks. A grade is assigned before storage [2]:

| Criteria | Points | Grade Scale |
| :--- | :--- | :--- |
| No Missing Values | +40 | **A (90-100)** |
| No Validation Errors | +30 | **B (75-89)** |
| Within Physical Range | +20 | **C (60-74)** |
| High Meter Reliability | +10 | **F (< 60)** |

---

## 🔄 Data Lineage: Single Record Journey
*Scenario based on real processing logs [8-11]*

1.  **Ingestion (18:45:00):** Meter `SM-48291` uploads a reading of `3250 W`.
2.  **Trigger (18:45:03):** S3 Event triggers the Orchestrator.
3.  **Transformation (18:45:04):**
    *   **Conversion:** `3250 W` → **3.25 kW**.
    *   **Enrichment:** Tagged as **PEAK** (17:00-21:00) and **SPRING** season.
    *   **Scoring:** Passes all checks. **Score: 100/100 (Grade A)**.
    *   **Idempotency:** Generates ID `SHA256(SM-48291 + Timestamp + 3250)`.
4.  **Storage (18:45:05):** Committed to RDS `meter_readings` table.
5.  **Archival (02:00 AM):** Aggregated into Data Lake (`/analytics/year=2024/`) in Parquet format.

---

## 🛡️ Design Principles

*   **Idempotency:** Uses SHA256 hashing to generate unique record IDs. Re-processing the same file results in `ON CONFLICT DO NOTHING`, preventing duplicates [8, 10].
*   **Separation of Concerns:** Raw data (Audit), Structured DB (Operations), and Data Lake (Analytics) are decoupled [12].
*   **Resiliency:** Implements **exponential backoff** (2s, 4s, 8s) for retries before moving failed events to a Dead Letter Queue (DLQ) [13].

---

*Designed by **Abdelrahman Gadallah** - December 2024*
