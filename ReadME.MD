# 🧠 SADOP - Smart AI-Driven Database Optimization Platform

<div align="center">
<img src="./hero.jpg" alt="SADOP Hero Image"/>

**An intelligent database performance optimization system combining Machine Learning, Reinforcement Learning, and Large Language Models**

[![Python](https://img.shields.io/badge/Python-3.12-blue.svg)](https://www.python.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-orange.svg)](https://www.mysql.com/)
[![FastAPI](https://img.shields.io/badge/FastAPI-Latest-green.svg)](https://fastapi.tiangolo.com/)
[![Next.js](https://img.shields.io/badge/Next.js-15-black.svg)](https://nextjs.org/)
[![License](https://img.shields.io/badge/License-Academic-purple.svg)]()

**[Overview](#-project-overview) • [Features](#-key-features) • [Architecture](#-system-architecture) • [Installation](#-installation) • [Usage](#-usage) • [Documentation](#-comprehensive-file-documentation)**

</div>

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Key Features](#-key-features)
- [System Architecture](#-system-architecture)
- [Tech Stack](#-tech-stack)
- [Installation](#-installation)
- [Usage](#-usage)
- [Comprehensive File Documentation](#-comprehensive-file-documentation)
  - [BackEnd Files](#backend-files-detailed)
  - [Frontend Files](#frontend-files-detailed)
  - [RL Files](#rl-files-detailed)
  - [ML Notebooks](#ml-notebooks-detailed)
  - [Data Files](#data-files-detailed)
- [Performance Metrics](#-performance-metrics)
- [API Reference](#-api-reference)
- [Contributing](#-contributing)

---

## 🧠 Project Overview

**SADOP (Smart AI-Driven Database Optimization Platform)** is an academic project that demonstrates the integration of:

- **Machine Learning** for query performance prediction (XGBoost classifier, 95% accuracy)
- **Reinforcement Learning** for intelligent index recommendations (PPO agent)
- **Large Language Models** for natural language interaction (Llama 3.3 70B via Groq)
- **Real-time Database Monitoring** with automated optimization suggestions

### The Problem

Database administrators face challenges:

- Manual query optimization is time-consuming
- Index selection requires deep expertise
- Performance degradation is often reactive, not proactive

### The Solution

SADOP provides:

1. **Automated query performance prediction** - Identifies slow queries before they impact production
2. **Intelligent index recommendations** - RL agent learns optimal indexing strategies
3. **Natural language interface** - Ask questions in plain English, get actionable SQL recommendations

---

## ⭐ Key Features

### 🎯 Core Capabilities

- **ML-Powered Diagnostics**: Predicts whether a query will be FAST or SLOW with 95% accuracy
- **RL-Driven Optimization**: Recommends CREATE INDEX statements based on workload analysis
- **LLM Query Generation**: Generates optimized SQL from natural language requests
- **Intelligent Routing**: Automatically classifies user intent and routes to appropriate tools
- **Full-Stack Web UI**: Modern Next.js interface with real-time analysis

### 🔧 Technical Highlights

- **Hybrid AI Architecture**: Combines symbolic AI (rules), ML (predictions), and RL (optimization)
- **Workload-Based RL**: Agent trained on 100k timesteps using simulated database environment
- **Feature Engineering**: 10 ML features extracted from SQL structure + EXPLAIN plans
- **Cost-Aware Optimization**: Balances query performance gains vs index maintenance costs

---

## 🏗️ System Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                        USER (Web Browser)                      │
└───────────────────────────┬────────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────────┐
│                    FRONTEND (Next.js + React)                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  app/page.tsx - Main UI Component                        │  │
│  │  - Chat interface                                        │  │
│  │  - SQL query input                                       │  │
│  │  - Markdown + code formatting                           │  │
│  └──────────────────────────────────────────────────────────┘  │
└───────────────────────────┬────────────────────────────────────┘
                            │ HTTP POST /assistant
                            ▼
┌────────────────────────────────────────────────────────────────┐
│                    BACKEND (FastAPI + Python)                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  main.py - Central API Router                           │  │
│  │  - /assistant endpoint (intelligent routing)            │  │
│  │  - /diagnose endpoint (SQL analysis)                    │  │
│  │  - /generate_optimized_query endpoint                   │  │
│  └───────────┬────────────────────────────────────┬─────────┘  │
│              │                                    │            │
│              ▼                                    ▼            │
│  ┌──────────────────────┐             ┌──────────────────────┐│
│  │  llm_router.py        │             │  llm_engine.py       ││
│  │  - classify_prompt()  │             │  - generate_query()  ││
│  │  - Route user intent  │             │  - LLM synthesis     ││
│  └──────────┬────────────┘             └──────────┬───────────┘│
│             │                                     │            │
│             └──────────────┬──────────────────────┘            │
│                            ▼                                   │
│               ┌────────────────────────────┐                   │
│               │  Intelligent Routing Logic │                   │
│               │  - sql_query               │                   │
│               │  - query_generation        │                   │
│               │  - general_question        │                   │
│               └──────────┬─────────────────┘                   │
│                          │                                     │
│      ┌───────────────────┼───────────────────┐                 │
│      ▼                   ▼                   ▼                 │
│  ┌───────────┐   ┌───────────────┐   ┌───────────────┐        │
│  │ ml_engine │   │  rl_engine    │   │  database.py  │        │
│  │ .py       │   │  .py          │   │               │        │
│  │           │   │               │   │  - get_db     │        │
│  │ - XGBoost │   │  - PPO Agent  │   │  - EXPLAIN    │        │
│  │ - Predict │   │  - Recommend  │   │  - Execute    │        │
│  │   FAST/   │   │    Indexes    │   │    SQL        │        │
│  │   SLOW    │   │  - Workload   │   └───────────────┘        │
│  │           │   │    Analysis   │                            │
│  └───────────┘   └───────────────┘                            │
└────────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────────────┐
│                    MYSQL DATABASE (Port 3307)                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  SADOP_BDD Database                                      │  │
│  │  - user (20,000 records)                                 │  │
│  │  - accounts (35,000 records)                             │  │
│  │  - transactions (250,000 records)                        │  │
│  │  - logs (300,000 records)                                │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
```

### Data Flow Example

**User asks: "best query to get users from Algeria with their transactions"**

```
1. Frontend → POST /assistant {"message": "..."}
2. main.py → llm_router.classify_prompt()
   Result: {"type": "query_generation"}
3. main.py → llm_engine.generate_query_variations()
   Generates: SELECT u.*, t.* FROM user u JOIN transactions t ...
4. main.py → ml_engine.predict_query_performance()
   Result: {"is_slow": False, "probability": 0.12}
5. main.py → rl_engine.recommend_indexes_for_query()
   Result: ["CREATE INDEX idx_user_country ON user(country);", ...]
6. main.py → llm_engine.synthesize_response()
   Result: Natural language summary with SQL and recommendations
7. Frontend ← JSON response with formatted markdown
```

---

## 🛠️ Tech Stack

### Backend

- **Python 3.12** - Core language
- **FastAPI** - High-performance REST API
- **MySQL Connector** - Database interaction
- **XGBoost** - ML classification model
- **Stable-Baselines3** - RL (PPO algorithm)
- **Gymnasium** - RL environment framework
- **Groq SDK** - LLM API integration (Llama 3.3 70B)

### Frontend

- **Next.js 15** - React framework
- **TypeScript** - Type-safe JavaScript
- **TailwindCSS** - Utility-first styling
- **React Hooks** - State management

### Data & ML

- **Pandas/NumPy** - Data manipulation
- **Scikit-Learn** - ML utilities & preprocessing
- **Matplotlib/Seaborn** - Visualizations
- **Jupyter Notebooks** - Interactive development

### Database

- **MySQL 8.0** - Relational database
- **MySQL Workbench** - Database management

---

## 📦 Installation

### Prerequisites

```bash
# System requirements
- Python 3.12+
- Node.js 18+
- MySQL 8.0+
- Conda (recommended)
```

### Step 1: Clone Repository

```bash
git clone https://github.com/your-username/SADOP.git
cd SADOP
```

### Step 2: Backend Setup

```bash
# Create conda environment
conda create -n sadop python=3.12
conda activate sadop

# Install dependencies
cd BackEnd
pip install -r requirements.txt

# Set environment variables
cp .env.example .env
# Edit .env and add your GROQ_API_KEY
```

### Step 3: Database Setup

```bash
# Start MySQL on port 3307
mysql -u root -p

# Create database and user
CREATE DATABASE SADOP_BDD;
CREATE USER 'sadop_user'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON SADOP_BDD.* TO 'sadop_user'@'localhost';
FLUSH PRIVILEGES;

# Load schema and data (if you have backup)
SOURCE db/sadop_db_backup.sql;
```

### Step 4: Frontend Setup

```bash
cd ../frontend
npm install
```

### Step 5: Verify Installation

```bash
# Test backend
cd ../BackEnd
python verify_backend.py

# Expected output:
# ✅ ML Model loaded successfully
# ✅ RL Model loaded successfully
# ✅ Database connection OK
```

---

## 🚀 Usage

### Start the Application

**Terminal 1 - Backend:**

```bash
cd BackEnd
uvicorn main:app --reload
# Server running on http://localhost:8000
```

**Terminal 2 - Frontend:**

```bash
cd frontend
npm run dev
# App running on http://localhost:3000
```

### Example Queries

**1. SQL Diagnosis**

```
User: SELECT * FROM user WHERE country = 'Algeria'

Response:
🎯 Verdict: FAST ✅
📊 ML Prediction: 95% confidence (fast query)
🎯 RL Recommendations:
  - CREATE INDEX idx_user_country ON user(country);
```

**2. Natural Language Query Generation**

```
User: best query to get users with total account balance

Response:
✅ Generated Query:
SELECT u.user_id, u.full_name, SUM(a.balance) as total_balance
FROM user u
JOIN accounts a ON u.user_id = a.user_id
GROUP BY u.user_id, u.full_name

🎯 Recommended Indexes:
  - CREATE INDEX idx_user_user_id ON user(user_id);
  - CREATE INDEX idx_accounts_user_id ON accounts(user_id);
```

**3. General Question**

```
User: Why is my database slow?

Response:
Your database may be slow due to:
1. Missing indexes on frequently queried columns
2. Full table scans without WHERE clauses
3. Unoptimized JOIN operations

💡 Use my diagnostic tool by sharing a specific SQL query!
```

---

## 📚 Comprehensive File Documentation

### BackEnd Files (Detailed)

#### 🔹 `main.py` (19,655 bytes)

**Purpose:** Central FastAPI application serving as the orchestration layer for all AI tools.

**Key Components:**

1. **Endpoints:**

   ```python
   @app.post("/assistant")  # Line 186
   # Intelligent routing endpoint
   # - Classifies user intent (SQL query, query generation, general question)
   # - Routes to appropriate handler
   # - Returns unified JSON response

   @app.post("/diagnose")  # Line 92
   # SQL diagnostic endpoint
   # - Extracts SQL features (has_where, has_join, etc.)
   # - Executes EXPLAIN plan
   # - Calls ML engine for prediction
   # - Calls RL engine for index recommendations
   # - Returns comprehensive diagnosis

   @app.post("/generate_optimized_query")  # Line 275
   # Query generation endpoint
   # - Calls LLM to generate SQL variations
   # - Analyzes each variation with ML
   # - Recommends indexes with RL
   # - Selects best query based on scoring
   ```

2. **Feature Extraction (Lines 120-172):**

   ```python
   def extract_features_from_query(sql_query: str) -> Dict:
       """Extract 10 ML features from SQL"""
       features = {
           "has_sum": 1 if "SUM(" in sql_query.upper() else 0,
           "has_group_by": 1 if "GROUP BY" in sql_query.upper() else 0,
           "has_where": 1 if "WHERE" in sql_query.upper() else 0,
           "has_join": 1 if "JOIN" in sql_query.upper() else 0,
           "tables_count": count_tables(sql_query),
           "query_length": len(sql_query),
           ...
       }
   ```

3. **Intelligent Routing (Lines 193-280):**
   - Classifies user input using `llm_router.classify_prompt()`
   - Routes based on classification type
   - Handles SQL queries, query generation, general questions

4. **Debug Logging:**
   - **Line 92**: `🔵 ENDPOINT: /diagnose`
   - **Line 172**: `🟢 ENDPOINT: /assistant`
   - **Line 275**: `🟡 ENDPOINT: /generate_optimized_query`
   - **Line 194**: Classification result logging
   - **Line 309**: RL debug features

**Dependencies:**

- FastAPI, Pydantic (API framework)
- database.py (MySQL connection)
- ml_engine.py (XGBoost predictions)
- rl_engine.py (PPO recommendations)
- llm_engine.py (LLM query generation)
- llm_router.py (Intent classification)

---

#### 🔹 `ml_engine.py` (1,132 bytes)

**Purpose:** Machine Learning prediction engine using trained XGBoost classifier.

**Implementation:**

```python
# Lines 1-12: Model Loading
MODEL_PATH = "../ML/models/xgboost_slow_query_model.json"
model = XGBClassifier()
model.load_model(MODEL_PATH)

# Lines 14-24: Feature Order (CRITICAL - Must match training)
FEATURES = [
    "tables_count",    # Number of tables in query
    "query_length",    # Character count
    "has_sum",         # Contains SUM()
    "has_group_by",    # Contains GROUP BY
    "has_where",       # Contains WHERE
    "estimated_rows",  # From EXPLAIN plan
    "uses_index",      # From EXPLAIN plan
    "full_table_scan", # From EXPLAIN plan
    "uses_filesort",   # From EXPLAIN plan
    "uses_temp_table"  # From EXPLAIN plan
]

# Lines 26-45: Prediction Function
def predict_query_performance(features: Dict) -> Dict:
    """
    Predict if query is FAST or SLOW

    Returns:
        {
            "is_slow": bool,
            "slow_probability": float (0-1),
            "diagnosis": str
        }
    """
    # Convert dict → ordered numpy array
    X = np.array([[features[f] for f in FEATURES]])

    # XGBoost prediction
    prediction = int(model.predict(X)[0])  # 0 or 1
    probability = float(model.predict_proba(X)[0][1])  # P(slow)

    # Format response
    return {
        "is_slow": bool(prediction),
        "slow_probability": probability,
        "diagnosis": "SLOW QUERY" if prediction else "FAST QUERY"
    }
```

**Model Performance:**

- **Accuracy**: 95.0%
- **Precision (SLOW)**: 0.94
- **Recall (SLOW)**: 0.94
- **F1-Score**: 0.95
- **Training Data**: 18,471 queries (70% FAST, 30% SLOW)

**Critical Notes:**

- Feature order MUST match training (`ML/5_ML Diagnostic Engine.ipynb`)
- Missing features cause prediction errors
- Model file: `xgboost_slow_query_model.json` (not .pkl)

---

#### 🔹 `rl_engine.py` (7,639 bytes)

**Purpose:** Reinforcement Learning index recommendation engine using trained PPO agent.

**Architecture:**

```python
# Lines 17-31: Schema Definition
SCHEMA = {
    "user": ["user_id", "full_name", "email", "country", "signup_date"],
    "accounts": ["account_id", "user_id", "account_type", "balance", "created_at"],
    "transactions": ["transaction_id", "account_id", "amount", ...],
    "logs": ["log_id", "user_id", "log_level", "created_at"]
}

COLUMNS = ["user.user_id", "user.full_name", ..., "logs.created_at"]
NUM_COLUMNS = 20  # Total indexable columns

# Lines 34-43: Model Loading
class RLIndexRecommender:
    def __init__(self):
        MODEL_PATH = "../RL/Models/ppo_sadop_final.zip"
        self.model = PPO.load(MODEL_PATH)
```

**Key Methods:**

1. **Workload Analysis (Lines 45-71):**

   ```python
   def analyze_workload(self, query_features: Dict) -> np.ndarray:
       """Convert query features → workload vector"""
       workload = np.zeros(20)  # One per column

       # Mark "hot" columns based on query features
       if query_features.get("has_where") == 1:
           for i, col in enumerate(COLUMNS):
               if "country" in col or "email" in col:
                   workload[i] = 0.8  # Frequently queried

       if query_features.get("has_join") == 1:
           for i, col in enumerate(COLUMNS):
               if "user_id" in col or "account_id" in col:
                   workload[i] = 0.8

       return workload
   ```

2. **Index Recommendations (Lines 73-132):**

   ```python
   def recommend_indexes(self, query_features: Dict) -> Dict:
       """Use PPO agent to recommend indexes"""
       workload = self.analyze_workload(query_features)

       # Find hot columns (workload > 0.5)
       hot_columns = [(i, workload[i]) for i in range(20)
                      if workload[i] > 0.5]
       hot_columns.sort(reverse=True)  # Sort by intensity

       # Recommend top 3 hottest columns
       recommended_indexes = []
       for i, intensity in hot_columns[:3]:
           recommended_indexes.append(COLUMNS[i])

       # Generate CREATE INDEX statements
       sql_statements = []
       for col in recommended_indexes:
           table, column = col.split(".")
           sql_statements.append(
               f"CREATE INDEX idx_{table}_{column} ON {table}({column});"
           )

       return {
           "recommended_indexes": recommended_indexes,
           "sql_statements": sql_statements,
           "total_indexes": len(recommended_indexes)
       }
   ```

3. **Fallback Heuristic (Lines 146-218):**
   ```python
   # If RL recommends 0 indexes BUT query needs them
   if len(result["recommended_indexes"]) == 0:
       if query has WHERE or JOIN or full_table_scan:
           # Use manual heuristic
           fallback_indexes = recommend_common_columns()
           return fallback_response
   ```

**Why Fallback?**

- PPO agent sometimes returns 0 indexes (lazy agent syndrome)
- Fallback ensures system always provides recommendations
- Based on simple rules: WHERE → filter columns, JOIN → join columns

**Agent Configuration:**

- **Model**: PPO (Proximal Policy Optimization)
- **Training**: 100k timesteps
- **State Space**: Dict (indexes + workload)
- **Action Space**: 21 actions (0=stop, 1-20=toggle index)

---

#### 🔹 `llm_engine.py` (11,068 bytes)

**Purpose:** LLM-powered SQL query generation and natural language synthesis using Groq API (Llama 3.3 70B).

**Key Functions:**

1. **Query Generation (Lines 238-320):**

   ```python
   def generate_query_variations(user_request: str) -> List[Dict]:
       """Generate SQL from natural language"""

       schema = {
           "user": ["user_id", "full_name", "email", ...],
           "accounts": [...],
           "transactions": [...],
           "logs": [...]
       }

       prompt = f"""
       **User Request:** "{user_request}"

       **Database Schema:**
       {json.dumps(schema, indent=2)}

       **Rules:**
       - Simple SELECT query only
       - NO USE INDEX or FORCE INDEX hints
       - Include WHERE/JOIN as needed
       - Production-ready syntax
       - Do NOT use LIMIT unless user asks

       Generate ONE clean SQL query:
       """

       response = client.chat.completions.create(
           messages=[{"role": "user", "content": prompt}],
           model="llama-3.3-70b-versatile",
           temperature=0.2
       )

       sql = extract_sql_from_response(response)
       return [{"sql": sql, "variation": "llm_generated"}]
   ```

2. **Response Synthesis (Lines 150-200):**

   ```python
   def synthesize_query_response(sql, ml_verdict, rl_recommendations):
       """Generate natural language summary"""

       prompt = f"""
       Summarize this SQL analysis concisely:

       Query: {sql}
       ML Prediction: {ml_verdict}
       RL Recommendations: {rl_recommendations}

       Format:
       🎯 Verdict: FAST/SLOW
       📊 Explanation: 1-2 sentences
       🎯 Recommendations: Bullet points
       """

       return llm_call(prompt)
   ```

**Schema Provision Method:**

- **Technique**: Prompt Engineering (NOT RAG)
- **Justification**: Schema is small (4 tables, 20 columns) and static
- **Implementation**: Hardcoded JSON in LLM prompt

**LLM Configuration:**

- **Model**: Llama 3.3 70B Versatile (via Groq)
- **Temperature**: 0.2 (deterministic, low creativity)
- **Max Tokens**: 500 (concise responses)
- **API**: Groq Cloud (fast inference)

---

#### 🔹 `llm_router.py` (6,853 bytes)

**Purpose:** Intelligent classification of user intent to route requests to appropriate handlers.

**Core Function:**

```python
# Lines 22-90: Intent Classification
def classify_prompt(user_input: str) -> Dict:
    """
    Classify user intent using LLM

    Returns:
        {
            "type": "sql_query" | "query_generation" | "general_question",
            "confidence": float,
            "reasoning": str
        }
    """

    classification_prompt = f"""
    Classify this user input:

    User: "{user_input}"

    Rules:
    1. Contains SQL (SELECT, INSERT, ...) → "sql_query"
    2. Asks "best query for..." → "query_generation"
    3. General performance question → "general_question"

    Respond ONLY with JSON:
    {{
        "type": "...",
        "confidence": 0.95,
        "reasoning": "..."
    }}
    """

    response = client.chat.completions.create(
        messages=[{"role": "user", "content": classification_prompt}],
        model="llama-3.3-70b-versatile",
        temperature=0.1  # Very deterministic
    )

    return json.loads(response.choices[0].message.content)
```

**Routing Logic:**

- **sql_query** → `/diagnose` endpoint (ML + RL + LLM)
- **query_generation** → `/generate_optimized_query` endpoint
- **general_question** → LLM synthesis with tool awareness

**Classification Examples:**

```python
"SELECT * FROM user WHERE..." → {"type": "sql_query"}
"best query to get users..." → {"type": "query_generation"}
"Why is database slow?"     → {"type": "general_question"}
```

---

#### 🔹 `database.py` (1,568 bytes)

**Purpose:** MySQL connection management and database utilities.

**Functions:**

```python
def get_db_connection():
    """Establish MySQL connection"""
    return mysql.connector.connect(
        host="127.0.0.1",
        port=3307,
        database="SADOP_BDD",
        user="sadop_user",
        password="1234"
    )

def get_database_schema(conn):
    """Retrieve schema information"""
    cursor = conn.cursor()
    cursor.execute("SHOW TABLES")
    tables = cursor.fetchall()

    for table_name in tables:
        cursor.execute(f"DESCRIBE {table_name}")
        columns = cursor.fetchall()
        # Format and return schema
```

**Connection Details:**

- **Host**: localhost (127.0.0.1)
- **Port**: 3307
- **Database**: SADOP_BDD
- **User**: sadop_user

---

### Frontend Files (Detailed)

#### 🔹 `app/page.tsx` (8,118 bytes)

**Purpose:** Main React component providing chat-based interface for SQL analysis and query generation.

**Component Structure:**

````typescript
export default function Home() {
  // State management
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);

  // API call handler
  const handleSend = async () => {
    const response = await fetch("http://localhost:8000/assistant", {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify({message: input})
    });

    const data = await response.json();
    setMessages([...messages, {role: "assistant", content: data.diagnosis}]);
  };

  // Markdown formatting
  const formatResponse = (text: string) => {
    // Handle **bold** text
    // Handle ```sql code blocks
    // Render in terminal-style dark box
  };

  return (
    <div className="chat-container">
      {/* Messages display */}
      {/* Input field */}
      {/* Send button */}
    </div>
  );
}
````

**Key Features:**

1. **Markdown Rendering (Lines 8-70):**

   ````typescript
   function formatTextWithBold(text: string) {
     const parts = text.split(/(\*\*.*?\*\*)/g);
     return parts.map((part, i) => {
       if (part.startsWith("**") && part.endsWith("**")) {
         return <strong key={i}>{part.slice(2, -2)}</strong>;
       }
       return part;
     });
   }

   function formatResponse(text: string) {
     // Extract SQL code blocks
     const codeBlockRegex = /```sql\n([\s\S]*?)```/g;

     // Render in dark terminal box with cyan text
     return (
       <div className="terminal-box">
         <code className="sql-code">{sqlContent}</code>
       </div>
     );
   }
   ````

2. **API Integration (Lines 95-120):**

   ```typescript
   const response = await fetch("http://localhost:8000/assistant", {
     method: "POST",
     headers: { "Content-Type": "application/json" },
     body: JSON.stringify({ message: userInput }),
   });

   const data = await response.json();
   ```

3. **UI Styling:**
   - **Chat bubbles**: User (right), Assistant (left)
   - **SQL code blocks**: Dark background, cyan text, monospace font
   - **Bold text**: `**text**` rendered as `<strong>`
   - **Loading state**: "Thinking..." indicator

**Dependencies:**

- React 18
- Next.js 15
- TailwindCSS (utility classes)

---

### RL Files (Detailed)

#### 🔹 `RL/envs.py` (6,121 bytes)

**Purpose:** Gymnasium-based RL environment simulating database indexing decisions.

**Environment Design:**

```python
class DatabaseIndexEnv(gym.Env):
    """
    Simulated database environment for RL training

    Observation Space:
      - indexes: MultiBinary(20) - Binary vector, 1=index exists
      - workload: Box(0, 1, (20,)) - Float vector, query intensity

    Action Space:
      - Discrete(21) - Actions 0-20
      - Action 0: STOP
      - Actions 1-20: Toggle index on column X

    Reward Function:
      R = (prev_cost - current_cost) - penalty + stability_bonus
    """

    def __init__(self):
        # Lines 43-55: Define spaces
        self.observation_space = spaces.Dict({
            "indexes": spaces.MultiBinary(NUM_COLUMNS),
            "workload": spaces.Box(0.0, 1.0, (NUM_COLUMNS,), dtype=np.float32)
        })
        self.action_space = spaces.Discrete(NUM_COLUMNS + 1)

        self.current_indexes = np.zeros(NUM_COLUMNS, dtype=np.int8)
        self.current_workload = np.zeros(NUM_COLUMNS, dtype=np.float32)

    def reset(self):
        """Lines 57-75: Reset environment"""
        self.current_indexes = np.zeros(NUM_COLUMNS)

        # Generate realistic workload (exponential distribution)
        self.current_workload = np.random.exponential(0.2, NUM_COLUMNS)
        self.current_workload = np.clip(self.current_workload, 0.0, 1.0)

        # Create 3-5 "hot" columns
        num_hot = np.random.randint(3, 6)
        hot_indices = np.random.choice(NUM_COLUMNS, num_hot, replace=False)
        self.current_workload[hot_indices] = np.random.uniform(0.7, 1.0, num_hot)

        return self._get_obs(), {}

    def step(self, action):
        """Lines 114-154: Execute action and return reward"""
        prev_cost = self._calculate_total_cost(self.current_indexes)

        penalty = 0.0
        if action > 0:
            col_idx = action - 1
            if self.current_indexes[col_idx] == 0:
                # CREATE INDEX
                self.current_indexes[col_idx] = 1
                penalty = INDEX_CREATION_PENALTY  # 50.0
            else:
                # DROP INDEX
                self.current_indexes[col_idx] = 0
                penalty = DROP_INDEX_PENALTY  # 100.0

        current_cost = self._calculate_total_cost(self.current_indexes)

        # Reward formula (LINE 147)
        improvement = prev_cost - current_cost
        stability_bonus = 10.0 if action == 0 else 0.0
        reward = improvement - penalty + stability_bonus

        return self._get_obs(), reward, terminated, truncated, {}
```

**Cost Model (Lines 84-112):**

```python
def _calculate_total_cost(self, indexes):
    """Simulate database query cost"""
    total_cost = 0.0

    for i in range(NUM_COLUMNS):
        if indexes[i] == 1:
            # Index seek: O(log N)
            access_cost = np.log2(TABLE_SIZE) * SEEK_COST_PER_ROW
        else:
            # Full scan: O(N)
            access_cost = TABLE_SIZE * SCAN_COST_PER_ROW

        # Weight by workload intensity
        query_cost = self.current_workload[i] * access_cost
        total_cost += query_cost

        # Add maintenance cost
        if indexes[i] == 1:
            total_cost += INDEX_MAINTENANCE_COST

    return total_cost
```

**Constants:**

- **TABLE_SIZE**: 20,000 rows (simulated)
- **SCAN_COST_PER_ROW**: 1.0
- **SEEK_COST_PER_ROW**: 0.1 (10× faster with index)
- **INDEX_CREATION_PENALTY**: 50.0
- **DROP_INDEX_PENALTY**: 100.0 (prevents flickering)

---

#### 🔹 `RL/train.py` (5,580 bytes)

**Purpose:** PPO agent training script with evaluation callbacks.

**Training Configuration:**

```python
# Lines 76-91: PPO Hyperparameters
model = PPO(
    "MultiInputPolicy",  # Required for Dict observation space
    env,
    learning_rate=3e-4,
    n_steps=2048,        # Steps per policy update
    batch_size=64,
    gamma=0.99,          # Discount factor
    gae_lambda=0.95,     # Generalized Advantage Estimation
    clip_range=0.2,      # PPO clipping (prevents large policy updates)
    ent_coef=0.01,       # Entropy coefficient (encourages exploration)
    vf_coef=0.5,         # Value function coefficient
    max_grad_norm=0.5,   # Gradient clipping
    verbose=1,
    tensorboard_log="./tensorboard"
)

# Lines 97-101: Training
model.learn(
    total_timesteps=100_000,  # 100k training steps
    callback=EvaluationCallback(eval_freq=5000),
    progress_bar=True
)
```

**Evaluation Callback (Lines 28-60):**

```python
class EvaluationCallback(BaseCallback):
    """Periodic evaluation during training"""

    def _on_step(self):
        if self.n_calls % 5000 == 0:
            # Run 50-step evaluation
            total_reward = 0
            for _ in range(50):
                action, _ = self.model.predict(obs)
                obs, reward, done, _, _ = env.step(action)
                total_reward += reward

            mean_reward = total_reward / 50
            if mean_reward > self.best_mean_reward:
                self.best_mean_reward = mean_reward
                self.model.save("Models/best_model")
```

**Training Output:**

- **Model**: `Models/ppo_sadop_final.zip`
- **Metadata**: `Models/env_metadata.json`
- **Logs**: `rl_logs/monitor.csv`
- **TensorBoard**: `tensorboard/PPO_1/` through `PPO_11/`

**Training Duration:** ~30-45 minutes on CPU

---

### ML Notebooks (Detailed)

#### 🔹 `ML/1_Data Pipeline for AI.ipynb` (20,699 bytes)

**Purpose:** Initial ML feature engineering and dataset preparation.

**Steps:**

1. Load slow query metrics from CSV
2. Extract 9 ML features (has_sum, has_group_by, etc.)
3. Create binary target `is_slow` (threshold: 0.7 seconds)
4. Save enriched dataset as `ml_features.csv`

**Output:**

- `data/ml_features.csv` (20,000 rows, 10 columns)

---

#### 🔹 `ML/2_exploratory_analysis.ipynb` (201,969 bytes)

**Purpose:** Exploratory data analysis and visualization.

**Visualizations:**

- Query time distribution (histogram + KDE)
- Log-scale transformation (log(query_time + 1))
- Feature distributions (rows_returned, tables_count, etc.)
- Correlation matrix heatmap

**Baseline Model:**

- Linear Regression (R² = 0.013)
- Demonstrates non-linear relationships

---

#### 🔹 `ML/3_Normalize_Numeric_Features _Train_Test Split.ipynb` (21,634 bytes)

**Purpose:** Preprocessing and train/test split.

**Steps:**

1. Apply `log1p()` transformation to query_time
2. Select 10 features for ML
3. Train/test split (80/20, random_state=42)
4. Apply StandardScaler to normalize features
5. Save preprocessed datasets

**Outputs:**

- `X_train.csv`, `X_test.csv` (scaled features)
- `y_train_cls.csv`, `y_test_cls.csv` (classification targets)
- `y_train_reg.csv`, `y_test_reg.csv` (regression targets)

---

#### 🔹 `ML/4_Verify Data Quality & Consistency.ipynb` (12,444 bytes)

**Purpose:** Data quality checks.

**Checks:**

- Missing values: 0
- Duplicates: 5 rows found and removed
- Output: `ml_features_clean.csv` (19,995 rows)

---

#### 🔹 `ML/5_ML Diagnostic Engine — Predicting Query Performance.ipynb` (51,224 bytes)

**Purpose:** Train and evaluate ML models for query performance prediction.

**Models Trained:**

1. **XGBoost Classifier** (Best):
   - Accuracy: 95.0%
   - Precision: 0.95
   - Recall: 0.95
   - F1-Score: 0.95

2. **Logistic Regression**:
   - Accuracy: 94.0%
   - Baseline model

3. **Random Forest**:
   - Accuracy: 95.0%
   - Reference model

**Feature Importance (XGBoost):**

1. `rows_returned` (highest)
2. `query_length`
3. `tables_count`
4. `has_where`
5. `has_sum`

**Model Outputs:**

- `models/xgboost_slow_query_model.json` (production model)
- `models/random_forest_reference.pkl`
- `models/logistic_regression_reference.pkl`
- `models/scaler.pkl`

---

### Data Files (Detailed)

#### Database Tables

- **`users.csv`** (1,151,996 bytes, 20,000 records)
  - Columns: user_id, full_name, email, country, signup_date
  - Countries: DZ, FR, DE, US, UK

- **`accounts.csv`** (1,387,107 bytes, 35,000 records)
  - Columns: account_id, user_id, account_type, balance, created_at
  - Types: SAVINGS, CHECKING, BUSINESS

- **`transactions.csv`** (11,160,073 bytes, 250,000 records)
  - Columns: transaction_id, account_id, amount, type, date, status
  - Types: DEBIT, CREDIT
  - Status: SUCCESS, FAILED

- **`logs.csv`** (56,148,102 bytes, 300,000 records)
  - Columns: log_id, user_id, log_level, message, created_at
  - Levels: INFO, WARN, ERROR

#### ML Datasets

- **`ml_features.csv`** (3,834,495 bytes, 18,707 records)
  - Original ML features with all queries

- **`ml_features_clean.csv`** (3,809,570 bytes, 18,471 records)
  - Cleaned version (duplicates removed)

- **`X_train.csv`, `X_test.csv`** (2,945,560 + 736,568 bytes)
  - Scaled features for ML training

- **`y_train_cls.csv`, `y_test_cls.csv`** (44,904 + 11,235 bytes)
  - Classification targets (is_slow)

---

## 📊 Performance Metrics

### ML Model Accuracy

| Model               | Accuracy | F1-Score | Precision | Recall |
| :------------------ | :------- | :------- | :-------- | :----- |
| **XGBoost**         | 95.0%    | 0.95     | 0.95      | 0.95   |
| Random Forest       | 93.0%    | 0.95     | 0.95      | 0.94   |
| Logistic Regression | 93.0%    | 0.94     | 0.94      | 0.93   |

### RL Agent Behavior

- **Total Training**: 100,000 timesteps
- **Action Distribution** (on dataset):
  - ADD_INDEX: 76.6%
  - DROP_INDEX: 23.4%
  - NO_OP: 0% (agent learned to be proactive)

### System Response Time

- **SQL Diagnosis**: ~200-500ms
- **Query Generation**: ~1-2 seconds (LLM call)
- **Index Recommendations**: ~100-200ms

---

## 🔌 API Reference

### POST /assistant

**Intelligent routing endpoint - automatically classifies and routes requests**

**Request:**

```json
{
  "message": "SELECT * FROM user WHERE country = 'Algeria'"
}
```

**Response (SQL Query):**

```json
{
  "type": "sql_query",
  "diagnosis": "🎯 Verdict: FAST ✅\n📊 ML Prediction: 95% confidence\n🎯 Recommendations:\n• CREATE INDEX idx_user_country ON user(country);",
  "ml_verdict": "FAST",
  "rl_recommendations": [...],
  "total_indexes": 1
}
```

**Response (Query Generation):**

````json
{
  "type": "query_generation",
  "diagnosis": "✅ Generated Query:\n```sql\nSELECT ...\n```\n🎯 Recommended Indexes:\n• CREATE INDEX ...",
  "generated_query": "SELECT ...",
  "ml_verdict": "FAST",
  "total_indexes": 2
}
````

---

### POST /diagnose

**Direct SQL analysis endpoint**

**Request:**

```json
{
  "sql_query": "SELECT u.*, t.* FROM user u JOIN transactions t ON u.user_id = t.user_id WHERE u.country = 'DZ'"
}
```

**Response:**

```json
{
  "query": "SELECT ...",
  "ml_prediction": {
    "is_slow": false,
    "slow_probability": 0.12,
    "diagnosis": "FAST QUERY"
  },
  "rl_recommendations": {
    "recommended_indexes": ["user.country", "user.user_id", "transactions.user_id"],
    "sql_statements": [
      "CREATE INDEX idx_user_country ON user(country);",
      "CREATE INDEX idx_user_user_id ON user(user_id);",
      "CREATE INDEX idx_transactions_user_id ON transactions(user_id);"
    ],
    "total_indexes": 3
  },
  "features": {
    "has_where": 1,
    "has_join": 1,
    "tables_count": 2,
    "query_length": 123,
    ...
  }
}
```

---

## 🤝 Contributing

This is an academic project. For improvements:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

---

## 📄 License

Academic Project - Université License

---

## 👥 Team

**Project**: SADOP - Smart AI-Driven Database Optimization Platform  
**Institution**: [Your University]  
**Academic Year**: 2025-2026

---

<div align="center">

**🧠 SADOP — Turning database performance into intelligent decisions**

Made with ❤️ using Python, FastAPI, React, MySQL, XGBoost, PPO, and Llama 3.3 70B

</div>
