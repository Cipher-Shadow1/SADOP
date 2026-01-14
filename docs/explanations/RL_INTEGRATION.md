# Backend RL Integration - API Documentation

## New Endpoint: `/recommend_indexes`

### Purpose

Uses the trained RL agent (Annexe A compliant) to recommend optimal database indexes based on query analysis.

### Method

`POST /recommend_indexes`

### Request Body

```json
{
  "message": "SELECT * FROM user WHERE country = 'DZ' AND email LIKE '%@example.com'"
}
```

### Response

```json
{
  "query_analysis": {
    "has_where": true,
    "has_group_by": false,
    "has_sum": false,
    "tables_count": 1,
    "estimated_rows": 1500,
    "uses_index": false,
    "full_table_scan": true
  },
  "rl_recommendations": {
    "recommended_indexes": ["user.country", "user.email", "accounts.user_id"],
    "by_table": {
      "user": ["country", "email"],
      "accounts": ["user_id"]
    },
    "sql_statements": [
      "CREATE INDEX idx_user_country ON user(country);",
      "CREATE INDEX idx_user_email ON user(email);",
      "CREATE INDEX idx_accounts_user_id ON accounts(user_id);"
    ],
    "total_indexes": 3,
    "optimization_steps": 12
  },
  "workload_analysis": {
    "hot_columns": ["user.country", "user.email", "user.user_id"],
    "coverage": 66.67
  }
}
```

---

## Implementation Details

### Files Created

1. **`BackEnd/rl_engine.py`** - RL recommendation engine
   - `RLIndexRecommender` class
   - Loads trained PPO model from `RL/Models/ppo_sadop_final.zip`
   - Converts query features to workload vector
   - Runs RL agent to find optimal indexes

2. **`BackEnd/main.py`** - Added endpoint
   - New `/recommend_indexes` route
   - Integrates with EXPLAIN analysis
   - Returns actionable SQL CREATE INDEX statements

---

## How It Works

### Step 1: Query Analysis

```python
# Extract features from query
features = {
    "has_where": 1,
    "has_group_by": 0,
    "estimated_rows": 1500,
    "full_table_scan": 1,
    ...
}
```

### Step 2: Workload Simulation

```python
# Convert features to workload vector (20 columns)
workload = analyze_workload(features)
# High values for columns in WHERE/GROUP BY/JOIN
```

### Step 3: RL Optimization

```python
# Initialize state
state = {
    "indexes": [0, 0, 0, ...],  # No indexes
    "workload": [0.8, 0.2, 0.9, ...]  # Column usage
}

# Run trained RL agent
for _ in range(30):
    action = model.predict(state)
    # Agent creates indexes on high-workload columns
```

### Step 4: Generate Recommendations

```python
# Return SQL statements
recommendations = [
    "CREATE INDEX idx_user_country ON user(country);",
    ...
]
```

---

## Annexe A Compliance

| Requirement       | Implementation                         |  ✓  |
| :---------------- | :------------------------------------- | :-: |
| **État**          | Index Matrix + Workload Vector         | ✅  |
| **Action**        | CREATE/DROP specific indexes           | ✅  |
| **Récompense**    | Δ_Performance - Coût                   | ✅  |
| **Environnement** | Simulated (backend uses trained model) | ✅  |
| **Integration**   | REST API endpoint                      | ✅  |

---

## Usage Example

### From Frontend (JavaScript)

```javascript
const response = await fetch("http://localhost:8000/recommend_indexes", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    message: 'SELECT * FROM user WHERE country = "DZ"',
  }),
});

const data = await response.json();
console.log(data.rl_recommendations.sql_statements);
// ["CREATE INDEX idx_user_country ON user(country);", ...]
```

### From Python/Testing

```python
import requests

response = requests.post('http://localhost:8000/recommend_indexes', json={
    'message': 'SELECT * FROM transactions WHERE amount > 1000'
})

print(response.json()['rl_recommendations']['recommended_indexes'])
```

---

## Ready for Demo! ✅

Your backend now has:

1. ✅ ML prediction endpoint (`/chat`) - Predicts if query is slow
2. ✅ RL recommendation endpoint (`/recommend_indexes`) - Suggests optimal indexes
3. ✅ Both use real SADOP schema
4. ✅ Annexe A compliant RL integration
