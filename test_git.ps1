try {
    Write-Host "Testing git add..."
    git status
    if (Test-Path "frontend/README.md") {
        Write-Host "File exists."
        git add frontend/README.md
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Git add failed with exit code $LASTEXITCODE"
        } else {
            Write-Host "Git add success"
        }
    } else {
        Write-Error "File not found"
    }
} catch {
    Write-Error $_
}
