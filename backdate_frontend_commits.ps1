 $ErrorActionPreference = "Stop"

 function New-BackdatedCommit {
     param(
         [string]$Date,
         [string]$Message,
         [string[]]$Files
     )

     Write-Host "Processing: $Message ($Date)"

     $env:GIT_AUTHOR_DATE = $Date
     $env:GIT_COMMITTER_DATE = $Date

     try {
         git add -- $Files
         $gitCommit = git commit -m "$Message" 2>&1
         if ($LASTEXITCODE -ne 0) {
             Write-Warning "Git commit failed for $($Files -join ', '): $gitCommit"
         } else {
             Write-Host "Success."
         }
     } finally {
         Remove-Item Env:GIT_AUTHOR_DATE -ErrorAction SilentlyContinue
         Remove-Item Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
     }
 }

 $commits = @(
     @{ Date = "2026-01-04T09:15:00"; Message = "chore(frontend): scaffold Next.js + TypeScript app for SADOP"; Files = @(
         "frontend/package.json",
         "frontend/package-lock.json",
         "frontend/tsconfig.json",
         "frontend/next.config.ts",
         "frontend/eslint.config.mjs",
         "frontend/postcss.config.mjs",
         "frontend/.gitignore"
     ) },
     @{ Date = "2026-01-04T11:30:00"; Message = "feat(frontend): add SADOP landing layout and shared icon set"; Files = @(
         "frontend/public",
         "frontend/app",
         "frontend/components"
     ) },
     @{ Date = "2026-01-04T14:45:00"; Message = "feat(frontend): implement SADOP client hooks and types"; Files = @(
         "frontend/hooks",
         "frontend/lib",
         "frontend/types"
     ) },
     @{ Date = "2026-01-04T17:30:00"; Message = "docs(frontend): document local setup and deployment for SADOP UI"; Files = @(
         "frontend/README.md",
         "frontend/FRONTEND_UPDATE.md"
     ) }
 )

 foreach ($c in $commits) {
     New-BackdatedCommit -Date $c.Date -Message $c.Message -Files $c.Files
 }

 Write-Host "Frontend backdated commits for 2026-01-04 completed."

