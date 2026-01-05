$ErrorActionPreference = "Continue"

function Commit-File {
    param (
        [string]$File,
        [string]$Msg,
        [string]$Date,
        [string]$Action = "Add", 
        [string]$Content = ""
    )

    Write-Host "Processing: $Msg ($Date)"
    
    # Set environment variables for both Author and Committer date
    $env:GIT_AUTHOR_DATE = $Date
    $env:GIT_COMMITTER_DATE = $Date

    try {
        if ($Action -eq "Create") {
            if (-not (Test-Path $File)) {
                $dir = Split-Path $File -Parent
                if ($dir -and -not (Test-Path $dir)) { New-Item -Path $dir -ItemType Directory -Force | Out-Null }
                New-Item -Path $File -ItemType File -Force -Value $Content | Out-Null
            }
        }
        elseif ($Action -eq "Modify") {
            Add-Content -Path $File -Value "`n$Content"
        }
        
        if (Test-Path $File) {
            git add $File
            $gitCommit = git commit -m "$Msg" 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-Warning "Git commit failed for $($File): $($gitCommit)"
            } else {
                Write-Host "Success."
            }
        } else {
            Write-Warning "File not found: $File"
        }
    } catch {
        Write-Error "Exception: $_"
    } finally {
        # Clear env vars after commit to be safe
        Remove-Item Env:GIT_AUTHOR_DATE
        Remove-Item Env:GIT_COMMITTER_DATE
    }
}

# Define the commits for Jan 16–20 (3 commits per day, 15 total)
$commits = @(
    # Jan 16
    @{ Date="2026-01-16T09:15:00"; File="research/ml/1_Data Pipeline for AI .ipynb"; Msg="research: migrate data pipeline notebook into ml module"; Action="Add" },
    @{ Date="2026-01-16T14:05:00"; File="research/ml/2_exploratory_analysis.ipynb"; Msg="research: organize ML exploratory analysis notebook"; Action="Add" },
    @{ Date="2026-01-16T18:42:00"; File="research/ml/models/xgboost_slow_query_model.pkl"; Msg="models: register xgboost slow query model artifact"; Action="Add" },
    # Jan 17
    @{ Date="2026-01-17T09:27:00"; File="research/notebooks/02_mysql_connection.ipynb"; Msg="notebooks: relocate MySQL connection setup into research hub"; Action="Add" },
    @{ Date="2026-01-17T13:50:00"; File="research/notebooks/08_Generate Realistic Slow Queries and Metrics.ipynb"; Msg="notebooks: consolidate slow query generation workflow"; Action="Add" },
    @{ Date="2026-01-17T19:03:00"; File="research/notebooks/09_Execution_Plan_and_Performance_Features.ipynb.ipynb"; Msg="notebooks: document execution plan feature extraction"; Action="Add" },
    # Jan 18
    @{ Date="2026-01-18T10:02:00"; File="research/rl/envs.py"; Msg="rl: expose custom database index optimization environment"; Action="Add" },
    @{ Date="2026-01-18T15:18:00"; File="research/rl/train.py"; Msg="rl: script PPO training loop for index optimizer"; Action="Add" },
    @{ Date="2026-01-18T21:11:00"; File="research/rl/Models/ppo_index_optimizer.zip"; Msg="rl: checkpoint PPO index optimizer model"; Action="Add" },
    # Jan 19
    @{ Date="2026-01-19T09:40:00"; File="backend/main.py"; Msg="backend: wire FastAPI entrypoint for SADOP services"; Action="Add" },
    @{ Date="2026-01-19T14:22:00"; File="backend/src/core/database.py"; Msg="backend: centralize MySQL connectivity utilities"; Action="Add" },
    @{ Date="2026-01-19T19:37:00"; File="backend/src/engines/ml_engine.py"; Msg="backend: hook ML performance engine into core stack"; Action="Add" },
    # Jan 20
    @{ Date="2026-01-20T09:05:00"; File="frontend/app/page.tsx"; Msg="frontend: implement SADOP assistant chat interface"; Action="Add" },
    @{ Date="2026-01-20T14:48:00"; File="frontend/FRONTEND_UPDATE.md"; Msg="docs: capture frontend update and routing notes"; Action="Add" },
    @{ Date="2026-01-20T20:10:00"; File="ReadME.MD"; Msg="docs: align top-level README with new project layout"; Action="Add" }
)

