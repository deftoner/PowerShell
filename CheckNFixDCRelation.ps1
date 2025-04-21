# Run this as administrator on the machine (duh)
# Set these to domain account with permissions to reset machine accounts
$DomainUser = "TESTYTEST\DomainAdmin"
$DomainPassword = "P@ssw0rd!" | ConvertTo-SecureString -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential($DomainUser, $DomainPassword)

# Check secure channel
if (-not (Test-ComputerSecureChannel)) {
    Write-Warning "Machine trust with domain is broken. Attempting repair..."

    try {
        # Attempt to repair trust
        if (Test-ComputerSecureChannel -Repair -Credential $Cred) {
            Write-Host "Trust relationship repaired successfully."
        } else {
            Write-Error "Trust repair failed."
        }
    } catch {
        Write-Error "Error during repair: $_"
    }
} else {
    Write-Host "Machine trust with domain is healthy."
}
