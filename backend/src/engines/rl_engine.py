import numpy as np
import os
from stable_baselines3 import PPO
from typing import List, Dict

MODEL_PATH = os.path.join(os.path.dirname(__file__), "../../../rl/Models/ppo_index_optimizer.zip")

SCHEMA = {
    "user": ["user_id", "full_name", "email", "country", "signup_date"],
    "accounts": ["account_id", "user_id", "account_type", "balance", "created_at"],
    "transactions": ["transaction_id", "account_id", "amount", "transaction_type", "transaction_date", "status"],
    "logs": ["log_id", "user_id", "log_level", "created_at"]
}

COLUMNS = []
for table, cols in SCHEMA.items():
    for col in cols:
        COLUMNS.append(f"{table}.{col}")

NUM_COLUMNS = len(COLUMNS)


class RLIndexRecommender:
    def __init__(self):
        if not os.path.exists(MODEL_PATH):
            raise FileNotFoundError(f"RL model not found at {MODEL_PATH}")
        self.model = PPO.load(MODEL_PATH)
        print(f"✅ RL Model loaded from {MODEL_PATH}")

    def analyze_workload(self, query_features: Dict) -> np.ndarray:
        workload = np.zeros(NUM_COLUMNS, dtype=np.float32)
        if query_features.get("has_where", 0) == 1:
            for i, col in enumerate(COLUMNS):
                if any(x in col for x in ["user_id", "account_id", "transaction_id", "email", "country"]):
                    workload[i] = 0.8
        return workload

    def recommend_indexes(self, query_features: Dict, max_steps: int = 30) -> Dict:
        workload       = self.analyze_workload(query_features)
        hot_columns    = [(i, workload[i]) for i in range(NUM_COLUMNS) if workload[i] > 0.5]
        recommended    = [COLUMNS[i] for i, _ in hot_columns[:3]]
        sql_statements = [
            f"CREATE INDEX idx_{c.replace('.', '_')} ON {c.split('.')[0]}({c.split('.')[1]});"
            for c in recommended
        ]
        return {
            "recommended_indexes":      recommended,
            "sql_statements":           sql_statements,
            "total_indexes":            len(recommended),
            "recommendations_by_table": {},
        }


_rl_recommender = None


def get_rl_recommender() -> RLIndexRecommender:
    global _rl_recommender
    if _rl_recommender is None:
        _rl_recommender = RLIndexRecommender()
    return _rl_recommender


def recommend_indexes_for_query(query_features: Dict) -> Dict:
    recommender = get_rl_recommender()
    return recommender.recommend_indexes(query_features)


def get_rl_status() -> Dict:
    """Returns the current load status of the RL model."""
    return {
        "model_loaded":  _rl_recommender is not None,
        "model_path":    MODEL_PATH,
        "model_exists":  os.path.exists(MODEL_PATH),
    }


# ─────────────────────────────────────────────
# Eager load at import time
# Shows status immediately on server start — no silent failures
# ─────────────────────────────────────────────
try:
    get_rl_recommender()
except FileNotFoundError:
    print(f"⚠️  RL model not found at: {MODEL_PATH}")
    print("    → RL recommendations will be unavailable until the model is placed there.")
except Exception as e:
    print(f"❌ RL model failed to load: {e}")