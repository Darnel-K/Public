<#
 * ############################################################################
 * Filename: \PowerShell Scripts\Get-AzureAdHierarchy.ps1
 * Repository: Public
 * Created Date: Monday, December 5th 2022, 4:20:07 PM
 * Last Modified: Monday, December 5th 2022, 4:23:40 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>
function Get-ModuleInstallStatus {
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )
    $Module = Get-Module -Name $Name -ListAvailable -ErrorAction SilentlyContinue
    if ($Module.count -eq 0) {
        return $false
    }
    else {
        return $true
    }
}


if (Get-ModuleInstallStatus -Name PSWriteHTML) {
    try {

    }
    catch {

    }
}
else {
    Install-Module PSWriteHTML -Force
    try {

    }
    catch {

    }
}

if (Get-ModuleInstallStatus -Name AzureAD) {
    try {
        $SessionInfo = Connect-AzureAD -ErrorAction Stop | Select-Object Account, TenantId, TenantDomain
    }
    catch {
        Write-Warning "Authentication Failed..."
        Write-Warning $Error[0]
        Exit 1
    }
}
else {
    Install-Module AzureAD -Force
    try {
        $SessionInfo = Connect-AzureAD -ErrorAction Stop | Select-Object Account, TenantId, TenantDomain
    }
    catch {
        Write-Warning "Authentication Failed..."
        Write-Warning $Error[0]
        Exit 1
    }
}
