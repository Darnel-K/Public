<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\365 Powershell Modules\Install.ps1
 * Repository: Public
 * Created Date: Tuesday, January 31st 2023, 10:32:14 AM
 * Last Modified: Wednesday, February 1st 2023, 10:04:17 AM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
Start-Transcript -Path "$env:USERPROFILE\Logs\Install365PowerShellModules.Intune.log" -Force
$PSModules = @("PnP.PowerShell", "AzureADPreview", "ExchangeOnlineManagement", "Microsoft.Online.SharePoint.PowerShell", "MicrosoftTeams")
# Check for NuGet package provider
if ((Get-PackageProvider -Name NuGet)) {
    Write-Host "[INSTALLED] - NuGet" -ForegroundColor Green
}
else {
    Write-Host "[ MISSING ] - NuGet" -ForegroundColor Red
    Write-Host "[INSTALLING] - NuGet" -ForegroundColor Yellow
    Install-PackageProvider -Name NuGet -Scope CurrentUser -Confirm:$false -Force -ForceBootstrap
    if ((Get-PackageProvider -Name NuGet)) {
        Write-Host "[INSTALLED] - NuGet" -ForegroundColor Green
    }
    else {
        Write-Host "[ FAILED ] - NuGet" -ForegroundColor Red
    }
}

# Check for and install each required module
foreach ($item in $PSModules) {
    $Installed = Get-InstalledModule -Name $item -ErrorAction SilentlyContinue
    if ($Installed) {
        Write-Host "[INSTALLED] - $item" -ForegroundColor Green
    }
    else {
        Write-Host "[ MISSING ] - $item" -ForegroundColor Red
        Write-Host "[INSTALLING] - $item" -ForegroundColor Yellow
        Install-Module -Name $item -Scope CurrentUser -Force -Confirm:$false -AllowClobber
        if ((Get-InstalledModule -Name $item -ErrorAction SilentlyContinue)) {
            Write-Host "[INSTALLED] - $item" -ForegroundColor Green
        }
        else {
            Write-Host "[ FAILED ] - $item" -ForegroundColor Red
        }
    }
}
Write-Host "All Modules Installed!" -ForegroundColor Green
Stop-Transcript
Exit 0
