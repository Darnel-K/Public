<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Enable-Autologon.ps1                    #
# Repository: Public                                                           #
# Created Date: Tuesday, October 17th 2023, 12:24:58 AM                        #
# Last Modified: Tuesday, October 17th 2023, 12:29:55 AM                       #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$RegData = @(
    [PSCustomObject]@{
        Path  = $RegKeyPath
        Name  = "AutoAdminLogon"
        Value = "1"
        Type  = "STRING"
    }
    [PSCustomObject]@{
        Path  = $RegKeyPath
        Name  = "DefaultUserName"
        Value = "KioskUser0"
        Type  = "STRING"
    }
    [PSCustomObject]@{
        Path  = $RegKeyPath
        Name  = "IsConnectedAutoLogon"
        Value = "0"
        Type  = "DWord"
    }
)

foreach ($i in $RegData) {
    if (!(Test-Path -Path $i.Path)) {
        try {
            New-Item -Path $i.Path -Force
        }
        catch {
            Write-Warning "Failed to create registry path: $($i.Path)"
            Write-Verbose $Error[0]
            Exit 1
        }
    }
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
