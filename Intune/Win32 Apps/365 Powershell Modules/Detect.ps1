<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\365 Powershell Modules\Detect.ps1
 * Repository: Public
 * Created Date: Tuesday, January 31st 2023, 10:32:14 AM
 * Last Modified: Wednesday, February 1st 2023, 9:25:53 AM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
Start-Transcript -Path "$env:USERPROFILE\Logs\Detect365PowerShellModules.Intune.log" -Force
$PSModules = @("PnP.PowerShell", "AzureADPreview", "ExchangeOnlineManagement", "Microsoft.Online.SharePoint.PowerShell", "MicrosoftTeams")

foreach ($item in $PSModules) {
    $Installed = Get-InstalledModule -Name $item -ErrorAction SilentlyContinue
    if ($Installed) {
        Write-Host "[INSTALLED] - $item" -ForegroundColor Green
    }
    else {
        Write-Host "[ MISSING ] - $item" -ForegroundColor Red
        Exit 1
    }
}
Write-Host "All Modules Installed!" -ForegroundColor Green
Stop-Transcript
Exit 0
