# Get the location where this script is saved
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Move to the website folder (assuming it is one level up and then in /website)
cd "$ScriptDir\..\website"

Write-Host "Starting Docusaurus on GEEK (Port 3000)..." -ForegroundColor Cyan

# Start the server with network access enabled
npm start -- --host 0.0.0.0 --port 3000