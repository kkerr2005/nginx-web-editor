# Import Pode and Pode.Web modules
Import-Module Pode
Import-Module Pode.Web

# Define the Pode server
Start-PodeServer -Port 8080 -ScriptBlock {
    # Add a route for the admin page
    Add-PodeRoute -Method Get -Path '/' -ScriptBlock {
        Get-PodeWebFile -Path 'index.html'
    }

    # Add a route to handle form submissions
    Add-PodeRoute -Method Post -Path '/update-config' -ScriptBlock {
        param($WebEvent)

        # Process the form data and update the Nginx config
        $formData = $WebEvent.Data
        $upstreamName = $formData.upstreamName
        $serverList = $formData.serverList -split ','

        # Path to the Nginx config file
        $nginxConfigPath = '/etc/nginx/nginx.conf'

        # Read the current Nginx config
        $nginxConfig = Get-Content -Path $nginxConfigPath -Raw

        # Update the upstream block in the Nginx config
        $upstreamBlock = "upstream $upstreamName {
" + ($serverList | ForEach-Object { "    server $_;" }) + "
}"
        $nginxConfig = [regex]::Replace($nginxConfig, "upstream $upstreamName {.*?}", $upstreamBlock, 'Singleline')

        # Write the updated config back to the file
        Set-Content -Path $nginxConfigPath -Value $nginxConfig

        # Reload Nginx to apply the changes
        Invoke-Expression 'nginx -s reload'

        # Return a success message
        Write-PodeJsonResponse -Value @{ message = 'Configuration updated successfully' }
    }
}
