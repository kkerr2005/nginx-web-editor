# Update package lists
Write-Output "Updating package lists..."
Start-Process "powershell" -ArgumentList "sudo apt-get update" -Wait

# Install Nginx
Write-Output "Installing Nginx..."
Start-Process "powershell" -ArgumentList "sudo apt-get install -y nginx" -Wait

# Install PowerShell
Write-Output "Installing PowerShell..."
Start-Process "powershell" -ArgumentList "sudo apt-get install -y wget apt-transport-https software-properties-common" -Wait
Start-Process "powershell" -ArgumentList "wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb" -Wait
Start-Process "powershell" -ArgumentList "sudo dpkg -i packages-microsoft-prod.deb" -Wait
Start-Process "powershell" -ArgumentList "sudo apt-get update" -Wait
Start-Process "powershell" -ArgumentList "sudo apt-get install -y powershell" -Wait

# Install Pode.Web
Write-Output "Installing Pode.Web..."
Start-Process "pwsh" -ArgumentList "-Command Install-Module -Name Pode.Web -Force -Scope AllUsers" -Wait

# Install other dependencies if any
# Add commands to install other dependencies here

Write-Output "Installation complete. You can now run the Pode.Web application."