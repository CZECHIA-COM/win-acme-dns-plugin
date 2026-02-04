<# 
Install-CzechiaWinAcmeDns.ps1
Instalace Script Packu pro win-acme DNS-01 validaci přes Czechia REST API.
#>

param(
    [string]$InstallDir = "C:\ProgramData\win-acme\CzechiaDns",
    [string]$WacsPath = "C:\wacs\wacs.exe",
    [switch]$SetTokenForSession
)

[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "Install dir: $InstallDir"
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $InstallDir "scripts") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $InstallDir "config") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $InstallDir "examples") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $InstallDir "docs") | Out-Null

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

Copy-Item -Force -Path (Join-Path $here "scripts\*") -Destination (Join-Path $InstallDir "scripts")
Copy-Item -Force -Path (Join-Path $here "config\*") -Destination (Join-Path $InstallDir "config")
Copy-Item -Force -Path (Join-Path $here "examples\*") -Destination (Join-Path $InstallDir "examples")
if (Test-Path -LiteralPath (Join-Path $here "docs")) {
    Copy-Item -Force -Path (Join-Path $here "docs\*") -Destination (Join-Path $InstallDir "docs") -ErrorAction SilentlyContinue
}
Copy-Item -Force -Path (Join-Path $here "README.md") -Destination (Join-Path $InstallDir "README.md")
Copy-Item -Force -Path (Join-Path $here "README-INSTALL.txt") -Destination (Join-Path $InstallDir "README-INSTALL.txt")
Copy-Item -Force -Path (Join-Path $here "LICENSE") -Destination (Join-Path $InstallDir "LICENSE")

Write-Host ""
Write-Host "Hotovo. Konfigurace:"
Write-Host ("  " + (Join-Path $InstallDir "config\czechia.dns.json"))
Write-Host ""

if ($SetTokenForSession) {
    $token = Read-Host -Prompt "Zadej Czechia API klic (nastavi se do env CZECHIA_API_TOKEN pro tuto session)"
    if (-not [string]::IsNullOrWhiteSpace($token)) {
        $env:CZECHIA_API_TOKEN = $token
        Write-Host "Nastaveno: CZECHIA_API_TOKEN (pro tuto session)."
    }
}

Write-Host ""
Write-Host "Příklad příkazu (uprav si hosty/email):"
Write-Host ""

$cmd = @"
& "$WacsPath" `
  --target manual --host "example.cz" --host "*.example.cz" `
  --validationmode dns-01 --validation script `
  --dnscreatescript "$InstallDir\scripts\Create-CzechiaTxt.ps1" `
  --dnsdeletescript "$InstallDir\scripts\Delete-CzechiaTxt.ps1" `
  --dnscreatescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
  --dnsdeletescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
  --accepttos --emailaddress "admin@example.cz" --verbose
"@

Write-Host $cmd
Write-Host ""
Write-Host "Tip: trvalé nastavení tokenu:"
Write-Host '  setx CZECHIA_API_TOKEN "TVUJ_API_KLIC"'
