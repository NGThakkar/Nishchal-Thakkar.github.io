# inject-memory.ps1
# SessionStart hook — reads memory.md and copilot-instructions.md and
# injects their content as a systemMessage so every agent session starts
# with full project context already loaded.

$root = Split-Path -Parent $PSScriptRoot   # .copilot root

$memPath   = Join-Path $root "memory.md"
$instrPath = Join-Path $root ".github\instructions\copilot-instructions.md"
$pendingFlag = Join-Path $root ".memory-pending"

$sections = @()

# Load copilot-instructions.md
if (Test-Path $instrPath) {
    $instrContent = Get-Content $instrPath -Raw -Encoding UTF8
    $sections += "### Copilot Instructions`n$instrContent"
}

# Load memory.md
if (Test-Path $memPath) {
    $memContent = Get-Content $memPath -Raw -Encoding UTF8
    $sections += "### Project Memory`n$memContent"
}

if ($sections.Count -eq 0) { exit 0 }

$msg = "## Auto-injected Project Context`n" +
       "> Loaded from .copilot at SessionStart. Follow all rules below throughout this session.`n`n" +
       ($sections -join "`n`n")

# If a previous session flagged pending memory updates, include reminder
if (Test-Path $pendingFlag) {
    $msg += "`n`n---`n> **Reminder:** The previous session ended without confirming a memory update. " +
            "If any new patterns, rules, or gotchas were discussed, run the **auto-memory** skill now to capture them."
    Remove-Item $pendingFlag -Force
}

@{ systemMessage = $msg } | ConvertTo-Json -Compress
exit 0
