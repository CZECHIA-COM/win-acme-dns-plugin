Czechia.com DNS-01 pro win-acme (Script plugin) – instrukce

1) Rozbal ZIP
   Doporučené umístění:
   C:\ProgramData\win-acme\CzechiaDns\

2) Spusť instalaci
   PowerShell:
   .\Install-CzechiaWinAcmeDns.ps1 -SetTokenForSession

3) Nastav API klíč natrvalo (doporučeno)
   setx CZECHIA_API_TOKEN "TVUJ_API_KLIC"

   Pozn.: Klíč se posílá v hlavičce:
   AuthorizationToken: <API_KLIC>

4) Spusť win-acme (příklad)
   $Wacs = "C:\wacs\wacs.exe"
   $Base = "C:\ProgramData\win-acme\CzechiaDns"

   & $Wacs `
     --target manual --host "example.cz" --host "*.example.cz" `
     --validationmode dns-01 --validation script `
     --dnscreatescript "$Base\scripts\Create-CzechiaTxt.ps1" `
     --dnsdeletescript "$Base\scripts\Delete-CzechiaTxt.ps1" `
     --dnscreatescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
     --dnsdeletescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
     --accepttos --emailaddress "admin@example.cz" --verbose

Troubleshooting:
- 401/403: zkontroluj CZECHIA_API_TOKEN
- DNS TXT neviditelné: nslookup -type=TXT _acme-challenge.example.cz 1.1.1.1
