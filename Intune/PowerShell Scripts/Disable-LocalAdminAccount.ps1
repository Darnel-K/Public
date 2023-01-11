<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Disable-LocalAdminAccount.ps1
 * Repository: Public
 * Created Date: Wednesday, November 9th 2022, 9:34:32 AM
 * Last Modified: Wednesday, January 11th 2023, 12:55:59 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>
$User = "Administrator"
try {
    # Check if $User is enabled
    $Result = (Get-LocalUser -Name $user -ErrorAction Stop).Enabled
    try {
        if ($Result) {
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
