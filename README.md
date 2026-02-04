# win-acme DNS plugin – Czechia

DNS-01 validační skripty pro **win-acme (wacs.exe)** využívající **Czechia DNS API**.  
Plugin umožňuje automatické vystavování certifikátů (včetně SAN a wildcard) pomocí TXT záznamů.

---

## Požadavky

- Windows
- win-acme (wacs.exe)
- Doména spravovaná u **Czechia**
- API token od Czechia

---

## Instalace

1. Stáhni obsah repozitáře
2. Rozbal jej
3. Spusť instalační skript:

```powershell
.\Install-CzechiaWinAcmeDns.ps1 -SetTokenForSession
```

Instalátor:
- zkopíruje skripty do  
  `C:\ProgramData\win-acme\CzechiaDns\scripts`
- nastaví API token pro aktuální PowerShell session

---

## Použití (DNS-01)

### Jedna doména

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

## Více domén (SAN certifikát) – ⚠️ DŮLEŽITÉ

### Správný způsob zadání SAN domén

U **win-acme** (při použití `--target manual`) **NEOPAKUJTE parametr `--host`**.

❌ Nesprávně / nespolehlivé:
```powershell
--host "a.example.cz" --host "b.example.cz"
```

win-acme v tomto případě často vezme **jen první doménu** a certifikát nebude mít SAN.

---

### ✅ Správně (jediný parametr `--host`, domény oddělené čárkami)

```powershell
--host "a.example.cz,b.example.cz"
```

### Příklad
```powershell
--host "le5.example.cz,le6.example.cz"
```

- **první doména** → CN (Subject)
- **všechny domény** → SAN (Subject Alternative Name)

Volitelně lze CN nastavit explicitně:

```powershell
--commonname "le5.example.cz"
```

---

## Wildcard certifikát

```powershell
--host "example.cz,*.example.cz"
```

---

## Debug / ověření

Zapnutí verbose výstupu:

```powershell
$env:CZECHIA_API_VERBOSE="true"
```

Ve výpisu win-acme:
- musí být vidět **více identifikátorů**, pokud žádáš o SAN
- DNS request vždy obsahuje:
```json
"publishZone": 1
```

---

## Technické poznámky

- `publishZone` je **natvrdo nastaveno na `1`**
- neexistuje žádná konfigurace publishZone (ENV ani JSON)
- všechny DNS změny se vždy publikují na autoritativní nameservery

---

## Troubleshooting

### Certifikát obsahuje jen jednu doménu
- zkontroluj, že používáš:
```powershell
--host "a.example.cz,b.example.cz"
```
- **neopakuj `--host`**

### DNS změny se nepropisují
- doména musí být spravována u Czechia
- API token musí mít oprávnění k dané zóně

---

## Licence

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
