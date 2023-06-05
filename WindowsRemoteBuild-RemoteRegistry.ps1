$remoteComputers = @(
    "Computer1",
    "192.168.1.10"
)
$outputFile = "C:\AllComputers-NoWRM.txt"

foreach ($remoteComputer in $remoteComputers) {
    $outputObject = $null

    # Try to establish a remote registry connection
    try {
        $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $remoteComputer)
        $regKey = $reg.OpenSubKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion")

        if ($regKey) {
            $currentBuild = $regKey.GetValue("CurrentBuild")
            $ubr = $regKey.GetValue("UBR")

            if ($currentBuild -and $ubr) {
                $osVersion = "$currentBuild.$ubr"

                # Create a custom object with computer name and OSVersion
                $outputObject = [PSCustomObject]@{
                    ComputerName = $remoteComputer
                    OSVersion = $osVersion
                }
            }
        }

        $regKey.Close()
        $reg.Close()
    } catch {
        Write-Host "Failed to establish a remote registry connection to $remoteComputer."
    }

    if ($outputObject) {
        # Append the output to the text file
        if (-not (Test-Path -Path $outputFile)) {
            $outputObject | Select-Object ComputerName, OSVersion | ConvertTo-Csv -NoTypeInformation | ForEach-Object { $_ -replace '"' } | Out-File -FilePath $outputFile -Encoding UTF8
        } else {
            $outputObject | Select-Object ComputerName, OSVersion | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | ForEach-Object { $_ -replace '"' } | Out-File -FilePath $outputFile -Append -Encoding UTF8
        }
    }
}
