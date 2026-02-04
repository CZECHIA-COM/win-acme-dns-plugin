# Příklad unattended spuštění win-acme s DNS Script pluginem (Czechia)

$Wacs = "C:\wacs\wacs.exe"
$Base = "C:\ProgramData\win-acme\CzechiaDns"

# Doporučené: API klíč v env proměnné (hlavička AuthorizationToken)
$env:CZECHIA_API_TOKEN = "PASTE_API_KEY_HERE"

& $Wacs `
  --target manual --host "example.cz" --host "*.example.cz" `
  --validationmode dns-01 --validation script `
  --dnscreatescript "$Base\scripts\Create-CzechiaTxt.ps1" `
  --dnsdeletescript "$Base\scripts\Delete-CzechiaTxt.ps1" `
  --dnscreatescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
  --dnsdeletescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
  --accepttos --emailaddress "admin@example.cz" `
  --verbose
