<#
 * ############################################################################ 
 * Filename: \Intune\Win32 Apps\Bitwarden\uninstall.ps1
 * Repository: Public
 * Created Date: Saturday, March 11th 2023, 7:20:57 PM
 * Last Modified: Saturday, March 11th 2023, 7:22:13 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 * 
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################ 
#>
Get-AppxPackage -AllUsers "*Bitwarden*" | Remove-AppxPackage
Get-appxprovisionedpackage –online | where-object { $_.packagename –like "*Bitwarden*" } | remove-appxprovisionedpackage –online
