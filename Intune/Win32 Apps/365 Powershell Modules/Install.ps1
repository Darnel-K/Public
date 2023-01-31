<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\365 Powershell Modules\Install.ps1
 * Repository: Public
 * Created Date: Tuesday, January 31st 2023, 10:32:14 AM
 * Last Modified: Tuesday, January 31st 2023, 11:55:07 AM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
$PSModules = @("PnP.PowerShell", "AzureADPreview", "ExchangeOnlineManagement", "Microsoft.Online.SharePoint.PowerShell", "MicrosoftTeams")

foreach ($item in $PSModules) {
    $Installed = Get-InstalledModule -Name $item -ErrorAction SilentlyContinue
    if ($Installed) {
        Write-Host "[INSTALLED] - $item" -ForegroundColor Green
    }
    else {
        Write-Host "[ MISSING ] - $item" -ForegroundColor Red
        Write-Host "[INSTALLING] - $item" -ForegroundColor Yellow
        Install-Module -Name $item -Force -AllowClobber -Scope AllUsers
        if ((Get-InstalledModule -Name $item -ErrorAction SilentlyContinue)) {
            Write-Host "[INSTALLED] - $item" -ForegroundColor Green
        }
        else {
            Write-Host "[ FAILED ] - $item" -ForegroundColor Red
        }
    }
}
Write-Host "All Modules Installed!" -ForegroundColor Green
Exit 0
