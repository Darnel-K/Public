<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Set-UserLocale(UK).ps1                  #
# Repository: Public                                                           #
# Created Date: Friday, November 24th 2023, 10:02:01 PM                        #
# Last Modified: Friday, November 24th 2023, 10:04:27 PM                       #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

<#
.SYNOPSIS
    This script sets the system language settings to English (United Kingdom).
.DESCRIPTION
    This script installs the English (United Kingdom) language pack from the windows store, sets the system to English (United Kingdom), sets the date and time formats and uninstalls all other language packs.
.NOTES
    This script can be run standalone or deployed using Intune
.EXAMPLE
    & .\Set-UserLocale(UK).ps1
#>

begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Set-Locale(UK)";
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
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Started Setting User Locale to United Kingdom." -EventId 0
    $DesiredLanguage = "en-GB"
    $RegPath = "HKCU:\Control Panel\International"
    $RegData = @(
        [PSCustomObject]@{
            Path  = $RegPath
            Name  = "iFirstDayOfWeek"
            Value = "0"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "sTimeFormat"
            Value = "hh:mm:ss tt"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "sShortDate"
            Value = "yyyy-MM-dd"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "sLongDate"
            Value = "dddd, dd MMMM yyyy"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "sLanguage"
            Value = "ENG"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "sDate"
            Value = "-"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "iDate"
            Value = "2"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "LocaleName"
            Value = "en-GB"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "Locale"
            Value = "00000809"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "iFirstWeekOfYear"
            Value = "2"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "iMeasure"
            Value = "0"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "iNegCurr"
            Value = "1"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "iPaperSize"
            Value = "9"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "iCountry"
            Value = "44"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "iTLZero"
            Value = "1"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "sCurrency"
            Value = "£"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegPath
            Name  = "sShortTime"
            Value = "hh:mm tt"
            Type  = "STRING"
        }
    )
}

process {

    # Check if WinSystemLocale is set to $DesiredLanguage
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Checking if WinSystemLocale is set to $DesiredLanguage" -EventId 0
    if (-not ((Get-WinSystemLocale).Name -eq $DesiredLanguage)) {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "WinSystemLocale not set to $DesiredLanguage" -EventId 0
        try {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Attempting to set WinSystemLocale to $DesiredLanguage" -EventId 0
            Set-WinSystemLocale -SystemLocale $DesiredLanguage
            if ((Get-WinSystemLocale).Name -eq $DesiredLanguage) {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "WinSystemLocale set to $DesiredLanguage successfully" -EventId 0
            }
            else {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set WinSystemLocale to $DesiredLanguage" -EventId 0
                Exit 1
            }
        }
        catch {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set WinSystemLocale to $DesiredLanguage" -EventId 0
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 0
            Exit 1
        }
    }
    else {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "WinSystemLocale already set to $DesiredLanguage" -EventId 0
    }

    # Check if WinHomeLocation is set to United Kingdom
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Checking if WinHomeLocation is set to United Kingdom" -EventId 0
    if (-not ((Get-WinHomeLocation).GeoId -eq 242)) {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "WinHomeLocation not set to United Kingdom" -EventId 0
        try {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Attempting to set WinHomeLocation to United Kingdom" -EventId 0
            Set-WinHomeLocation -GeoId 242
            if ((Get-WinHomeLocation).GeoId -eq 242) {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "WinHomeLocation set to United Kingdom successfully" -EventId 0
            }
            else {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set WinHomeLocation to United Kingdom" -EventId 0
                Exit 1
            }
        }
        catch {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set WinHomeLocation to United Kingdom" -EventId 0
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 0
            Exit 1
        }
    }
    else {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "WinHomeLocation already set to United Kingdom" -EventId 0
    }

    # Set user culture
    try {
        Set-Culture $DesiredLanguage
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Culture '$DesiredLanguage' set successfully" -EventId 0
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set culture '$DesiredLanguage'" -EventId 0
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 0
        Exit 1
    }

    # Set Date/Time format in the registry
    foreach ($i in $RegData) {
        if (!(Test-Path -Path $i.Path)) {
            try {
                New-Item -Path $i.Path -Force
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Created path: $($i.Path)" -EventId 0
            }
            catch {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message "Failed to create registry path: $($i.Path)" -EventId 0
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
                Exit 1
            }
        }
        if ((Get-ItemProperty $i.Path).PSObject.Properties.Name -contains $i.Name) {
            try {
                Set-ItemProperty -Path $i.Path -Name $i.Name -Value $i.Value
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message (@('Successfully made the following registry edit:', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)") | Out-String) -EventId 0
            }
            catch {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message @('Failed to make the following registry edit:', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)") -EventId 0
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
                Exit 1
            }
        }
        else {
            try {
                New-ItemProperty -Path $i.Path -Name $i.Name -Value $i.Value -Type $i.Type
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message (@('Created the following registry entry:', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)") | Out-String) -EventId 0
            }
            catch {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message @('Failed to make the following registry edit:', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)") -EventId 0
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
                Exit 1
            }
        }
    }
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Completed registry update successfully." -EventId 0
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Finished Setting User Locale to United Kingdom." -EventId 0
    Exit 0
}
