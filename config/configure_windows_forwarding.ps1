# Run this script as Administrator in Windows PowerShell
param(
    [Parameter(Mandatory=$true)]
    [string]$WSLIp,
    
    [Parameter(Mandatory=$false)]
    [int]$Port = 7777
)

Write-Host "Configuring Windows port forwarding for Terraria Server..."
Write-Host "WSL IP: $WSLIp"
Write-Host "Port: $Port"

try {
    # Remove existing rules
    Remove-NetFirewallRule -DisplayName "Terraria Server WSL" -ErrorAction SilentlyContinue
    netsh interface portproxy delete v4tov4 listenport=$Port listenaddress=0.0.0.0 2>&1 | Out-Null
    
    # Add new port forwarding rule
    $result = netsh interface portproxy add v4tov4 listenport=$Port listenaddress=0.0.0.0 connectport=$Port connectaddress=$WSLIp
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to add port proxy rule: $result"
    }
    
    # Add firewall rule
    New-NetFirewallRule -DisplayName "Terraria Server WSL" `
                       -Direction Inbound `
                       -Action Allow `
                       -Protocol TCP `
                       -LocalPort $Port `
                       -Program Any `
                       -Profile Any `
                       -Description "Allow incoming connections for Terraria Server in WSL"

    Write-Host "`nPort forwarding configured successfully!"
    Write-Host "Current port proxy configuration:"
    netsh interface portproxy show v4tov4
    
    Write-Host "`nFirewall rule added:"
    Get-NetFirewallRule -DisplayName "Terraria Server WSL" | Format-List DisplayName, Enabled, Direction, Action
    
} catch {
    Write-Host "Error configuring port forwarding:"
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}