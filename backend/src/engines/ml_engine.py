import os
import joblib
import numpy as np
from typing import Dict
from xgboost import XGBClassifier

MODEL_PATH = os.path.join(os.path.dirname(__file__), "../../../research/ml/models/xgboost_slow_query_model.json")
model = XGBClassifier()
if os.path.exists(MODEL_PATH):
    model.load_model(MODEL_PATH)
else:
    print(f"⚠️ Warning: ML model not found at {MODEL_PATH}")

FEATURES = [
    "tables_count", "query_length", "has_sum", "has_group_by", "has_where",
    "estimated_rows", "uses_index", "full_table_scan", "uses_filesort", "uses_temp_table"
]

def predict_query_performance(features: Dict) -> Dict:
    X = np.array([[features[f] for f in FEATURES]])
    prediction = int(model.predict(X)[0]) 
    probability = float(model.predict_proba(X)[0][1])  
    is_slow = bool(prediction)
    return {
        "is_slow": is_slow,
        "slow_probability": round(probability, 3),
        "diagnosis": (
            f"Query is likely slow (ML confidence: {probability:.1%})"
            if is_slow
            else f"Query is likely fast (ML confidence: {(1-probability):.1%})"
        )
    }

def extract_query_features(sql: str) -> Dict:
    """Extracts basic features from SQL for ML/RL models."""
    sql_upper = sql.upper()
    return {
        "tables_count": 1 + sql_upper.count(" JOIN ") + sql_upper.count(","), # rough estimate
        "query_length": len(sql),
        "has_sum": 1 if "SUM(" in sql_upper else 0,
        "has_group_by": 1 if "GROUP BY" in sql_upper else 0,
        "has_where": 1 if "WHERE" in sql_upper else 0,
        "estimated_rows": 1000, # Mock default
        "uses_index": 0,        # Mock default
        "full_table_scan": 1 if "WHERE" not in sql_upper else 0,
        "uses_filesort": 1 if "ORDER BY" in sql_upper else 0,
        "uses_temp_table": 1 if "GROUP BY" in sql_upper else 0
    }

__all__ = ['predict_query_performance', 'FEATURES', 'extract_query_features']
