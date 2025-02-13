@{
    ModuleVersion = '1.0.0'
    GUID = 'd1e3f4b5-6c7d-8e9a-a0b1-c2d3e4f5g6h7'
    Author = 'Your Name'
    CompanyName = 'Your Company'
    Copyright = 'Copyright © Your Company 2023'
    Description = 'A web front end for editing Nginx load balancing configuration using Pode.Web.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Start-NginxWebEditor', 'Stop-NginxWebEditor')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    RequiredModules = @()
    RequiredAssemblies = @()
    FileList = @('src/lib/NginxUtils.psm1', 'src/modules/config_module.psm1', 'src/PodeWeb.ps1')
}