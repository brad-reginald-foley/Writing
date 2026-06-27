#!/usr/bin/env pwsh
<#
.SYNOPSIS
  Workspace sync for the Writing super-repo + its nested independent repos.

.DESCRIPTION
  Writing/ gitignores its nested repos (_private/, each book/), so git run inside
  Writing/ is BLIND to them. This walks EVERY repo (the super-repo + every nested
  repo) so a dirty/unpushed/unpulled subfolder can never hide.

  Repos are discovered by scanning for .git dirs (self-maintaining: new books are
  picked up automatically, and any nested repo missing from _private/repos.md is
  flagged as unregistered).

.PARAMETER Command
  status (default) - one table for all repos + warnings (dirty / unpushed / behind /
                     unregistered / privacy-leak). Read-only.
  pull             - fetch + fast-forward-only pull across all repos.
  push             - push every repo that is ahead of its upstream (explicit; the
                     script never pushes unless you run this).
  check            - alias for status (exits non-zero if any warning fires; for hooks/CI).

.EXAMPLE
  pwsh tools/sync.ps1            # status
  pwsh tools/sync.ps1 pull
  pwsh tools/sync.ps1 push
#>
param([ValidateSet('status','pull','push','check')][string]$Command = 'status')

# Native git stderr must not throw; we read exit codes ourselves.
$PSNativeCommandUseErrorActionPreference = $false

$Root  = Split-Path -Parent $PSScriptRoot
$Allow = @('.gitignore','CLAUDE.md','README.md','ideas.md','framework','tools')

function Get-Repos {
  $repos = @()
  if (Test-Path (Join-Path $Root '.git')) { $repos += $Root }
  Get-ChildItem -LiteralPath $Root -Directory -Force | Sort-Object Name | ForEach-Object {
    if (Test-Path (Join-Path $_.FullName '.git')) { $repos += $_.FullName }
  }
  ,$repos
}

function Get-RepoState($r) {
  $branch = (git -C $r rev-parse --abbrev-ref HEAD 2>$null)
  $dirty  = @(git -C $r status --porcelain 2>$null).Count
  $ahead = 0; $behind = 0; $hasUpstream = $true
  $lr = (git -C $r rev-list --left-right --count '@{upstream}...HEAD' 2>$null)
  if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($lr)) {
    $hasUpstream = $false
  } else {
    $p = $lr -split '\s+'; $behind = [int]$p[0]; $ahead = [int]$p[1]
  }
  [pscustomobject]@{
    Repo = (Split-Path $r -Leaf); Branch = $branch; Dirty = $dirty
    Ahead = $ahead; Behind = $behind; HasUpstream = $hasUpstream
    IsSuper = ($r -eq $Root); Path = $r
  }
}

function Format-Status($s) {
  $bits = @()
  if ($s.Dirty -gt 0)        { $bits += "$($s.Dirty) uncommitted" }
  if (-not $s.HasUpstream)   { $bits += 'NO UPSTREAM' }
  if ($s.Ahead  -gt 0)       { $bits += "^$($s.Ahead) to push" }
  if ($s.Behind -gt 0)       { $bits += "v$($s.Behind) to pull" }
  if ($bits.Count -eq 0)     { 'clean' } else { $bits -join ' | ' }
}

$repos = Get-Repos
if (-not $repos) { Write-Host "No git repos found under $Root" -ForegroundColor Yellow; exit 1 }
$states = $repos | ForEach-Object { Get-RepoState $_ }

# ---- warnings -------------------------------------------------------------
$warn = @()
foreach ($s in $states) {
  if ($s.Dirty -gt 0)      { $warn += "DIRTY      $($s.Repo): $($s.Dirty) uncommitted change(s)" }
  if (-not $s.HasUpstream) { $warn += "NO-UPSTREAM $($s.Repo): no tracking branch (push with -u to back it up)" }
  if ($s.Ahead -gt 0)      { $warn += "UNPUSHED   $($s.Repo): $($s.Ahead) commit(s) not on the remote (not backed up)" }
  if ($s.Behind -gt 0)     { $warn += "BEHIND     $($s.Repo): $($s.Behind) commit(s) to pull" }
}
# privacy gate (super-repo allow-list)
$tracked = git -C $Root ls-files 2>$null | ForEach-Object { ($_ -split '/')[0] } | Sort-Object -Unique
$leak = $tracked | Where-Object { $_ -and ($_ -notin $Allow) }
foreach ($f in $leak) { $warn += "PRIVACY    super-repo tracks '$f' (not in allow-list) - personal content may leak" }
# unregistered nested repos (cross-check _private/repos.md)
$manifest = Join-Path $Root '_private/repos.md'
if (Test-Path $manifest) {
  $mtext = Get-Content $manifest -Raw
  foreach ($s in $states) {
    if (-not $s.IsSuper -and $mtext -notmatch [regex]::Escape($s.Repo)) {
      $warn += "UNREGISTERED $($s.Repo): not in _private/repos.md (bootstrap will miss it on a new machine)"
    }
  }
}

# ---- render ---------------------------------------------------------------
Write-Host ""
$states | Select-Object @{n='Repo';e={$_.Repo}}, Branch,
  @{n='Status';e={Format-Status $_}} | Format-Table -AutoSize

if ($warn.Count) {
  Write-Host "Warnings:" -ForegroundColor Yellow
  $warn | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
} else {
  Write-Host "All repos clean, pushed, and registered." -ForegroundColor Green
}
Write-Host ""

switch ($Command) {
  'pull' {
    Write-Host "Pulling (fast-forward only)..." -ForegroundColor Cyan
    foreach ($s in $states) {
      if (-not $s.HasUpstream) { Write-Host "  skip $($s.Repo) (no upstream)"; continue }
      Write-Host "  $($s.Repo):" -NoNewline
      $out = git -C $s.Path pull --ff-only 2>&1
      Write-Host " $($out -join ' ')"
    }
  }
  'push' {
    $todo = $states | Where-Object { $_.HasUpstream -and $_.Ahead -gt 0 }
    if (-not $todo) { Write-Host "Nothing to push." -ForegroundColor Green }
    else {
      Write-Host "Pushing repos that are ahead..." -ForegroundColor Cyan
      foreach ($s in $todo) {
        Write-Host "  $($s.Repo) (^$($s.Ahead)):" -NoNewline
        $out = git -C $s.Path push 2>&1
        Write-Host " $($out -join ' ')"
      }
    }
    $noup = $states | Where-Object { -not $_.HasUpstream }
    foreach ($s in $noup) { Write-Host "  $($s.Repo): no upstream - run 'git -C `"$($s.Path)`" push -u origin $($s.Branch)'" -ForegroundColor Yellow }
  }
  'check' { if ($warn.Count) { exit 1 } }
}
