# Re-render the Quarto site and (re)start the static preview server.
# Usage: .\render.ps1
#
# What it does:
#   1. Stops anything currently listening on port 4000 (the static server
#      holds _site/ open, which blocks `quarto render` on Windows).
#   2. Runs `quarto render`.
#   3. Starts a fresh static server on http://127.0.0.1:4000/ in the background.

$ErrorActionPreference = 'Stop'
$port = 4000

# Step 1: stop any process listening on $port
try {
    $conn = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction Stop
    foreach ($c in $conn) {
        try {
            Stop-Process -Id $c.OwningProcess -Force -ErrorAction Stop
            Write-Host "Stopped server on port $port (PID $($c.OwningProcess))."
        } catch {
            Write-Host "Could not stop PID $($c.OwningProcess): $($_.Exception.Message)"
        }
    }
    Start-Sleep -Milliseconds 500
} catch {
    # Nothing listening — fine.
}

# Step 2: render
quarto render
if ($LASTEXITCODE -ne 0) {
    Write-Host "Quarto render failed with exit code $LASTEXITCODE."
    exit $LASTEXITCODE
}

# Step 3: start static server in background
$sitePath = Join-Path $PSScriptRoot '_site'
Start-Process -WindowStyle Hidden -FilePath 'py' `
    -ArgumentList '-m','http.server',"$port",'--bind','127.0.0.1' `
    -WorkingDirectory $sitePath
Start-Sleep -Milliseconds 500

Write-Host ""
Write-Host "Site rendered. Serving at http://127.0.0.1:$port/"
