<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Enable-Autologon.ps1                    #
# Repository: Public                                                           #
# Created Date: Tuesday, October 17th 2023, 12:24:58 AM                        #
# Last Modified: Thursday, November 23rd 2023, 3:36:03 PM                      #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

<#
.SYNOPSIS
    Enables Auto Logon
.DESCRIPTION
    Enables Auto Logon on the executing device
.EXAMPLE
    & .\Enable-Autologon.ps1
#>
begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Enable-Autologon";
    if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not ([System.Diagnostics.EventLog]::SourceExists($LogSource))) {
        try {
            New-EventLog -LogName $LogName -Source $LogSource
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Initialised Event Log: $LogSource" -EventId 0
        }
        catch {
            $Message = "Unable to initialise event log '$LogName' with source '$LogSource', falling back to event log 'Application' with source 'Application'"
            $LogName = "Application"; $LogSource = "Application"; # DO NOT CHANGE
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Message -EventId 0
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 0
        }
    }
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
}

process {
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
}
