$remoteComputers = @(
    "Computer01",
    "Computer02"
)

$outputFile = "C:\AllComputers.txt"

foreach ($remoteComputer in $remoteComputers) {
    # Establish a remote PowerShell session
    $session = New-PSSession -ComputerName $remoteComputer

    # Invoke-Command runs a script block on the remote computer
    $remoteScriptBlock = {
        # Get the CurrentBuild value from the registry
        $currentBuild = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentBuild).CurrentBuild

        # Get the UBR value from the registry
        $ubr = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name UBR).UBR

        # Calculate the OSVersion
        $osVersion = $currentBuild + "." + $ubr

        # Return the OSVersion back to the calling machine
        $osVersion
    }

    # Run the script block on the remote computer and capture the output
    $remoteOutput = Invoke-Command -Session $session -ScriptBlock $remoteScriptBlock

    # Close the remote session
    Remove-PSSession $session

    # Create a custom object with computer name and OSVersion
    $outputObject = [PSCustomObject]@{
        ComputerName = $remoteComputer
        OSVersion = $remoteOutput
    }

    # Append the output to the text file
    if (-not (Test-Path -Path $outputFile)) {
        $outputObject | Select-Object ComputerName, OSVersion | ConvertTo-Csv -NoTypeInformation | ForEach-Object { $_ -replace '"' } | Out-File -FilePath $outputFile -Encoding UTF8
    }
    else {
        $outputObject | Select-Object ComputerName, OSVersion | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | ForEach-Object { $_ -replace '"' } | Out-File -FilePath $outputFile -Append -Encoding UTF8
    }
}
