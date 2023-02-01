<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\365 Powershell Modules\Uninstall.ps1
 * Repository: Public
 * Created Date: Tuesday, January 31st 2023, 10:32:14 AM
 * Last Modified: Wednesday, February 1st 2023, 9:25:53 AM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
Start-Transcript -Path "$env:USERPROFILE\Logs\Uninstall365PowerShellModules.Intune.log" -Force
$PSModules = @("PnP.PowerShell", "AzureADPreview", "ExchangeOnlineManagement", "Microsoft.Online.SharePoint.PowerShell", "MicrosoftTeams")

foreach ($item in $PSModules) {
    $Installed = Get-InstalledModule -Name $item -ErrorAction SilentlyContinue
    if ($Installed) {
        Write-Host "[ INSTALLED ] - $item" -ForegroundColor Red
        Write-Host "[UNINSTALLING] - $item" -ForegroundColor Yellow
        Uninstall-Module -Name $item -Force -Confirm:$false -Verbose:$false
        if ((Get-InstalledModule -Name $item -ErrorAction SilentlyContinue)) {
            Write-Host "[  FAILED  ] - $item" -ForegroundColor Red
            Exit 1
        }
        else {
            Write-Host "[UNINSTALLED] - $item" -ForegroundColor Green
        }
    }
    else {
        Write-Host "[ MISSING ] - $item" -ForegroundColor Green
    }
}
Write-Host "All Modules Uninstalled!" -ForegroundColor Green
Stop-Transcript
Exit 0
