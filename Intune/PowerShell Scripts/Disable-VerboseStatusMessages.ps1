<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Disable-VerboseStatusMessages.ps1
 * Repository: Public
 * Created Date: Wednesday, November 9th 2022, 9:20:26 AM
 * Last Modified: Wednesday, November 9th 2022, 2:13:05 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>
$RegKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$VerboseProperty = "verbosestatus"
$StatusMsgProperty = "DisableStatusMessages"

if ((Get-ItemProperty $RegKey).PSObject.Properties.Name -contains $VerboseProperty) {
    try {
        Set-Itemproperty -path $RegKey -Name $VerboseProperty -value '0'
    }
    catch {
        $_.Exception.Message
    }
}
else {
    try {
        New-ItemProperty -path $RegKey -Name $VerboseProperty -value '0' -Type DWORD
    }
    catch {
        $_.Exception.Message
    }

}
if ((Get-ItemProperty $RegKey).PSObject.Properties.Name -contains $StatusMsgProperty) {
    try {
        Set-Itemproperty -path $RegKey -Name $StatusMsgProperty -value '1'
    }
    catch {
        $_.Exception.Message
    }
}
else {
    try {
        New-ItemProperty -path $RegKey -Name $StatusMsgProperty -value '1' -Type DWORD
    }
    catch {
        $_.Exception.Message
    }

}
Exit $LASTEXITCODE
