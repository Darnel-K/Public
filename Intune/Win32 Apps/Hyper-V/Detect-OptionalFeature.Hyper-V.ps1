<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\Hyper-V\Detect-OptionalFeature.Hyper-V.ps1
 * Repository: Public
 * Created Date: Friday, March 10th 2023, 2:01:50 PM
 * Last Modified: Friday, March 10th 2023, 2:51:33 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
if ( ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Hypervisor).State -eq "Enabled") -and (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-Clients).State -eq "Enabled") {
    Write-Host "[INSTALLED] - Hyper-V" -ForegroundColor Green
    Exit 0
}
else {
    Write-Host "[ MISSING ] - Hyper-V" -ForegroundColor Red
    Exit 1
}
