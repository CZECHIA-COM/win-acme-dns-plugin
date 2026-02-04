Set-StrictMode -Version Latest
# CzechiaDnsApi.psm1 – v4 FINAL (publishZone hardcoded to 1)

function Get-CzechiaConfig {
    param([string]$ConfigPath)

    if (-not [string]::IsNullOrWhiteSpace($env:CZECHIA_API_TOKEN)) {
        $cfg = [ordered]@{
            baseUrl        = $env:CZECHIA_API_BASEURL
            token          = $env:CZECHIA_API_TOKEN
            ttl            = $env:CZECHIA_API_TTL
            timeoutSeconds = $env:CZECHIA_API_TIMEOUT
            verboseHttp    = $env:CZECHIA_API_VERBOSE
        }
    } elseif ($ConfigPath -and (Test-Path $ConfigPath)) {
        $cfg = Get-Content $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json
    } else {
        throw "Nenalezena konfigurace. Nastavte CZECHIA_API_TOKEN."
    }

    if (-not $cfg.baseUrl) { $cfg.baseUrl = "https://api.czechia.com" }
    if (-not $cfg.token) { throw "Chybí API token." }

    if (-not [int]::TryParse($cfg.ttl, [ref]$null) -or $cfg.ttl -le 0) { $cfg.ttl = 300 }
    if (-not [int]::TryParse($cfg.timeoutSeconds, [ref]$null) -or $cfg.timeoutSeconds -le 0) { $cfg.timeoutSeconds = 30 }

    if ($cfg.verboseHttp -is [string]) {
        $cfg.verboseHttp = $cfg.verboseHttp -in @("1","true","TRUE","yes","YES")
    }

    return $cfg
}

function Invoke-CzechiaDnsTxt {
    param(
        [Parameter(Mandatory)][ValidateSet("POST","PUT","DELETE")]$Method,
        [Parameter(Mandatory)]$ZoneName,
        [Parameter(Mandatory)]$HostName,
        [Parameter(Mandatory)]$Text,
        [int]$Ttl = 0,
        [string]$ConfigPath = $null,
        [string]$NewText = $null,
        [int]$NewTTL = 0
    )

    $cfg = Get-CzechiaConfig -ConfigPath $ConfigPath
    if (-not $Ttl -or $Ttl -le 0) { $Ttl = $cfg.ttl }

    $publishZone = 1

    $uri = "$($cfg.baseUrl.TrimEnd('/'))/api/DNS/$($ZoneName.TrimEnd('.'))/TXT"
    $headers = @{ AuthorizationToken = $cfg.token; "Content-Type"="application/json" }

    switch ($Method) {
        "POST"   { $body=@{hostName=$HostName;text=$Text;ttl=$Ttl;publishZone=$publishZone} }
        "DELETE" { $body=@{hostName=$HostName;text=$Text;ttl=$Ttl;publishZone=$publishZone} }
        "PUT" {
            if (-not $NewText) { throw "PUT vyžaduje NewText" }
            if (-not $NewTTL -or $NewTTL -le 0) { $NewTTL=$Ttl }
            $body=@{hostName=$HostName;text=$Text;newText=$NewText;newTTL=$NewTTL;publishZone=$publishZone}
        }
    }

    $json = $body | ConvertTo-Json -Depth 5
    if ($cfg.verboseHttp) {
        Write-Host "[CZECHIA v4] publishZone=1"
        Write-Host $json
    }

    Invoke-RestMethod -Method $Method -Uri $uri -Headers $headers -Body $json -TimeoutSec $cfg.timeoutSeconds
}

Export-ModuleMember -Function Get-CzechiaConfig, Invoke-CzechiaDnsTxt
