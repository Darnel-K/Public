<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\Hyper-V\Remove-OptionalFeature.Hyper-V.ps1
 * Repository: Public
 * Created Date: Friday, March 10th 2023, 2:01:17 PM
 * Last Modified: Friday, March 10th 2023, 3:10:41 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
try {
    Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart
    if ( ((Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Hypervisor).State -eq "Disabled") -and (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-Clients).State -eq "Disabled") {
        Write-Host "[  MISSING  ] - Hyper-V" -ForegroundColor Green
        Exit 0
    }
    else {
        Write-Host "[  FAILED  ] - Hyper-V" -ForegroundColor Red
        Exit 1
    }
}
catch {
    Write-Warning "[  FAILED  ] - Hyper-V"
    Write-Verbose $Error[0]
    Exit 1
}
