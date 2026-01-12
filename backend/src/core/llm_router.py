import os
from groq import Groq
from typing import Dict, Optional
from dotenv import load_dotenv
from src.engines.ml_engine import predict_query_performance
from src.engines.rl_engine import recommend_indexes_for_query

load_dotenv()
client = Groq(api_key=os.getenv("GROQ_API_KEY"))
MODEL = "llama-3.3-70b-versatile"


def classify_prompt(user_input: str) -> Dict:
    classification_prompt = f"""You are a database assistant classifier. Analyze this user input and determine:

User Input: "{user_input}"

Classification Rules:
1. If it contains SQL (SELECT, INSERT, UPDATE, DELETE, etc.) → "sql_query"
2. If it asks "best query for...", "optimized query for...", "generate query for..." → "query_generation"
3. If it asks "why slow?", "performance issues?", "optimize?" → "general_question" 
4. If it asks for index recommendations → "optimization_request"

Respond ONLY with JSON:
{{
    "type": "sql_query" | "query_generation" | "general_question" | "optimization_request",
    "intent": "brief description",
    "requires_sql": true/false
}}"""

    try:
        response = client.chat.completions.create(
            messages=[{"role": "user", "content": classification_prompt}],
            model=MODEL,
            temperature=0.2,
            max_tokens=100,
        )
        
        import json
        result = json.loads(response.choices[0].message.content)
        return result
    except Exception as e:
        user_lower = user_input.lower()
        sql_keywords = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "DROP", "ALTER"]
        is_sql = any(kw.lower() in user_lower for kw in sql_keywords)
        gen_keywords = ["best query", "optimized query", "generate query", "create query", "best sql", "optimized sql"]
        is_query_gen = any(keyword in user_lower for keyword in gen_keywords)
        
        if is_sql:
            return {"type": "sql_query", "intent": "SQL query", "requires_sql": False}
        elif is_query_gen:
            return {"type": "query_generation", "intent": "Generate optimized query", "requires_sql": False}
        else:
            return {"type": "general_question", "intent": "General database question", "requires_sql": False}


def handle_general_question(user_input: str, context: Optional[Dict] = None) -> str:
    tool_calling_prompt = f"""You are SADOP - an expert database performance assistant with TWO TOOLS:

**TOOL 1: ML Diagnostic** - Predicts if query is slow/fast
**TOOL 2: RL Optimization** - Recommends optimal indexes

When user asks "Why is system slow?", you MUST:
1. First explain you'll run diagnostics (Tool 1)
2. Analyze the problem using available context
3. Then recommend optimizations (Tool 2)
4. Provide actionable SQL commands

Available Context:
{context if context else "No specific query provided"}

User Question: "{user_input}"

Instructions:
- If asking about slowness → Mention diagnostic tools + index recommendations
- If asking for optimization → Explain what Tool 1 found, then Tool 2 recommendations
- If general advice → Provide database best practices
- Always be specific and actionable
- Mention "I can analyze specific queries if you provide SQL"

Respond professionally in 150 words max."""

    try:
        response = client.chat.completions.create(
            messages=[
                {
                    "role": "system",
                    "content": "You are SADOP, a database performance expert with ML diagnostic and RL optimization tools."
                },
                {
                    "role": "user",
                    "content": tool_calling_prompt
                }
            ],
            model=MODEL,
            temperature=0.4,
            max_tokens=400,
        )
        return response.choices[0].message.content
    except Exception as e:
        return f"I'm SADOP, your database assistant... error: {str(e)}"

def handle_optimization_request(user_input: str) -> str:
    optimization_prompt = f"""You are a database optimization expert. User is asking for optimization help:
"{user_input}"
Provide indexing best practices and common patterns."""
    try:
        response = client.chat.completions.create(
            messages=[{"role": "user", "content": optimization_prompt}],
            model=MODEL,
            temperature=0.3,
            max_tokens=300,
        )
        return response.choices[0].message.content
    except:
        return "Database Optimization Tips..."

__all__ = ['classify_prompt', 'handle_general_question', 'handle_optimization_request']
