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
$ttl = [int]$cfg.ttl
Invoke-CzechiaDnsTxt -Method "DELETE" -ZoneName $ZoneName -HostName $NodeName -Text $Token -Ttl $ttl -ConfigPath $ConfigPath | Out-Null
Write-Host "TXT smazán: $NodeName ($ZoneName)"
