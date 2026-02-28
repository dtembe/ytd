<#
.SYNOPSIS
  Start-of-day Git sync: fetch + merge latest from origin/current-branch.
  
  Usage
	Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
	.\gh_repo_sync_work_start.ps1
	.\gh_repo_sync_work_end.ps1 -Message "Your commit message"
  

.DESCRIPTION
  Mirrors the behavior of gh_repo_sync_work_start.sh for Windows/PowerShell.
  - Verifies you're in a Git repo
  - Verifies 'origin' remote exists
  - Detects current branch
  - Pulls from origin/<branch>
  
#>

[CmdletBinding()]
param()

function Fail($msg) {
  Write-Host $msg -ForegroundColor Red
  exit 1
}

Write-Host "--- Starting Sync: Fetching updates from GitHub ---" -ForegroundColor Yellow

# 0. Verify git exists
$git = Get-Command git -ErrorAction SilentlyContinue
if (-not $git) { Fail "Error: 'git' not found in PATH. Install Git for Windows or add it to PATH." }

# 1. Check if inside a git repository
git rev-parse --is-inside-work-tree *>$null
if ($LASTEXITCODE -ne 0) {
  Fail "Error: Not inside a git repository. Please 'cd' into your project directory."
}
Write-Host ("Verified: Inside a git repository ({0})" -f (Get-Location)) -ForegroundColor Gray

# 2. Check if 'origin' remote exists
$hasOrigin = git remote | Select-String -Pattern '^origin$'
if (-not $hasOrigin) { Fail "Error: Remote 'origin' not found. Ensure the repository is linked to GitHub." }
Write-Host "Verified: Remote 'origin' exists." -ForegroundColor Gray

# 3. Get current branch name
$current_branch = (git rev-parse --abbrev-ref HEAD).Trim()
if ([string]::IsNullOrWhiteSpace($current_branch) -or $current_branch -eq 'HEAD') {
  Fail "Error: Could not determine current branch. Are you in a detached HEAD state?"
}
Write-Host ("Current branch: {0}" -f $current_branch) -ForegroundColor Gray

# 4. Pull changes (fetch + merge)
Write-Host ("Attempting to pull changes from origin/{0}..." -f $current_branch)
git pull origin $current_branch
if ($LASTEXITCODE -ne 0) {
  Fail "Error: Failed to pull changes. Check for conflicts or connection issues."
}

Write-Host "--- Sync Start Complete ---" -ForegroundColor Green
exit 0
