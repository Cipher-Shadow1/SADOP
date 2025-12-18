<div align="center">

<h1>🧠 SADOP</h1>
<h3>Smart AI-Driven Database Optimization Platform</h3>

<p>
An academic project combining <b>Databases</b>, <b>Machine Learning</b>, <b>Reinforcement Learning</b>, and <b>LLMs</b> to analyze, predict, and optimize MySQL performance.
</p>

<hr/>

<!-- Tech Stack Icons -->
<p>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mysql/mysql-original.svg" width="50"/>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg" width="50"/>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/pytorch/pytorch-original.svg" width="50"/>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tensorflow/tensorflow-original.svg" width="50"/>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/git/git-original.svg" width="50"/>
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linux/linux-original.svg" width="50"/>
</p>

</div>

---

## 🧠 Project Overview

**SADOP (Smart AI-Driven Database Optimization Platform)** is a system designed to:

- Monitor MySQL performance
- Detect slow and inefficient queries
- Predict performance problems using Machine Learning
- Automatically recommend database indexes using Reinforcement Learning
- Interact with the database using Natural Language (LLMs)

---

## 🧱 Phase 1 — Environment & Tools (M1)

### 🎯 Goal

Prepare a **professional development environment** capable of:

- Running MySQL
- Generating large datasets
- Training ML & RL models
- Interacting with LLMs

### ✅ Completed Tasks

#### 💻 Operating System

- Windows 11 Pro (development environment)

#### 🛢️ Database

- MySQL Server 8.x
- Running on port **3307**
- Managed via MySQL Workbench

#### 🔐 Security

- Root account secured
- Dedicated database user created: `sadop_user`
- Restricted privileges applied

#### 🐍 Python Environment

- Python 3.12
- Conda virtual environment: **SADOP**
- JupyterLab / Jupyter Notebook configured

#### 📦 Installed Libraries

**Core**

- mysql-connector-python
- pandas, numpy

**Machine Learning**

- scikit-learn
- tensorflow / pytorch

**Reinforcement Learning**

- gymnasium
- stable-baselines3

**LLM**

- langchain
- Ollama (local LLM)

#### 📁 Project Structure

```
SADOP/
├── db/
│ └── sadop_db_backup.sql
├── monitoring/
├── data/
│ └── users.csv
│ └── accounts.csv
│ └── transactions.csv
│ └── logs.csv
│ └── query_metrics.csv
│ └── slow_query_metrics_realistic.csv
│ └── slow_query_metrics.csv
│ └── slow_query_metrics_final.csv
│ └── ml_features.csv
│ └── y_train_reg.csv
│ └── y_train_cls.csv
│ └── y_test_cls.csv
│ └── y_test_reg.csv
│ └── X_test.csv
│ └── X_train.csv
├── ml/
│ └── feature_engineering.ipynb
│ └── train_diagnostic_model.ipynb
├── rl/
│ └── rl_env_setup.ipynb
│ └── train_rl_agent.ipynb
├── llm/
│ └── llm_connector.ipynb
│ └── queries_demo.ipynb
├── api/
│ └── app.py
├── report/
│ └── images/
│ └── report.docx / report.pdf
└── notebooks/
├── 00_environment_check.ipynb
├── 01_mysql_connection.ipynb
├── 02_create_schema.ipynb
├── 03_generate_fake_data.ipynb
├── 04_generate_data_Frame.ipynb
├── 06_MySQL_Monitoring_Setup.ipynb
├── 07_Enable_Performance_Schema.ipynb
├── 08_Capture_Performance_Metrics.ipynb
├── 09_Simulate_Queries_and_Capture_Metrics.ipynb
├── 10_Generate_Realistic_Slow_Queries_and_Metrics.ipynb

```

---

## 🧱 Phase 2 — Database Design & Data Generation (M2)

### 🎯 Goal

Create a **realistic, large, and normalized database** able to:

- Stress MySQL
- Generate performance issues
- Feed ML & RL models

### 🏦 Use Case

**Banking System**

### 🧩 Database Design

#### Main Entities

- Users
- Accounts
- Transactions
- Logs

#### Design Quality

- ER diagram created
- Schema normalized to **3NF**
- Primary keys defined
- Foreign keys enforced
- Basic indexes added

### 🧠 Schema Implementation

- SQL DDL scripts written
- Tables created via Jupyter
- User-based access (no root usage)

### 🧪 Data Generation

#### Small Dataset

- Inserted for testing
- Data consistency validated
- Errors fixed (phone number length)

