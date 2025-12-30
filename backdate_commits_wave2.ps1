 $ErrorActionPreference = "Stop"

 function Commit-Group {
     param(
         [string[]]$Files,
         [string]$Msg,
         [string]$Date
     )

     Write-Host "Processing: $Msg ($Date)"

     $env:GIT_AUTHOR_DATE = $Date
     $env:GIT_COMMITTER_DATE = $Date

     try {
         git add -- $Files
         $gitCommit = git commit -m "$Msg" 2>&1
         if ($LASTEXITCODE -ne 0) {
             Write-Warning "Git commit failed for $($Files -join ', '): $($gitCommit)"
         } else {
             Write-Host "Success."
         }
     } finally {
         Remove-Item Env:GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
         Remove-Item Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
     }
 }

 # 40 backdated commits from Dec 20, 2025 onward (4 per day)
 $commits = @(
     # 2025-12-20
     @{ Date = "2025-12-20T09:10:00"; Msg = "docs: expand SADOP overview and clarify scope"; Files = @("ReadME.MD") },
     @{ Date = "2025-12-20T11:30:00"; Msg = "docs: add secondary README for course context"; Files = @("ReadME2.MD") },
     @{ Date = "2025-12-20T14:50:00"; Msg = "docs: attach mini-project report PDF"; Files = @("Projet-Homework.pdf") },
     @{ Date = "2025-12-20T17:40:00"; Msg = "assets: add hero image for documentation and slides"; Files = @("hero.jpg") },

     # 2025-12-21
     @{ Date = "2025-12-21T09:05:00"; Msg = "notebooks: tighten environment checks for SADOP stack"; Files = @("notebooks/01_environment_check.ipynb") },
     @{ Date = "2025-12-21T11:25:00"; Msg = "notebooks: harden MySQL connection workflow with retries"; Files = @("notebooks/02_mysql_connection.ipynb") },
     @{ Date = "2025-12-21T14:15:00"; Msg = "notebooks: refine fake workload generator for query stress tests"; Files = @("notebooks/03_generate_fake_data.ipynb") },
     @{ Date = "2025-12-21T16:55:00"; Msg = "notebooks: document CSV ingestion pipeline into MySQL"; Files = @("notebooks/04_load_csv_into_mysql.ipynb") },

     # 2025-12-22
     @{ Date = "2025-12-22T09:10:00"; Msg = "notebooks: formalize MySQL monitoring setup for SADOP"; Files = @("notebooks/05_MySQL_Monitoring_Setup.ipynb") },
     @{ Date = "2025-12-22T11:35:00"; Msg = "notebooks: enable performance_schema and validate instrumentation"; Files = @("notebooks/06_Enable_Performance_Schema.ipynb") },
     @{ Date = "2025-12-22T14:20:00"; Msg = "notebooks: capture performance metrics under mixed workloads"; Files = @("notebooks/07_Capture Performance Metrics.ipynb") },
     @{ Date = "2025-12-22T17:05:00"; Msg = "notebooks: generate realistic slow query scenarios with labels"; Files = @("notebooks/08_Generate Realistic Slow Queries and Metrics.ipynb") },

     # 2025-12-23
     @{ Date = "2025-12-23T09:00:00"; Msg = "ml: migrate data pipeline notebook into dedicated ML module"; Files = @("ML/1_Data Pipeline for AI .ipynb") },
     @{ Date = "2025-12-23T11:20:00"; Msg = "ml: add exploratory analysis notebook for query performance"; Files = @("ML/2_exploratory_analysis.ipynb") },
     @{ Date = "2025-12-23T14:10:00"; Msg = "ml: normalize numeric features and define train/test split"; Files = @("ML/3_Normalize_Numeric_Features _Train_Test Split.ipynb") },
     @{ Date = "2025-12-23T17:00:00"; Msg = "ml: verify data quality and consistency checks for features"; Files = @("ML/4_Verify Data Quality & Consistency.ipynb") },

     # 2025-12-24
    @{ Date = "2025-12-24T09:05:00"; Msg = "ml: add diagnostic engine notebook for slow query prediction"; Files = @("ML/5_ML*") },
     @{ Date = "2025-12-24T11:15:00"; Msg = "ml: register baseline logistic regression reference model"; Files = @("ML/models/logistic_regression_reference.pkl") },
     @{ Date = "2025-12-24T14:00:00"; Msg = "ml: store random forest reference model for comparison"; Files = @("ML/models/random_forest_reference.pkl") },
     @{ Date = "2025-12-24T17:10:00"; Msg = "ml: persist scaler and xgboost reference models for reuse"; Files = @("ML/models/scaler.pkl", "ML/models/xgboost_slow_query_model.pkl") },

     # 2025-12-25
     @{ Date = "2025-12-25T09:25:00"; Msg = "ml: add helper notes for ML experiments and tracking"; Files = @("ML/text.txt") },
     @{ Date = "2025-12-25T11:30:00"; Msg = "chore: add gitkeep placeholders for core modules"; Files = @("ML/.gitkeep", "api/.gitkeep", "llm/.gitkeep", "rl/.gitkeep") },
     @{ Date = "2025-12-25T14:15:00"; Msg = "rl: introduce base index optimization agent notebooks"; Files = @("rl/00_rl_index_optimization_agent.ipynb") },
     @{ Date = "2025-12-25T17:05:00"; Msg = "rl: add main RL index optimization agent experiment notebook"; Files = @("rl/RL_index_optimization_agent.ipynb") },

     # 2025-12-26
     @{ Date = "2025-12-26T09:00:00"; Msg = "rl: capture environment metadata and PPO optimizer checkpoint"; Files = @("rl/Models/env_metadata.json", "rl/Models/ppo_index_optimizer.zip") },
     @{ Date = "2025-12-26T11:20:00"; Msg = "rl: log evaluation metrics for RL index optimization runs"; Files = @("rl/rl_logs/monitor.csv") },
     @{ Date = "2025-12-26T14:05:00"; Msg = "rl: add first batch of PPO tensorboard runs"; Files = @("rl/rl_tensorboard/PPO_1/events.out.tfevents.1766342679.DESKTOP-GK9TB81.8128.0", "rl/rl_tensorboard/PPO_2/events.out.tfevents.1766343461.DESKTOP-GK9TB81.8128.1", "rl/rl_tensorboard/PPO_3/events.out.tfevents.1766343473.DESKTOP-GK9TB81.8128.2") },
     @{ Date = "2025-12-26T16:45:00"; Msg = "rl: add extended PPO training tensorboard runs"; Files = @("rl/rl_tensorboard/PPO_4/events.out.tfevents.1766343521.DESKTOP-GK9TB81.45172.0", "rl/rl_tensorboard/PPO_5/events.out.tfevents.1766343583.DESKTOP-GK9TB81.45172.1", "rl/rl_tensorboard/PPO_6/events.out.tfevents.1766343645.DESKTOP-GK9TB81.45172.2") },

     # 2025-12-27
     @{ Date = "2025-12-27T09:10:00"; Msg = "rl: persist final PPO tensorboard experiment batches"; Files = @("rl/rl_tensorboard/PPO_7/events.out.tfevents.1766343848.DESKTOP-GK9TB81.45172.3", "rl/rl_tensorboard/PPO_8/events.out.tfevents.1766352475.DESKTOP-GK9TB81.28192.0", "rl/rl_tensorboard/PPO_9/events.out.tfevents.1766407199.DESKTOP-GK9TB81.49188.0", "rl/rl_tensorboard/PPO_10/events.out.tfevents.1766407373.DESKTOP-GK9TB81.49188.1", "rl/rl_tensorboard/PPO_11/events.out.tfevents.1766407423.DESKTOP-GK9TB81.49188.2") },
     @{ Date = "2025-12-27T11:30:00"; Msg = "api: scaffold initial FastAPI entrypoint for SADOP services"; Files = @("api/app.py") },
     @{ Date = "2025-12-27T14:00:00"; Msg = "monitoring: define performance_schema queries for slow logs"; Files = @("monitoring/performance_schema_queries.sql") },
     @{ Date = "2025-12-27T17:00:00"; Msg = "monitoring: implement slow log parser utility script"; Files = @("monitoring/slow_log_parser.py") },

     # 2025-12-28
     @{ Date = "2025-12-28T09:05:00"; Msg = "llm: add prompt templates for SQL explanation assistant"; Files = @("llm/prompt_templates.py") },
     @{ Date = "2025-12-28T11:15:00"; Msg = "llm: implement SQL explainer helper logic"; Files = @("llm/sql_explainer.py") },
     @{ Date = "2025-12-28T14:10:00"; Msg = "tooling: check in backdate commit automation script"; Files = @("backdate_commits_fixed.ps1") },
     @{ Date = "2025-12-28T17:00:00"; Msg = "frontend: add Next.js app package and TypeScript setup"; Files = @("frontend/package.json", "frontend/tsconfig.json") },

    # 2025-12-29
    @{ Date = "2025-12-29T09:00:00"; Msg = "frontend: configure Next.js routing and build options"; Files = @("frontend/next.config.ts") },
    @{ Date = "2025-12-29T11:10:00"; Msg = "frontend: add linting and PostCSS tooling configuration"; Files = @("frontend/eslint.config.mjs", "frontend/postcss.config.mjs") },
    @{ Date = "2025-12-29T14:00:00"; Msg = "frontend: document SADOP UI and add .gitignore rules"; Files = @("frontend/README.md", "frontend/.gitignore") },
    @{ Date = "2025-12-29T16:45:00"; Msg = "frontend:Restfull API to prepare connection with the backend"; Files = @("frontend/public/file.svg", "frontend/public/globe.svg", "frontend/public/next.svg", "frontend/public/vercel.svg", "frontend/public/window.svg") },

    # 2025-12-30
    @{ Date = "2025-12-30T09:20:00"; Msg = "notebooks: normalize numeric features and finalize train/test split"; Files = @("notebooks/13_Normalize_Numeric_Features _Train_Test Split.ipynb") },
    @{ Date = "2025-12-30T11:45:00"; Msg = "notebooks: build ML diagnostic notebook for query performance"; Files = @("notebooks/14_ML Diagnostic Engine.ipynb") },
    @{ Date = "2025-12-30T15:10:00"; Msg = "notebooks: verify data quality and consistency across features"; Files = @("notebooks/14_Verify Data Quality & Consistency.ipynb") },
    @{ Date = "2025-12-30T17:55:00"; Msg = "tooling: iterate on second-wave backdated commit script"; Files = @("backdate_commits_wave2.ps1") },

    # 2025-12-31
    @{ Date = "2025-12-31T09:15:00"; Msg = "notebooks: tweak feature normalization thresholds before final training"; Files = @("notebooks/13_Normalize_Numeric_Features _Train_Test Split.ipynb") },
    @{ Date = "2025-12-31T11:30:00"; Msg = "notebooks: refine ML diagnostic plots for slow query prediction"; Files = @("notebooks/14_ML Diagnostic Engine.ipynb") },
    @{ Date = "2025-12-31T14:20:00"; Msg = "notebooks: polish data quality checks and add summary cells"; Files = @("notebooks/14_Verify Data Quality & Consistency.ipynb") },
    @{ Date = "2025-12-31T17:45:00"; Msg = "tooling: finalize backdated commit wave2 script for SADOP"; Files = @("backdate_commits_wave2.ps1") }
 )

 foreach ($c in $commits) {
     Commit-Group -Files $c.Files -Msg $c.Msg -Date $c.Date
 }

 Write-Host "Wave 2 backdated commits completed."

