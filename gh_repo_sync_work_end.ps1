<#
.SYNOPSIS
  End-of-day Git sync: stage, commit (prompt if needed), and push to origin/current-branch.
    Usage
	Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
	.\gh_repo_sync_work_start.ps1
	.\gh_repo_sync_work_end.ps1 -Message "Your commit message"
  

.DESCRIPTION
  Mirrors the behavior of gh_repo_sync_work_end.sh for Windows/PowerShell.
  - Verifies repo + origin
  - Detects changes via 'git status --porcelain'
  - Stages everything
  - Prompts for a non-empty commit message if not provided
  - Commits and pushes to origin/<branch>
#>

[CmdletBinding()]
param(
  [string]$Message
)

function Fail($msg) {
  Write-Host $msg -ForegroundColor Red
  exit 1
}

Write-Host "--- Ending Sync: Pushing changes to GitHub ---" -ForegroundColor Yellow

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

# 3. Check for changes via 'git status --porcelain'
$changes = git status --porcelain
if ([string]::IsNullOrWhiteSpace(($changes -join ''))) {
  Write-Host "No changes to commit. Working tree clean." -ForegroundColor Gray
  Write-Host "--- Sync End Complete (No changes) ---" -ForegroundColor Green
  exit 0
}
Write-Host "Changes detected." -ForegroundColor Gray

# 4. Stage all changes
Write-Host "Staging all changes..."
git add -A
if ($LASTEXITCODE -ne 0) { Fail "Error: Failed to stage changes." }
Write-Host "Changes staged." -ForegroundColor Gray
git status --short

# 5. Ensure we have a non-empty commit message
if ([string]::IsNullOrWhiteSpace($Message)) {
  do {
    $Message = Read-Host "Enter commit message"
    if ([string]::IsNullOrWhiteSpace($Message)) {
      Write-Host "Commit message cannot be empty. Please try again." -ForegroundColor Yellow
    }
  } while ([string]::IsNullOrWhiteSpace($Message))
} else {
  Write-Host ('Using provided commit message: "{0}"' -f $Message) -ForegroundColor Gray
}

# 6. Commit changes
Write-Host "Committing changes..."
git commit -m "$Message"
if ($LASTEXITCODE -ne 0) {
  # Re-check if anything effective to commit
  $postCommitChanges = git status --porcelain
  if ([string]::IsNullOrWhiteSpace(($postCommitChanges -join ''))) {
    Write-Host "No effective changes were committed." -ForegroundColor Gray
    Write-Host "--- Sync End Complete (No effective changes) ---" -ForegroundColor Green
    exit 0
  } else {
    Fail "Error: Failed to commit changes."
  }
}
Write-Host "Changes committed." -ForegroundColor Gray

# 7. Get current branch name
$current_branch = (git rev-parse --abbrev-ref HEAD).Trim()
if ([string]::IsNullOrWhiteSpace($current_branch) -or $current_branch -eq 'HEAD') {
  Fail "Error: Could not determine current branch name."
}
Write-Host ("Current branch: {0}" -f $current_branch) -ForegroundColor Gray

# 8. Push changes
Write-Host ("Attempting to push changes to origin/{0}..." -f $current_branch)
git push origin $current_branch
if ($LASTEXITCODE -ne 0) {
  Fail "Error: Failed to push changes. Check connection or run the start script first if remote has new commits."
}

Write-Host ("Successfully pushed changes to origin/{0}." -f $current_branch) -ForegroundColor Green
Write-Host "--- Sync End Complete ---" -ForegroundColor Green
