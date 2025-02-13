function Start-PodeWeb {
    $p
    $webRoot = Join-Path -Path $PSScriptRoot -ChildPath 'public'

    Start-PodeServer -ScriptBlock {
        # Define routes
        Add-PodeRoute -Method GET -Path '/' -ScriptBlock {
            Send-PodeFile -Path 'index.html' -Root $webRoot
        }

        Add-PodeRoute -Method GET -Path '/css/styles.css' -ScriptBlock {
            Send-PodeFile -Path 'css/styles.css' -Root $webRoot
        }

        Add-PodeRoute -Method GET -Path '/js/script.js' -ScriptBlock {
            Send-PodeFile -Path 'js/script.js' -Root $webRoot
        }

        Add-PodeRoute -Method POST -Path '/api/config' -ScriptBlock {
            $body = Get-PodeBody
            # Call function to handle configuration update
            $result = Update-NginxConfig -ConfigData $body
            if ($result) {
                Send-PodeResponse -Status 200 -Body 'Configuration updated successfully'
            }
            else {
                Send-PodeResponse -Status 500 -Body 'Failed to update configuration'
            }
        }
    }

    Write-Host "Pode Web server started on port $port"
}

Start-PodeWeb