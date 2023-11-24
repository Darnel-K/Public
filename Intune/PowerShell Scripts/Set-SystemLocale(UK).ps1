<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Set-SystemLocale(UK).ps1                #
# Repository: Public                                                           #
# Created Date: Friday, November 24th 2023, 10:02:01 PM                        #
# Last Modified: Friday, November 24th 2023, 10:03:35 PM                       #
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
.EXAMPLE
    & .\Set-SystemLocale(UK).ps1
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
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Started Setting System Locale to United Kingdom." -EventId 0
    $DesiredLanguage = "en-GB"
    try {
        New-PSDrive HKU Registry HKEY_USERS
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Mounted 'HKEY_USERS' registry hive." -EventId 0
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message "Unable to mount 'HKEY_USERS' registry hive." -EventId 0
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
        Exit 1
    }
    $RegHKUPath = "HKU:\.DEFAULT\Control Panel\International"
    $RegHKCUPath = "HKCU:\Control Panel\International"
    $RegData = @(
        [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "iFirstDayOfWeek"
            Value = "0"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "sTimeFormat"
            Value = "hh:mm:ss tt"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "sShortDate"
            Value = "yyyy-MM-dd"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "sLongDate"
            Value = "dddd, dd MMMM yyyy"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "sLanguage"
            Value = "ENG"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "sDate"
            Value = "-"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "iDate"
            Value = "2"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "LocaleName"
            Value = "en-GB"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "Locale"
            Value = "00000809"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "iFirstWeekOfYear"
            Value = "2"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "iMeasure"
            Value = "0"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "iNegCurr"
            Value = "1"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "iPaperSize"
            Value = "9"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "iCountry"
            Value = "44"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "iTLZero"
            Value = "1"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "sCurrency"
            Value = "£"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKUPath
            Name  = "sShortTime"
            Value = "hh:mm tt"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "iFirstDayOfWeek"
            Value = "0"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "sTimeFormat"
            Value = "hh:mm:ss tt"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "sShortDate"
            Value = "yyyy-MM-dd"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "sLongDate"
            Value = "dddd, dd MMMM yyyy"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "sLanguage"
            Value = "ENG"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "sDate"
            Value = "-"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "iDate"
            Value = "2"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "LocaleName"
            Value = "en-GB"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "Locale"
            Value = "00000809"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "iFirstWeekOfYear"
            Value = "2"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "iMeasure"
            Value = "0"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "iNegCurr"
            Value = "1"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "iPaperSize"
            Value = "9"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "iCountry"
            Value = "44"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "iTLZero"
            Value = "1"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "sCurrency"
            Value = "£"
            Type  = "STRING"
        }, [PSCustomObject]@{
            Path  = $RegHKCUPath
            Name  = "sShortTime"
            Value = "hh:mm tt"
            Type  = "STRING"
        }
    )
}

process {

    # Check if Language Pack is installed and install if not
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Checking if $DesiredLanguage Language Pack is installed" -EventId 0
    if (-not (Get-WinUserLanguageList | Where-Object { $_.LanguageTag -eq $DesiredLanguage })) {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "$DesiredLanguage Language Pack not installed" -EventId 0
        try {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Attempting to install $DesiredLanguage Language Pack" -EventId 0
            Install-Language $DesiredLanguage -CopyToSettings
            if (Get-WinUserLanguageList | Where-Object { $_.LanguageTag -eq $DesiredLanguage }) {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "$DesiredLanguage Language Pack installed successfully" -EventId 0
            }
            else {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to install $DesiredLanguage Language Pack" -EventId 0
                Exit 1
            }
        }
        catch {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to install $DesiredLanguage Language Pack" -EventId 0
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 0
            Exit 1
        }
    }
    else {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "$DesiredLanguage Language Pack already installed" -EventId 0
    }

    # Check if SystemPreferredUILanguage is set to the Desired Language
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Checking if SystemPreferredUILanguage is set to $DesiredLanguage" -EventId 0
    if (-not ((Get-SystemPreferredUILanguage) -eq $DesiredLanguage)) {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "SystemPreferredUILanguage not set to $DesiredLanguage" -EventId 0
        try {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Attempting to set SystemPreferredUILanguage to $DesiredLanguage" -EventId 0
            Set-SystemPreferredUILanguage $DesiredLanguage
            if ((Get-SystemPreferredUILanguage) -eq $DesiredLanguage) {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "SystemPreferredUILanguage set to $DesiredLanguage successfully" -EventId 0
            }
            else {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set SystemPreferredUILanguage to $DesiredLanguage" -EventId 0
                Exit 1
            }
        }
        catch {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set SystemPreferredUILanguage to $DesiredLanguage" -EventId 0
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 0
            Exit 1
        }
    }
    else {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "SystemPreferredUILanguage already set to $DesiredLanguage" -EventId 0
    }

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

    # Uninstall other language packs
    $OtherLanguagePacks = (Get-InstalledLanguage) | Where-Object { $_.LanguageId -ne $DesiredLanguage }
    foreach ($item in $OtherLanguagePacks) {
        try {
            Uninstall-Language -Language $item.LanguageId
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Uninstalled '$($item.LanguageId)' Language Pack successfully" -EventId 0
        }
        catch {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to uninstall '$($item.LanguageId)' Language Pack" -EventId 0
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 0
        }
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

    # Copy locale settings to system
    try {
        Copy-UserInternationalSettingsToSystem -WelcomeScreen $True -NewUser $True
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Copied locale settings to system" -EventId 0
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to copy locale settings to system" -EventId 0
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 0
    }
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Finished Setting System Locale to United Kingdom." -EventId 0
    Exit 0
}
