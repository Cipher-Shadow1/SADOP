# SADOP Endpoint Routing - How It Works

## 📍 Current Architecture

### Frontend → Backend Flow

```
User Input (Frontend)
    ↓
/assistant endpoint (SINGLE ENTRY POINT)
    ↓
classify_prompt() [llm_router.py]
    ↓
Routes to appropriate handler
```

---

## 🧠 Intelligent Classification

**File:** `BackEnd/llm_router.py` → `classify_prompt()`

**How it detects:**

```python
classification_prompt = """
User Input: "{user_input}"

Classification Rules:
1. If contains SQL (SELECT, INSERT, etc.) → "sql_query"
2. If asks "best query for...", "optimized query for..." → "query_generation"
3. If asks "why slow?", "performance issues?" → "general_question"
4. If asks for index recommendations → "optimization_request"
```

**Uses:** Groq LLM (Llama 3.3 70B) to classify!

---

## 🔀 Routing Logic

**File:** `BackEnd/main.py` → `/assistant` endpoint

### Current Routing:

```python
classification = classify_prompt(user_input)

if classification["type"] == "sql_query":
    # Run full ML + RL + LLM diagnosis
    return {...diagnosis...}

elif classification["type"] == "general_question":
    # Return general advice with tool awareness
    return handle_general_question(user_input)

elif classification["type"] == "optimization_request":
    # Return optimization tips
    return handle_optimization_request(user_input)

# MISSING: query_generation handler!
```

---

## ❌ Current Gap

**Query generation requests NOT handled by `/assistant`!**

User says: _"best query for user from Algeria"_

- ✅ Classifies as `query_generation`
- ❌ But `/assistant` doesn't route it!
- Falls through to `general_question` handler

---

## ✅ Solution

Add query generation routing to `/assistant` endpoint!

---

## 📊 Frontend Code

**File:** `frontend/app/page.tsx`

```tsx
// Frontend ALWAYS uses /assistant
const res = await fetch(`${apiUrl}/assistant`, {
  method: "POST",
  body: JSON.stringify({ message: input }),
});

// Backend handles routing automatically!
// No frontend logic needed!
```

---

## 🎯 Complete Flow Example

### Example 1: SQL Query

```
User: "SELECT * FROM user"
  ↓
Frontend → /assistant
  ↓
classify_prompt() → "sql_query"
  ↓
Runs ML + RL + LLM
  ↓
Returns diagnosis
```

### Example 2: Query Generation

```
User: "best query for user from Algeria"
  ↓
Frontend → /assistant
  ↓
classify_prompt() → "query_generation"
  ↓
(CURRENTLY MISSING!)
Should call generate_optimized_query logic
  ↓
Returns best query + diagnosis
```

### Example 3: General Question

```
User: "Why is my system slow?"
  ↓
Frontend → /assistant
  ↓
classify_prompt() → "general_question"
  ↓
handle_general_question()
  ↓
Returns tool-aware response
```

---

## 🔧 Fix Needed

Add to `/assistant` endpoint in `main.py`:

```python
elif classification["type"] == "query_generation":
    # Generate 3 variations, diagnose, select best
    variations = generate_query_variations(user_input)
    # ... scoring logic ...
    return best_query_result
```

**Status:** NOT implemented yet - explaining to user now!
