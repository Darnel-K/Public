<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Disable-LocalAdminAccount.ps1
 * Repository: Public
 * Created Date: Wednesday, November 9th 2022, 9:34:32 AM
 * Last Modified: Wednesday, February 1st 2023, 1:51:19 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>
$User = "Administrator"
try {
    # Check if $User is enabled
    try {
        if ((Get-LocalUser -Name $user -ErrorAction Stop).Enabled) {
            # Attempt to disable $User
            Disable-LocalUser -Name $User
            Write-Host "User: $User, is disabled."
            Exit 0
        }
    }
    catch {
        Write-Warning $Error[0]
        Exit 1
    }
}
catch {
    Write-Warning $Error[0]
    Exit 1
}
