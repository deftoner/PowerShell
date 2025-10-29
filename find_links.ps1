# Script created to crawl specific URL and look for specific content in links. This came out after a I change a service to another URL and wanted to find the links to it, in a simple way, not needing external apps. 
# Intended to run on powershell 7+, replace "https://www.rooturl..com" with the website to crawl, and "search.rooturl.com" by the link you are searching for.

$baseUrl = "https://www.rooturl..com"
$targetDomain = "search.rooturl.com"
$maxPages = 100

$visited = @{}
$toVisit = @($baseUrl)
$foundLinks = @()

Write-Host "Crawling $baseUrl for links to $targetDomain...`n" -ForegroundColor Cyan

while ($toVisit.Count -gt 0 -and $visited.Count -lt $maxPages) {
    $currentUrl = $toVisit[0]
    $toVisit = $toVisit[1..($toVisit.Length-1)]
    
    if ($visited.ContainsKey($currentUrl)) { continue }
    
    try {
        Write-Host "Checking: $currentUrl"
        $response = Invoke-WebRequest -Uri $currentUrl -TimeoutSec 10
        $visited[$currentUrl] = $true
        
        # Find all links
        $links = $response.Links | Where-Object { $_.href }
        
        foreach ($link in $links) {
            $href = $link.href
            
            # Convert relative URLs to absolute
            if ($href -notmatch '^https?://') {
                $href = [System.Uri]::new([System.Uri]$currentUrl, $href).ToString()
            }
            
            # Check if link points to target domain
            if ($href -match $targetDomain) {
                $foundLinks += [PSCustomObject]@{
                    FoundOn = $currentUrl
                    LinkTo = $href
                    LinkText = $link.innerText
                }
                Write-Host "  ✓ FOUND: $href" -ForegroundColor Green
            }
            
            # Add internal links to queue
            if ($href -match [regex]::Escape($baseUrl) -and -not $visited.ContainsKey($href)) {
                $toVisit += $href
            }
        }
        
        Start-Sleep -Milliseconds 500
    }
    catch {
        Write-Host "  Error: $_" -ForegroundColor Red
    }
}

# Display results
Write-Host "`n$('='*60)" -ForegroundColor Cyan
Write-Host "FOUND $($foundLinks.Count) LINKS TO $targetDomain" -ForegroundColor Cyan
Write-Host "$('='*60)`n" -ForegroundColor Cyan

$foundLinks | ForEach-Object {
    Write-Host "Found on: $($_.FoundOn)"
    Write-Host "Links to: $($_.LinkTo)"
    Write-Host "Text: $($_.LinkText)"
    Write-Host "-" * 60
}

# Save to file
$foundLinks | Export-Csv -Path "found_links.csv" -NoTypeInformation
Write-Host "`n✓ Results saved to found_links.csv" -ForegroundColor Green
