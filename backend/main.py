from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from src.engines.ml_engine import predict_query_performance, extract_query_features
from src.engines.rl_engine import recommend_indexes_for_query
from src.engines.llm_engine import generate_llm_diagnosis, generate_recommendation_explanation, generate_query_variations
from src.core.llm_router import classify_prompt, handle_general_question, handle_optimization_request
from src.core.database import get_db_connection

app = FastAPI(title="SADOP API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class UserQuery(BaseModel):
    message: str

@app.post("/assistant")
async def assistant_endpoint(query: UserQuery):
    classification = classify_prompt(query.message)
    
    if classification["type"] == "sql_query":
        # Analyze the SQL query
        features = extract_query_features(query.message)
        ml_result = predict_query_performance(features)
        rl_result = recommend_indexes_for_query(features)
        
        diagnosis = generate_llm_diagnosis(query.message, ml_result, rl_result, features)
        return {
            "type": "sql_query",
            "diagnosis": diagnosis,
            "ml_result": ml_result,
            "rl_result": rl_result
        }
        
    elif classification["type"] == "query_generation":
        # Generate an optimized query
        gen_result = generate_query_variations(query.message)
        features = extract_query_features(gen_result["query"])
        rl_result = recommend_indexes_for_query(features)
        
        return {
            "type": "query_generation",
            "generated_query": gen_result["query"],
            "explanation": gen_result["explanation"],
            "rl_result": rl_result
        }
    
    elif classification["type"] == "optimization_request":
        response = handle_optimization_request(query.message)
        return {"response": response, "type": "optimization_request"}
        
    else:
        response = handle_general_question(query.message)
        return {"response": response, "type": "general_question"}

@app.post("/chat")
async def chat_endpoint(query: UserQuery):
    """Alias for assistant endpoint to support verification scripts."""
    return await assistant_endpoint(query)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