foreach ($c in $commits) {
    Commit-File -File $c.File -Msg $c.Msg -Date $c.Date -Action $c.Action -Content $c.Content
}

Write-Host "Corrected commits completed."



# ---------------------------Exxplain-----------------------------------------------

# Backdated Commits Master Guide 🚀
# This guide provides a reusable template and a systemic approach to filling your GitHub contribution graph for any project.

# 📝 The Core Concept
# GitHub's contribution graph relies on two specific pieces of metadata in a commit:

# Author Date: When the work was originally done.
# Committer Date: When the commit was actually created.
# To "light up" the graph for past dates, both must be set to the past timestamp.

# 🛠️ Step-by-Step Implementation Plan
# 1. Preparation
# Identify Changes: Decide which files you want to commit. It can be a large feature broken into pieces or documentation updates.
# Clean State: Ensure your workspace is clean. Run git status.
# Base Commit: Identify the last "real" commit hash. You'll need this if you ever need to reset and start over: git log --oneline.
# 2. The Universal Commit Script
# Create a file named backdate.ps1 in your project root. Use this template:

# powershell
# # --- CONFIGURATION ---
# $commits = @(
#     # Format: @{ Date="YYYY-MM-DDTHH:MM:SS"; File="path/to/file"; Msg="Commit Message"; Action="Add/Create/Modify" }
#     @{ Date="2026-01-01T10:00:00"; File="README.md"; Msg="Initial setup"; Action="Add" },
#     @{ Date="2026-01-01T15:00:00"; File="script.py"; Msg="Core logic"; Action="Add" }
# )
# # ----------------------
# function Execute-Backdated-Commit {
#     param ($File, $Msg, $Date, $Action, $Content)
    
#     $env:GIT_AUTHOR_DATE = $Date
#     $env:GIT_COMMITTER_DATE = $Date
#     if ($Action -eq "Create") {
#         New-Item -Path $File -ItemType File -Force -Value $Content | Out-Null
#     }
    
#     git add $File
#     git commit -m "$Msg"
    
#     Remove-Item Env:GIT_AUTHOR_DATE
#     Remove-Item Env:GIT_COMMITTER_DATE
# }
# foreach ($c in $commits) {
#     Execute-Backdated-Commit @c
# }
# 3. Execution & Verification
# Run the script: powershell -ExecutionPolicy Bypass -File backdate.ps1.
# Verify locally: Run this command to check if both dates are correct: git log --format="%h | AD: %ad | CD: %cd | %s" -n 10
# 4. Pushing to GitHub
# If you are adding commits to a branch that already exists on GitHub, you must force push: git push origin main --force

# 📈 Strategy for Different Commit Sizes
# Target Commits	Strategy
# Small (1-10)	Commit major files individually (e.g., main.py, utils.py, 
# README.md
# ).
# Medium (20-50)	Break files into parts. Commit the folder structure first, then individual functions or assets.
# Large (100+)	Use a "documentation and polishing" loop. Commit a file, then modify its subtitle/comments in subsequent commits.
# ⚠️ Important Tips
# UTC vs Local: Git handles dates best in ISO 8601 format: YYYY-MM-DDTHH:MM:SS.
# Conflicts: If your push is rejected, it means someone else (or your past self) pushed to GitHub. Use git pull --rebase or git reset before trying again.
# Graph Delay: It can take up to 24 hours for the GitHub contribution graph to update after a force push.
