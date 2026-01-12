import mysql.connector
from mysql.connector import Error
import re
from typing import Dict, List, Any

def get_db_connection():
    """Establishes and returns a connection to the MySQL database."""
    try:
        conn = mysql.connector.connect(
            host="127.0.0.1",
            port=3307,
            database="SADOP_BDD",
            user="sadop_user",
            password="1234"
        )
        if conn.is_connected():
            print("Connected as sadop_user")
            return conn
    except Error as e:
        print(f"Error while connecting to MySQL: {e}")
        return None

def get_database_schema(conn):
    """Retrieves the schema of the connected database."""
    if not conn:
        return "No database connection available."
    
    schema_info = []
    try:
        cursor = conn.cursor()
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        
        for (table_name,) in tables:
            schema_info.append(f"Table: {table_name}")
            cursor.execute(f"DESCRIBE {table_name}")
            columns = cursor.fetchall()
            for col in columns:
                # Field, Type, Null, Key, Default, Extra
                field, type_, null, key, default, extra = col
                schema_info.append(f"  - {field} ({type_}) {'NULL' if null == 'YES' else 'NOT NULL'} {key} {extra}")
            schema_info.append("") # Empty line between tables
            
        cursor.close()
        return "\n".join(schema_info)
    except Error as e:
        return f"Error retrieving schema: {e}"


def execute_select_query(sql_query: str) -> Dict[str, Any]:
    """
    Safely execute SELECT queries and return results
    
    Security:
    - Only allows SELECT statements
    - Limits results to 1000 rows max
    - Handles errors gracefully
    """
    
    # Validate: Only SELECT queries allowed
    sql_query_clean = sql_query.strip().upper()
    
    # Check if it's a SELECT query
    if not sql_query_clean.startswith("SELECT"):
        return {
            "success": False,
            "error": "Only SELECT queries are allowed for security reasons",
            "data": [],
            "row_count": 0,
            "columns": []
        }
    
    # Check for dangerous keywords
    dangerous_keywords = ["DROP", "DELETE", "INSERT", "UPDATE", "ALTER", "CREATE", "TRUNCATE"]
    for keyword in dangerous_keywords:
        if keyword in sql_query_clean:
            return {
                "success": False,
                "error": f"Query contains forbidden keyword: {keyword}",
                "data": [],
                "row_count": 0,
                "columns": []
            }
    
    # Execute query
    conn = None
    cursor = None
    
    try:
        conn = get_db_connection()
        if not conn:
            return {
                "success": False,
                "error": "Failed to connect to database",
                "data": [],
                "row_count": 0,
                "columns": []
            }
        
        cursor = conn.cursor(dictionary=True)
        
        # Add LIMIT if not present
        if "LIMIT" not in sql_query_clean:
            sql_query = f"{sql_query.rstrip(';')} LIMIT 1000"
        
        # Execute query
        cursor.execute(sql_query)
        results = cursor.fetchall()
        
        # Get column names
        columns = [desc[0] for desc in cursor.description] if cursor.description else []
        
        return {
            "success": True,
            "data": results,
            "row_count": len(results),
            "columns": columns,
            "error": None
        }
        
    except Error as e:
        print(f"Database error: {e}")
        return {
            "success": False,
            "error": f"Database error: {str(e)}",
            "data": [],
            "row_count": 0,
            "columns": []
        }
    
    finally:
        if cursor:
            cursor.close()
        if conn and conn.is_connected():
            conn.close()
