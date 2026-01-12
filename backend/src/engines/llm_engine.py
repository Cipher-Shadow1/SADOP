import os
from groq import Groq
from typing import Dict, List
from dotenv import load_dotenv
import json

load_dotenv()
client = Groq(api_key=os.getenv("GROQ_API_KEY"))
MODEL = "llama-3.3-70b-versatile"

def generate_llm_diagnosis(query: str, ml_result: Dict, rl_result: Dict, query_features: Dict) -> str:
    ml_verdict = "SLOW QUERY ⚠️" if ml_result["is_slow"] else "FAST QUERY ✅"
    prompt = f"Diagnose this SQL query: {query}. ML results: {ml_result}. RL recommendations: {rl_result}."
    try:
        response = client.chat.completions.create(
            messages=[{"role": "user", "content": prompt}],
            model=MODEL,
            temperature=0.3,
            max_tokens=800,
        )
        return response.choices[0].message.content
    except Exception as e:
        return f"Verdict: {ml_verdict}. RL Recommendations: {rl_result.get('recommended_indexes')}."

def generate_query_variations(user_request: str, tables_info: Dict = None) -> Dict:
    prompt = f"Generate ONE simple SQL query for: {user_request}"
    try:
        response = client.chat.completions.create(
            messages=[{"role": "user", "content": prompt}],
            model=MODEL,
            temperature=0.5,
            max_tokens=500,
        )
        return {"query": "SELECT * FROM user", "explanation": "Restored placeholder"}
    except:
        return {"query": "SELECT * FROM user", "explanation": "Fallback"}

def generate_recommendation_explanation(rl_result: Dict) -> str:
    """Uses LLM to explain the index recommendations in natural language."""
    indexes = rl_result.get("recommended_indexes", [])
    if not indexes:
        return "No specific index recommendations at this time."
    
    prompt = f"Explain why these database indexes are recommended: {', '.join(indexes)}. Keep it concise."
    try:
        response = client.chat.completions.create(
            messages=[{"role": "user", "content": prompt}],
            model=MODEL,
            temperature=0.3,
            max_tokens=300,
        )
        return response.choices[0].message.content
    except Exception as e:
        return f"Recommended indexes: {', '.join(indexes)}."
