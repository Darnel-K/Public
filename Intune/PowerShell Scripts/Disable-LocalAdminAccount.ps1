<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Disable-LocalAdminAccount.ps1
 * Repository: Public
 * Created Date: Wednesday, November 9th 2022, 9:34:32 AM
 * Last Modified: Wednesday, November 9th 2022, 2:13:12 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>
$User = "Administrator"
try {
    $Result = (Get-LocalUser -Name $user -ErrorAction Stop).Enabled
    try {
        if ($Result) {
            Disable-LocalUser -Name $User
        }
    }
    catch {
        $_.Exception.Message #in case disable fails
    }
}
catch {
    $_.Exception.Message #if user doesnt exist
}
