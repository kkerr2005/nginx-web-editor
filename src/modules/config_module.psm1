function Get-NginxConfig {
    param(
        [string]$ConfigPath = '/etc/nginx/nginx.conf',
        [switch]$Simple
    )
    try {
        Write-Host "Attempting to read Nginx config from: $ConfigPath"
        $configLines = Get-Content $ConfigPath -Raw
        
        if ($Simple) {
            $summary = "`n═══════════════════════════════════════`n"
            $summary += "      Nginx Active Configuration      `n"
            $summary += "═══════════════════════════════════════`n`n"
            
            $currentSection = $null
            
            foreach ($line in $configLines -split "`n") {
                $line = $line.Trim()
                
                if ($line -match '^(http|server|location)\s*{') {
                    $currentSection = $matches[1]
                    $summary += "`n► SECTION: $currentSection`n"
                }
                elseif ($line -match '^\s*listen\s+(\d+);' -and $currentSection -eq "server") {
                    $summary += "   Port: $($matches[1])`n"
                }
                elseif ($line -match '^\s*server_name\s+(.+);' -and $currentSection -eq "server") {
                    $summary += "   Server Name: $($matches[1])`n"
                }
                elseif ($line -match '^\s*proxy_pass\s+(.+);' -and $currentSection -eq "location") {
                    $summary += "   Proxy Pass: $($matches[1])`n"
                }
            }
            
            $summary += "`n═══════════════════════════════════════`n"
            return $summary
        }
        else {
            return $configLines
        }
    }
    catch {
        Write-Host "Exception reading config: $($_.Exception.Message)"
        return "Error reading configuration"
    }
}

function Set-NginxConfig {
    param(
        [string]$ServerName,
        [int]$Port = 80,
        [string[]]$Locations,
        [string]$ConfigPath = '/etc/nginx/nginx.conf'
    )
    
    Write-Host "============================================"
    Write-Host "Applying Nginx Configuration Changes:"
    Write-Host "============================================"
    Write-Host "Server Name     : $ServerName"
    Write-Host "Port            : $Port"
    Write-Host "Locations       : "
    foreach ($location in $Locations) {
        Write-Host "  • $location"
    }
    Write-Host "Config Path     : $ConfigPath"
    Write-Host "============================================"
    
    # Build configuration sections
    $serverSection = @(
        "server {",
        "    listen $Port;",
        "    server_name $ServerName;"
    )

    foreach ($location in $Locations) {
        $serverSection += "    location $location {"
        $serverSection += "        proxy_pass http://backend;"
        $serverSection += "    }"
    }
    
    $serverSection += "}"
    
    # Join all sections with newlines
    $config = $serverSection -join "`n"
    
    Write-Host "Generated config:"
    Write-Host "----------------------------------------"
    Write-Host $config
    Write-Host "----------------------------------------"
    
    # Write to a temporary file first
    $tempFile = "/tmp/nginx.conf.tmp"
    Write-Host "Writing config to temp file: $tempFile"
    try {
        [System.IO.File]::WriteAllText($tempFile, $config)
        if (Test-Path $tempFile) {
            Write-Host "Successfully wrote temp file."
        } else {
            Write-Host "Error: Temp file was not created!"
            return $false
        }
    }
    catch {
        Write-Host "Failed to write temp file: $($_.Exception.Message)"
        return $false
    }
    
    # Use sudo to move the file to its final location with proper permissions
    try {
        Write-Host "Moving temp file to: $ConfigPath"
        & sudo mv $tempFile $ConfigPath
        Write-Host "Successfully updated Nginx config"
        return $true
    }
    catch {
        Write-Host "Failed during file operations: $($_.Exception.Message)"
        return $false
    }
}

function Test-NginxConfig {
    param(
        [string]$ConfigPath = '/etc/nginx/nginx.conf'
    )
    
    try {
        Write-Host "Testing Nginx config at: $ConfigPath"
        if (-not (Test-Path $ConfigPath)) {
            Write-Host "Config file not found at: $ConfigPath"
            return $false
        }

        Write-Host "Running Nginx config test..."
        $output = & sudo nginx -t -c $ConfigPath 2>&1
        $exitCode = $LASTEXITCODE
        
        Write-Host "Test result exit code: $exitCode"
        Write-Host "Full test output:"
        Write-Host $output
        
        if ($exitCode -eq 0) {
            Write-Host "Configuration test passed successfully"
            return $true
        } else {
            Write-Host "Configuration test failed"
            return $false
        }
    }
    catch {
        Write-Host "Exception testing config: $($_.Exception.Message)"
        return $false
    }
}

Export-ModuleMember -Function Get-NginxConfig, Set-NginxConfig, Test-NginxConfig