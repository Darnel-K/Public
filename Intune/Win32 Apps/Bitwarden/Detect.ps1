<#
 * ############################################################################ 
 * Filename: \Intune\Win32 Apps\Bitwarden\Detect.ps1
 * Repository: Public
 * Created Date: Saturday, March 11th 2023, 7:20:57 PM
 * Last Modified: Saturday, March 11th 2023, 7:22:33 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 * 
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################ 
#>
$app = "Bitwarden"
if (Get-AppxPackage -Name *Bitwarden* -AllUsers) {
    Write-Output "$app App Installed"
    Exit 0
}
else {
    Write-Error "Error: $app Not Installed"
    Exit 1
}