#### Large Dataset (Production-Scale)

- Users: ~10,000
- Accounts: ~20,000+
- Transactions: **100,000+**
- Logs: **50,000 – 100,000**
- Inserted **in batches**
- With realistic timestamps and values

#### CSV Export

- Tables exported for offline use:
  - `data/users.csv`
  - `data/accounts.csv`
  - `data/transactions.csv`
  - `data/logs.csv`

### 💾 Backup

- Full MySQL dump created: `db/sadop_db_backup.sql`

✅ **Milestone M2 completed**

---

## 🧱 Phase 3 — Monitoring & Performance Data (M3)

### 🎯 Goal

Collect **real MySQL performance signals** for AI models.

### 🔍 Completed Steps

- Enabled MySQL `slow_query_log`
- Aggressive threshold set (queries slower than **0.4s**)
- Located slow query log file
- Simulated realistic queries on CSV + captured:
  - Execution time
  - Rows examined
  - Number of joins
- Simulated missing indexes and traffic spikes
- Captured CPU & memory usage per query
- Saved metrics to CSV:
  - `data/slow_query_metrics.csv`
  - `data/slow_query_metrics_realistic.csv`
  - `data/slow_query_metrics_final.csv`
  - `data/ml_features.csv`

This enables:

- Real workload observation
- Performance labeling
- ML/RL feature extraction

### 🔧 Jupyter Notebooks

- 01_environment_check.ipynb
- 02_mysql_connection.ipynb
- 03_generate_fake_data.ipynb
- 04_generate_data_Frame.ipynb
- 06_MySQL_Monitoring_Setup.ipynb
- 07_Enable_Performance_Schema.ipynb
- 08_Capture_Performance_Metrics.ipynb
- 09_Simulate_Queries_and_Capture_Metrics.ipynb
- 10_Generate_Realistic_Slow_Queries_and_Metrics.ipynb

---

## 🧱 Phase 4 — Feature Engineering & ML Pipeline (Stage 10 → 13)

### 🎯 Goal

Prepare a **fully enhanced, ML-ready dataset** including:

- Structural query features
- Realistic performance metrics
- System load (CPU/memory)
- Adaptive slow query labeling
- Normalized numeric features
- Train/test split

### 🔹 Stage 10: Generate Realistic Slow Queries & Metrics

- Heavy queries with Users → Accounts → Transactions joins
- Aggregated transactions with `SUM` per account
- Simulated missing index by shuffling transactions
- Traffic spikes: repeated queries 3x with slight time variability
- Captured CPU & memory usage per query using Python `psutil`
- Shuffled all queries
- Saved as `data/slow_query_metrics_final.csv`

### 🔹 Stage 11: Feature Engineering & Structural Encoding

- Added structural features:
  - `has_sum`, `has_group_by`, `has_where`
  - `tables_count` (joins + 1)
  - `query_length`
- Saved dataset as `data/ml_features.csv`

### 🔹 Stage 12: Exploratory Analysis & Linear Regression

- Plotted histogram of `query_time` → identified fast vs slow clusters
- Boxplot of `rows_examined` vs `is_slow` → confirmed correlation
- Linear regression on numeric + structural features → identified key predictors
- Validated that features can predict query performance

### 🔹 Stage 13: Normalize & Train/Test Split

- Log-transformed `query_time` to smooth gaps
- Selected numeric + categorical features
- Standardized numeric features using StandardScaler
- Split dataset 80/20 train/test
- Saved preprocessed datasets:
  - `X_train.csv`, `X_test.csv`
  - `y_train_reg.csv`, `y_test_reg.csv`
  - `y_train_cls.csv`, `y_test_cls.csv`

**Result:** Fully ML-ready dataset including **all performance, structural, and system metrics**.

---

## 📂 Files Added / Generated So Far

- `data/users.csv`
- `data/accounts.csv`
- `data/transactions.csv`
- `data/logs.csv`
- `data/query_metrics.csv`
- `data/slow_query_metrics.csv`
- `data/slow_query_metrics_realistic.csv`
- `data/slow_query_metrics_final.csv`
- `data/ml_features.csv`
- `db/sadop_db_backup.sql`

---

## 🧭 Next Steps

- Task 41+ (M4): Define features for ML pipeline
- Train diagnostic ML models
- Build RL index optimization agent
- Integrate LLM natural language interface
- Evaluate and document end-to-end system

---

<div align="center">
<b>SADOP — Turning database performance into intelligent decisions.</b>
</div>
