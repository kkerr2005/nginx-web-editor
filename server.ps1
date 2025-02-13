# Import Pode and Pode.Web modules
Import-Module Pode
Import-Module Pode.Web

# Define the Pode server
Start-PodeServer {
    Add-PodeEndpoint -Address * -Port 8080 -Protocol Http

    Use-PodeWebTemplates -Title 'Nginx Config Admin' -Theme Dark

    Add-PodeWebPage -Name 'Load Balancing' -Icon 'Settings' -ScriptBlock {
        New-PodeWebForm -Name 'Update Nginx Config' -ScriptBlock {
            New-PodeWebTextbox -Name 'Upstream Name' -Id 'upstreamName' -Placeholder 'Enter upstream name' -Required
            New-PodeWebTextbox -Name 'Server List' -Id 'serverList' -Placeholder 'Enter server list (comma-separated)' -Required
            New-PodeWebButton -Name 'Update Configuration' -Type Submit
        } -OnSubmit {
            param($WebEvent)

            try {
                # Process the form data and update the Nginx config
                $formData = $WebEvent.Data
                $upstreamName = $formData.upstreamName
                $serverList = $formData.serverList -split ','

                Write-Host "Received form data: UpstreamName=$upstreamName, ServerList=$($serverList -join ',')"

                # Path to the Nginx config file
                $nginxConfigPath = '/etc/nginx/nginx.conf'

                # Read the current Nginx config
                $nginxConfig = Get-Content -Path $nginxConfigPath -Raw
                Write-Host "Read Nginx config from $nginxConfigPath"

                # Update the upstream block in the Nginx config
                $upstreamBlock = "upstream $upstreamName {
" + ($serverList | ForEach-Object { "    server $_;" }) + "
}"
                $nginxConfig = [regex]::Replace($nginxConfig, "upstream $upstreamName {.*?}", $upstreamBlock, 'Singleline')
                Write-Host "Updated upstream block in Nginx config"

                # Write the updated config back to the file
                Set-Content -Path $nginxConfigPath -Value $nginxConfig
                Write-Host "Wrote updated Nginx config to $nginxConfigPath"

                # Reload Nginx to apply the changes
                Invoke-Expression 'nginx -s reload'
                Write-Host "Reloaded Nginx"

                # Return a success message
                Show-PodeWebToast -Message 'Configuration updated successfully' -Type Success
            } catch {
                Write-Host "Error: $_"
                Show-PodeWebToast -Message "Error: $_" -Type Error
            }
        }
    }
}
