"use client";

import { useState } from "react";

export default function Home() {
  const [input, setInput] = useState("");
  const [response, setResponse] = useState("");
  const [loading, setLoading] = useState(false);

  // Format response with markdown-style bold and SQL code blocks
  const formatResponse = (text: string) => {
    const parts = [];
    let currentIndex = 0;

    // Split by code blocks first (```sql ... ```)
    const codeBlockRegex = /```sql\n([\s\S]*?)```/g;
    let match;

    while ((match = codeBlockRegex.exec(text)) !== null) {
      // Add text before code block
      if (match.index > currentIndex) {
        const beforeText = text.substring(currentIndex, match.index);
        parts.push(formatTextWithBold(beforeText));
      }

      // Add code block
      parts.push(
        <div
          key={`code-${match.index}`}
          style={{
            backgroundColor: "#1e293b",
            border: "1px solid #334155",
            borderRadius: 8,
            padding: 16,
            marginTop: 12,
            marginBottom: 12,
            fontFamily: "monospace",
            fontSize: 14,
            color: "#22d3ee",
            overflowX: "auto",
            whiteSpace: "pre",
          }}
        >
          {match[1].trim()}
        </div>,
      );

      currentIndex = match.index + match[0].length;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      parts.push(formatTextWithBold(text.substring(currentIndex)));
    }

    return parts;
  };

  // Format text with **bold** converted to actual bold
  const formatTextWithBold = (text: string) => {
    const parts = [];
    const boldRegex = /\*\*(.*?)\*\*/g;
    let lastIndex = 0;
    let match;
    let key = 0;

    while ((match = boldRegex.exec(text)) !== null) {
      // Add text before bold
      if (match.index > lastIndex) {
        parts.push(text.substring(lastIndex, match.index));
      }

      // Add bold text
      parts.push(
        <strong
          key={`bold-${key++}`}
          style={{ fontWeight: 700, color: "#38bdf8" }}
        >
          {match[1]}
        </strong>,
      );

      lastIndex = match.index + match[0].length;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      parts.push(text.substring(lastIndex));
    }

    return <span key={`text-${Math.random()}`}>{parts}</span>;
  };

  const sendMessage = async () => {
    if (!input.trim()) return;

    setLoading(true);
    setResponse("");

    try {
      const apiUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8000";
      const res = await fetch(`${apiUrl}/assistant`, {
        // CHANGED: Now uses intelligent endpoint
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ message: input }),
      });

      const data = await res.json();

      if (!res.ok) {
        let errMsg = `Error ${res.status}`;
        if (data?.detail) {
          errMsg =
            typeof data.detail === "string"
              ? data.detail
              : Array.isArray(data.detail)
                ? data.detail
                    .map((d: { msg?: string }) => d.msg || "")
                    .join(" ")
                : String(data.detail);
        }
        setResponse(`❌ ${errMsg}`);
        return;
      }

      // Handle response - LLM already includes ALL details!
      if (data.diagnosis) {
        // LLM provides comprehensive response with ML, RL, metrics, everything!
        setResponse(data.diagnosis);
      } else if (data.response) {
        // General response from /assistant
        setResponse(data.response);
      } else if (data.error) {
        setResponse(`❌ ${data.error}`);
      } else {
        setResponse("No response from API.");
      }
    } catch (err) {
      const msg = err instanceof Error ? err.message : "Unknown error";
      setResponse(
        msg.includes("fetch") || msg.includes("network")
          ? "❌ Backend not reachable. Is FastAPI running on port 8000?"
          : `❌ ${msg}`,
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <main
      style={{
        minHeight: "100vh",
        background: "radial-gradient(circle at top, #0f172a, #020617)",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        padding: 24,
        color: "#e5e7eb",
        fontFamily: "Inter, system-ui, sans-serif",
      }}
    >
      <div
        style={{
          width: "100%",
          maxWidth: 900,
          background: "rgba(15, 23, 42, 0.85)",
          borderRadius: 16,
          padding: 32,
          boxShadow: "0 0 40px rgba(56, 189, 248, 0.15)",
          border: "1px solid rgba(148, 163, 184, 0.15)",
        }}
      >
        {/* Title */}
        <h1
          style={{
            fontSize: 32,
            fontWeight: 700,
            marginBottom: 8,
            background: "linear-gradient(90deg, #38bdf8, #818cf8)",
            WebkitBackgroundClip: "text",
            WebkitTextFillColor: "transparent",
          }}
        >
          🧠 SADOP - Intelligent DBA Assistant
        </h1>

        <p style={{ color: "#94a3b8", marginBottom: 24 }}>
          Powered by ML + RL + LLM (Groq Llama 3.3 70B) • Paste your SQL query
          below
        </p>

        {/* Textarea */}
        <textarea
          placeholder="AI Assistance for beter and optimazed query and administartio of MYSQL '"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          rows={6}
          style={{
            width: "100%",
            resize: "none",
            padding: 16,
            borderRadius: 12,
            background: "#020617",
            color: "#e5e7eb",
            border: "1px solid rgba(148, 163, 184, 0.25)",
            outline: "none",
            fontSize: 16,
            lineHeight: 1.6,
            boxShadow: "inset 0 0 0 1px transparent",
            fontFamily: "monospace",
          }}
        />

        {/* Button */}
        <button
          onClick={sendMessage}
          disabled={loading}
          style={{
            marginTop: 20,
            width: "100%",
            padding: "14px 0",
            fontSize: 18,
            fontWeight: 600,
            borderRadius: 12,
            border: "none",
            cursor: loading ? "not-allowed" : "pointer",
            color: "#020617",
            background: "linear-gradient(90deg, #38bdf8, #818cf8, #38bdf8)",
            backgroundSize: "200% 100%",
            animation: loading ? "none" : "shine 3s linear infinite",
            boxShadow: "0 0 20px rgba(56, 189, 248, 0.6)",
            transition: "transform 0.15s ease, box-shadow 0.15s ease",
          }}
          onMouseEnter={(e) => {
            e.currentTarget.style.transform = "scale(1.02)";
            e.currentTarget.style.boxShadow =
              "0 0 30px rgba(99, 102, 241, 0.8)";
          }}
          onMouseLeave={(e) => {
            e.currentTarget.style.transform = "scale(1)";
            e.currentTarget.style.boxShadow =
              "0 0 20px rgba(56, 189, 248, 0.6)";
          }}
        >
          {loading ? "🔍 Analyzing with AI..." : "🚀 Get Intelligent Diagnosis"}
        </button>

        {/* Response */}
        {response && (
          <div
            style={{
              marginTop: 28,
              padding: 24,
              borderRadius: 12,
              background: "linear-gradient(135deg, #1e293b 0%, #0f172a 100%)",
              border: "1px solid rgba(56, 189, 248, 0.3)",
              whiteSpace: "pre-wrap",
              lineHeight: 1.8,
              boxShadow: "0 0 30px rgba(56, 189, 248, 0.1)",
              fontSize: 15,
            }}
          >
            {formatResponse(response)}
          </div>
        )}

        {/* Animation */}
        <style>
          {`
            @keyframes shine {
              0% { background-position: 0% 50%; }
              100% { background-position: 200% 50%; }
            }
          `}
        </style>
      </div>
    </main>
  );
}
