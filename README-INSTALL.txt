CZECHIA.COM DNS-01 for win-acme (Script plugin) – INSTALLATION GUIDE

This package provides DNS-01 validation scripts for win-acme (wacs.exe)
using the CZECHIA.COM DNS REST API.

======================================================================

1) Extract the ZIP archive

   Recommended location:
   C:\ProgramData\win-acme\CzechiaDns\

---------------------------------------------------------------------

2) Run the installer

   Open PowerShell in the extracted directory and run:

   .\Install-CzechiaWinAcmeDns.ps1 -SetTokenForSession

   The installer will:
   - copy scripts to:
     C:\ProgramData\win-acme\CzechiaDns\scripts
   - set the API token for the current PowerShell session

---------------------------------------------------------------------

3) Set the API token permanently (recommended)

   setx CZECHIA_API_TOKEN "YOUR_API_KEY"

   Note:
   The API key is sent in the HTTP header:

   AuthorizationToken: <API_KEY>

---------------------------------------------------------------------

4) Run win-acme (example)

   IMPORTANT:
   For SAN certificates, DO NOT repeat the --host parameter.
   Use a single --host with comma-separated domains.

   PowerShell example:

   $Wacs = "C:\wacs\wacs.exe"
   $Base = "C:\ProgramData\win-acme\CzechiaDns"

   & $Wacs `
     --target manual `
     --host "example.cz,*.example.cz" `
     --validationmode dns-01 `
     --validation script `
     --dnscreatescript "$Base\scripts\Create-CzechiaTxt.ps1" `
     --dnsdeletescript "$Base\scripts\Delete-CzechiaTxt.ps1" `
     --dnscreatescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
     --dnsdeletescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
     --accepttos `
     --emailaddress "admin@example.cz" `
     --verbose

   Explanation:
   - The first domain becomes the certificate CN (Subject)
   - All domains are included as SANs

---------------------------------------------------------------------

Troubleshooting

- HTTP 401 / 403
  → Check that CZECHIA_API_TOKEN is set correctly

- DNS TXT record not visible
  → Verify DNS propagation manually:
    nslookup -type=TXT _acme-challenge.example.cz 1.1.1.1

- Certificate contains only one domain
  → Make sure you are using:
    --host "a.example.cz,b.example.cz"
  → Do NOT repeat --host

---------------------------------------------------------------------

Support

For support, bug reports, or API-related issues, contact:

admin@zoner.cz
