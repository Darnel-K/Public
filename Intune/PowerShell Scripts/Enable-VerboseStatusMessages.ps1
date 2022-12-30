<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Enable-VerboseStatusMessages.ps1
 * Repository: Public
 * Created Date: Wednesday, November 9th 2022, 9:20:26 AM
 * Last Modified: Friday, December 30th 2022, 5:06:36 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>
$RegData = @(
    [PSCustomObject]@{
        Path  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        Name  = "verbosestatus"
        Value = "1"
        Type  = "DWord"
    }
    [PSCustomObject]@{
        Path  = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        Name  = "DisableStatusMessages"
        Value = "0"
        Type  = "DWord"
    }
)

foreach ($i in $RegData) {
    if ((Get-ItemProperty $i.Path).PSObject.Properties.Name -contains $i.Name) {
        try {
            Set-ItemProperty -Path $i.Path -Name $i.Name -Value $i.Value
        }
        catch {
            Write-Warning @('Failed to make the following registry edit.', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)")
            Write-Verbose $Error[0]
            Exit 1
        }
    }
    else {
        try {
            New-ItemProperty -Path $i.Path -Name $i.Name -Value $i.Value -Type $i.Type
        }
        catch {
            Write-Warning @('Failed to make the following registry edit.', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)")
            Write-Verbose $Error[0]
            Exit 1
        }
    }
}
Exit 0
