# PowerShell
Some useful (at least for me) PowerShell Scripts

[DomainExpirationCheck.ps1](DomainExpirationCheck.ps1) Powershell script to check if domain registration is about to expire (in less than 30 days or less). using WhoIsXMLApi.com / Will exit errorlevel 0 if no expiration or error / Will exit errorlevel 1 if is about to expire / Will exit errorlevel 998 (warning) if there was an error querying the server or there was no expiration day in API reply (domain not fully supported)
