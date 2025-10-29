# PowerShell
Some useful (at least for me) PowerShell Scripts

[CheckNFixDCRelation.ps1](CheckNFixDCRelation.ps1) Powershell script that will check the machine relationship with the DC and fix it if is broken. This is definitely not intended for production (unless you are ok to have a ps1 file with your AD Admin...) But is intended for testing environments where the machines are off for too long and will loose the relationship with the DC.

[DomainExpirationCheck.ps1](DomainExpirationCheck.ps1) Powershell script to check if domain registration is about to expire (in less than 30 days or less). using WhoIsXMLApi.com / Will exit errorlevel 0 if no expiration or error / Will exit errorlevel 1 if is about to expire / Will exit errorlevel 998 (warning) if there was an error querying the server or there was no expiration day in API reply (domain not fully supported)

[find_links.ps1](find_links.ps1) Powershel script created to crawl specific URL and look for specific content in links. This came out after a I change a service to another URL and wanted to find the links to it, in a simple way, not needing external apps. Intended to run on powershell 7+, replace "https://www.rooturl..com" with the website to crawl, and "search.rooturl.com" by the link you are searching for.
