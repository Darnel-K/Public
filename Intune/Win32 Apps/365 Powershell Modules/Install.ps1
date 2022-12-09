<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\365 Powershell Modules\Install.ps1
 * Repository: Public
 * Created Date: Wednesday, November 9th 2022, 10:14:30 AM
 * Last Modified: Friday, December 9th 2022, 4:34:35 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>
$Services = ("AzureAD", "MSOnline", "ExchangeOnline", 'SharePoint', 'SharePointPnP', 'SecAndCompCenter', 'Teams')
Foreach ($Service in $Services) {
    Write-Host Checking install status for $Service...
    Switch ($Service) {
        ExchangeOnline {
            $Module = Get-InstalledModule -Name ExchangeOnlineManagement -MinimumVersion 2.0.3 -ErrorAction SilentlyContinue
            if ($Module.count -eq 0) {
                Write-Host Exchange Online'(EXO V2)' module is not installed  -ForegroundColor yellow
                Install-Module ExchangeOnlineManagement -Force -Scope AllUsers
            }
            else {
                Write-Host Exchange Online'(EXO V2)' module is installed  -ForegroundColor green
            }
        }

        MSOnline {
            $Module = Get-Module -Name MSOnline -ListAvailable -ErrorAction SilentlyContinue
            if ($Module.count -eq 0) {
                Write-Host MSOnline module is not installed  -ForegroundColor yellow
                Install-Module MSOnline -Force -Scope AllUsers
            }
            else {
                Write-Host MSOnline module is installed  -ForegroundColor green
            }
        }

        AzureAD {
            $Module = Get-Module -Name AzureAD -ListAvailable -ErrorAction SilentlyContinue
            if ($Module.count -eq 0) {
                Write-Host AzureAD module is not installed  -ForegroundColor yellow
                Install-Module AzureAD -Force -Scope AllUsers
            }
            else {
                Write-Host AzureAD module is installed  -ForegroundColor green
            }
        }

        SharePoint {
            $Module = Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable -ErrorAction SilentlyContinue
            if ($Module.count -eq 0) {
                Write-Host SharePoint Online PowerShell module is not installed  -ForegroundColor yellow
                Install-Module Microsoft.Online.SharePoint.PowerShell -Force -Scope AllUsers
            }
            else {
                Write-Host SharePoint Online PowerShell module is installed  -ForegroundColor green
            }
        }

        SharePointPnP {
            $Module = Get-InstalledModule -Name SharePointPnPPowerShellOnline -ErrorAction SilentlyContinue
            if ($Module.count -eq 0) {
                Write-Host SharePoint PnP module module is not installed  -ForegroundColor yellow
                Install-Module -Name SharePointPnPPowerShellOnline -AllowClobber -Force -Scope AllUsers
            }
            else {
                Write-Host SharePoint PnP module module is installed  -ForegroundColor green
            }
        }

        SecAndCompCenter {
            $Module = Get-InstalledModule -Name ExchangeOnlineManagement -MinimumVersion 2.0.3 -ErrorAction SilentlyContinue
            if ($Module.count -eq 0) {
                Write-Host Exchange Online'(EXO V2)' module is not installed  -ForegroundColor yellow
                Install-Module ExchangeOnlineManagement -Force -Scope AllUsers
            }
            else {
                Write-Host Exchange Online'(EXO V2)' module is installed  -ForegroundColor green
            }
        }

        Teams {
            $Module = Get-InstalledModule -Name MicrosoftTeams -MinimumVersion 4.0.0 -ErrorAction SilentlyContinue
            if ($Module.count -eq 0) {
                Write-Host MicrosoftTeams module is not installed  -ForegroundColor yellow
                Install-Module MicrosoftTeams -AllowClobber -Force -Scope AllUsers
            }
            else {
                Write-Host MicrosoftTeams module is installed  -ForegroundColor green
            }
        }
    }
}
