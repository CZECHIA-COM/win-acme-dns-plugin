param(
  [Parameter(Mandatory=$true)][string]$Identifier,
  [Parameter(Mandatory=$true)][string]$NodeName,
  [Parameter(Mandatory=$true)][string]$Token,
  [Parameter(Mandatory=$true)][string]$ZoneName,
  [string]$ConfigPath = "C:\ProgramData\win-acme\CzechiaDns\config\czechia.dns.json"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Import-Module -Force (Join-Path $PSScriptRoot "CzechiaDnsApi.psm1")

$cfg = Get-CzechiaConfig -ConfigPath $ConfigPath

# Czechia API expects hostName = NodeName (e.g. _acme-challenge or _acme-challenge.sub)
$ttl = [int]$cfg.ttl
try {
    Invoke-CzechiaDnsTxt -Method "POST" -ZoneName $ZoneName -HostName $NodeName -Text $Token -Ttl $ttl -ConfigPath $ConfigPath | Out-Null
    Write-Host "TXT vytvořen: $NodeName ($ZoneName)"
} catch {
    # Pokud POST selže kvůli tomu, že záznam už existuje (např. opakovaný běh),
    # win-acme často stejně projde, pokud TXT obsahuje požadovaný Token.
    # Bohužel bez GET endpointu neumíme bezpečně ověřit obsah – proto chybu re-throw.
    throw
}
