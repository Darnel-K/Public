<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\Hyper-V\Enable-OptionalFeature.Hyper-V.ps1
 * Repository: Public
 * Created Date: Friday, March 10th 2023, 2:01:08 PM
 * Last Modified: Friday, March 10th 2023, 3:40:18 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
if ( ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Hypervisor).State -eq "Disabled") -or (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-Clients).State -eq "Disabled") {
    Write-Host "[  MISSING  ] - Hyper-V" -ForegroundColor Red
    try {
        Write-Host "[INSTALLING] - Hyper-V" -ForegroundColor Yellow
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart
        if ( ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Hypervisor).State -eq "Enabled") -and (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-Clients).State -eq "Enabled") {
            Write-Host "[INSTALLED] - Hyper-V" -ForegroundColor Green
            Exit 3010
        }
    }
    catch {
        Write-Warning "[  FAILED  ] - Hyper-V"
        Write-Verbose $Error[0]
        Exit 1
    }
}
elseif ( ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Hypervisor).State -eq "Enabled") -and (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-Clients).State -eq "Enabled") {
    Write-Host "[INSTALLED] - Hyper-V" -ForegroundColor Green
    Exit 0
}
