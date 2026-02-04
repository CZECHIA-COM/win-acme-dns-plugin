# win-acme DNS plugin – CZECHIA.COM

DNS-01 validation scripts for **win-acme (wacs.exe)** using the **CZECHIA.COM DNS REST API**.  
This plugin allows automated certificate issuance (including SAN and wildcard certificates) via DNS TXT records.

---

## Requirements

- Windows
- win-acme (wacs.exe)
- Domain managed at **CZECHIA.COM**
- API token issued by CZECHIA.COM

---

## Installation

1. Download the repository contents
2. Extract the archive
3. Run the installer script:

```powershell
.\Install-CzechiaWinAcmeDns.ps1 -SetTokenForSession
```

The installer will:
- copy scripts to  
  `C:\ProgramData\win-acme\CzechiaDns\scripts`
- set the API token for the current PowerShell session

---

## Usage (DNS-01)

### Single domain

```powershell
& "C:\wacs\wacs.exe" `
  --target manual `
  --host "example.cz" `
  --validationmode dns-01 `
  --validation script `
  --dnscreatescript "C:\ProgramData\win-acme\CzechiaDns\scripts\Create-CzechiaTxt.ps1" `
  --dnsdeletescript "C:\ProgramData\win-acme\CzechiaDns\scripts\Delete-CzechiaTxt.ps1" `
  --dnscreatescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
  --dnsdeletescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
  --accepttos --emailaddress "admin@example.cz"
```

---

## Multiple domains (SAN certificates) – ⚠️ IMPORTANT

### Correct way to specify SAN domains

When using **win-acme** with `--target manual`, **DO NOT repeat the `--host` parameter**.

❌ Incorrect / unreliable:
```powershell
--host "a.example.cz" --host "b.example.cz"
```

In this case, win-acme often issues a certificate containing **only the first domain**.

---

### ✅ Correct (single `--host` parameter, comma-separated domains)

```powershell
--host "a.example.cz,b.example.cz"
```

### Example
```powershell
--host "le5.example.cz,le6.example.cz"
```

- **first domain** → CN (Subject)
- **all domains** → SAN (Subject Alternative Name)

Optionally, you can explicitly define the CN:

```powershell
--commonname "le5.example.cz"
```

---

## Wildcard certificates

```powershell
--host "example.cz,*.example.cz"
```

---

## Debugging / verification

Enable verbose output:

```powershell
$env:CZECHIA_API_VERBOSE="true"
```

In the win-acme output:
- multiple identifiers must be visible for SAN requests
- the DNS API request always contains:
```json
"publishZone": 1
```

---

## Technical notes

- `publishZone` is **hardcoded to `1`**
- there is no publishZone configuration (no ENV variables, no JSON settings)
- all DNS changes are always published to authoritative nameservers

---

## Troubleshooting

### Certificate contains only one domain
- verify that you are using:
```powershell
--host "a.example.cz,b.example.cz"
```
- **do not repeat `--host`**

### DNS changes are not published
- the domain must be managed at **CZECHIA.COM**
- the API token must have permissions for the target zone

---

## Support

For questions, bug reports, or API-related issues, please contact:

**admin@zoner.cz**

---

## License

MIT License

Copyright (c) 2026 ZONER a.s.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
