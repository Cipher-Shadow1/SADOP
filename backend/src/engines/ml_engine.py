import os
import joblib
import numpy as np
from typing import Dict


MODEL_PATH = os.path.join(os.path.dirname(__file__), "../../../ML/models V2/random_forest.pkl")

if os.path.exists(MODEL_PATH):
    model = joblib.load(MODEL_PATH)
    print(f"✅ Random Forest model loaded from {MODEL_PATH}")
else:
    model = None
    print(f"⚠️  Warning: ML model not found at {MODEL_PATH}")


FEATURES = [
    "rows_returned",
    "tables_count",
    "query_length",
    "has_sum",
    "has_group_by",
    "has_where",
    "cpu_usage",
    "estimated_rows",
    "uses_index",
    "full_table_scan",
    "uses_filesort",
    "uses_temp_table",
]



def predict_query_performance(features: Dict) -> Dict:
    if model is None:
        return {
            "is_slow": None,
            "slow_probability": None,
            "diagnosis": "ML model not loaded — prediction unavailable.",
        }

    X = np.array([[features.get(f, 0) for f in FEATURES]])

    prediction  = int(model.predict(X)[0])
    probability = float(model.predict_proba(X)[0][1])
    is_slow     = bool(prediction)

    return {
        "is_slow":          is_slow,
        "slow_probability": round(probability, 3),
        "diagnosis": (
            f"Query is likely slow (RF confidence: {probability:.1%})"
            if is_slow
            else f"Query is likely fast (RF confidence: {(1 - probability):.1%})"
        ),
    }



def extract_query_features(sql: str) -> Dict:
    """
    Extracts static features from a raw SQL string.
    EXPLAIN-based features (estimated_rows, uses_index, etc.)
    default to conservative values — override with real EXPLAIN
    output when available.
    """
    sql_upper = sql.upper()

    return {
        # ── Static features ──
        "rows_returned":    0,      # unknown before execution
        "tables_count":     1 + sql_upper.count(" JOIN "),
        "query_length":     len(sql),
        "has_sum":          int("SUM("      in sql_upper),
        "has_group_by":     int("GROUP BY"  in sql_upper),
        "has_where":        int("WHERE"     in sql_upper),
        "cpu_usage":        0.0,    # unknown before execution
        # ── EXPLAIN-based features (best-effort defaults) ──
        "estimated_rows":   1000,
        "uses_index":       0,
        "full_table_scan":  int("WHERE" not in sql_upper),
        "uses_filesort":    int("ORDER BY"  in sql_upper),
        "uses_temp_table":  int("GROUP BY"  in sql_upper),
    }


__all__ = ["predict_query_performance", "extract_query_features", "FEATURES"]