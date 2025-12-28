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

# Define the commits for Dec 16–18, 2025 (5 commits per day, 15 total)
$commits = @(
    # Dec 16, 2025
    @{ Date="2025-12-16T09:12:00"; File=".gitignore"; Msg="chore: refine gitignore for notebooks and cache artifacts"; Action="Add" },
    @{ Date="2025-12-16T10:34:00"; File="notebooks/01_environment_check.ipynb"; Msg="notebooks: verify Python environment and dependencies for SADOP"; Action="Add" },
    @{ Date="2025-12-16T13:58:00"; File="notebooks/02_mysql_connection.ipynb"; Msg="notebooks: document resilient MySQL connection workflow"; Action="Add" },
    @{ Date="2025-12-16T16:21:00"; File="notebooks/03_generate_fake_data.ipynb"; Msg="notebooks: add controlled fake workload generation for testing"; Action="Add" },
    @{ Date="2025-12-16T18:47:00"; File="db/sadop_db_backup.sql"; Msg="db: check in initial SADOP schema and seed backup"; Action="Add" },

    # Dec 17, 2025
    @{ Date="2025-12-17T09:05:00"; File="notebooks/04_generate_data_Frame.ipynb"; Msg="notebooks: convert raw query metrics into analysis-ready dataframe"; Action="Add" },
    @{ Date="2025-12-17T11:32:00"; File="notebooks/05_Database_Backup.ipynb"; Msg="notebooks: formalize automated MySQL backup workflow"; Action="Add" },
    @{ Date="2025-12-17T14:16:00"; File="notebooks/06_MySQL_Monitoring_Setup.ipynb"; Msg="notebooks: set up MySQL monitoring views for SADOP"; Action="Add" },
    @{ Date="2025-12-17T16:49:00"; File="notebooks/07_Enable_Performance_Schema.ipynb"; Msg="notebooks: enable performance_schema and validate instrumentation"; Action="Add" },
    @{ Date="2025-12-17T19:23:00"; File="notebooks/08_Capture Performance Metrics.ipynb"; Msg="notebooks: capture baseline performance metrics under load"; Action="Add" },

    # Dec 18, 2025
    @{ Date="2025-12-18T09:18:00"; File="notebooks/09_Simulate_Queries and Capture Metrics.ipynb"; Msg="notebooks: simulate mixed query workloads and log metrics"; Action="Add" },
    @{ Date="2025-12-18T11:44:00"; File="notebooks/10_Generate Realistic Slow Queries and Metrics.ipynb"; Msg="notebooks: generate realistic slow query scenarios for training"; Action="Add" },
    @{ Date="2025-12-18T14:27:00"; File="notebooks/11_Data Pipeline for AI .ipynb"; Msg="notebooks: assemble end-to-end data pipeline for AI modeling"; Action="Add" },
    @{ Date="2025-12-18T16:58:00"; File="notebooks/12_Exploratory Analysis & Linear Regression.ipynb"; Msg="notebooks: run exploratory analysis and baseline regression model"; Action="Add" },
    @{ Date="2025-12-18T19:36:00"; File="ReadME.MD"; Msg="docs: outline SADOP project goals and notebook structure"; Action="Add" }
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
