# Návrh issue do win-acme (community script)

Titulek:
Community DNS Script provider – Czechia.com (AuthorizationToken header)

Text:
Ahoj, máme komunitní balíček pro win-acme DNS Script validation plugin, který umožňuje DNS-01 validaci pro zákazníky s DNS u Czechia.com.
Používá Czechia REST API pro správu TXT záznamů (/api/DNS/{domainName}/TXT) a autentizaci přes hlavičku AuthorizationToken.

Repo / releases:
- <SEM DOPLŇTE ODKAZ NA GITHUB REPO/RELEASE>

Použití:
--validationmode dns-01 --validation script
--dnscreatescript ...Create-CzechiaTxt.ps1
--dnsdeletescript ...Delete-CzechiaTxt.ps1
--dnscreatescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}"
--dnsdeletescriptarguments "{Identifier} {NodeName} {Token} {ZoneName}"

Rád bych poprosil o přidání odkazu do dokumentace win-acme do sekce DNS Script (community examples), aby uživatelé Czechia našli návod snadno.

Díky!
