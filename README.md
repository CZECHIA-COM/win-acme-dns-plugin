# Czechia.com DNS-01 pro win-acme (Script plugin)

Balíček pro uživatele **win-acme (wacs.exe)**, kteří mají DNS u **Czechia.com** a chtějí automatizovat vydávání/obnovu certifikátů přes **DNS-01** (včetně wildcard `*.domain`).

➡️ Používá vestavěný **DNS Script validation plugin** ve win-acme, takže není potřeba žádné DLL ani kompilace.

---

## Quick start

### 1) Stažení a instalace
1. Stáhni ZIP release a rozbal ho.
2. Spusť instalátor (PowerShell jako Admin doporučeno):

```powershell
.\Install-CzechiaWinAcmeDns.ps1 -SetTokenForSession
```

Výchozí instalace: `C:\ProgramData\win-acme\CzechiaDns`

### 2) Trvalé nastavení API klíče (doporučené)

```powershell
setx CZECHIA_API_TOKEN "TVUJ_API_KLIC"
```

> API klíč se posílá v hlavičce `AuthorizationToken`.

### 3) Spuštění win-acme (unattended příklad)

```powershell
$Wacs = "C:\wacs\wacs.exe"
$Base = "C:\ProgramData\win-acme\CzechiaDns"

& $Wacs `
  --target manual --host "example.cz" --host "*.example.cz" `
  --validationmode dns-01 --validation script `
  --dnscreatescript "$Base\scripts\Create-CzechiaTxt.ps1" `
  --dnsdeletescript "$Base\scripts\Delete-CzechiaTxt.ps1" `
  --dnscreatescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
  --dnsdeletescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}" `
  --accepttos --emailaddress "admin@example.cz" `
  --verbose
```

---

## Co to dělá
win-acme při DNS-01:
1. zavolá Create skript → vytvoří TXT `_acme-challenge` pro danou zónu
2. po ověření zavolá Delete skript → TXT smaže

Skripty volají Czechia REST API endpoint: `/api/DNS/{domainName}/TXT` a posílají JSON dle Swaggeru:
- POST: `{ hostName, text, ttl, publishZone }`
- DELETE: `{ hostName, text, ttl, publishZone }`

---

## Konfigurace
Preferovaně přes env proměnné:
- `CZECHIA_API_TOKEN` (povinné)
- `CZECHIA_API_BASEURL` (default `https://api.czechia.com`)
- `CZECHIA_API_TTL` (default `300`)
- `CZECHIA_API_PUBLISHZONE` (default `0`)
- `CZECHIA_API_TIMEOUT` (default `30`)
- `CZECHIA_API_VERBOSE` (`true/false` – vypíše HTTP body)

Alternativně lze použít `config\czechia.dns.json`.

---

## Troubleshooting
- **401/403**: špatný API klíč nebo hlavička (musí být `AuthorizationToken`)
- **TXT se “nevidí”**: ověř veřejně:
  ```powershell
  nslookup -type=TXT _acme-challenge.example.cz 1.1.1.1
  ```

---

## Licence
MIT (viz `LICENSE`).
