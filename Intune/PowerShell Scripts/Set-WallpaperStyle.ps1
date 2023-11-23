<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Set-WallpaperStyle.ps1                  #
# Repository: Public                                                           #
# Created Date: Friday, June 2nd 2023, 5:22:51 PM                              #
# Last Modified: Thursday, November 23rd 2023, 4:28:44 PM                      #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

<#
.SYNOPSIS
    Set Windows Wallpaper Style
.DESCRIPTION
    Set Windows Wallpaper Style on the executing device
.EXAMPLE
    & .\Set-WallpaperStyle.ps1
#>
begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Set-WallpaperStyle";
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
    $RegKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
    $RegData = @(
        [PSCustomObject]@{
            Path  = $RegKeyPath
            Name  = "WallpaperStyle"
            Value = "3"
            Type  = "STRING"
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
    RUNDLL32.EXE USER32.DLL, UpdatePerUserSystemParameters 1, True
    Exit 0
}
