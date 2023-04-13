<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Set-UKLocale.ps1
 * Repository: Public
 * Created Date: Monday, March 13th 2023, 5:24:01 PM
 * Last Modified: Thursday, April 13th 2023, 2:58:19 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

<#
.SYNOPSIS
    A brief description of the function or script. This keyword can be used only once in each topic.
.DESCRIPTION
    A detailed description of the function or script. This keyword can be used only once in each topic.
.NOTES
    This script can be run standalone or deployed using Intune
.EXAMPLE
    & .\Set-UKLocale.ps1
#>

[CmdletBinding()]
Param ()

# Declare Variables
$ProgressPreference = "Continue"
$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
$LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.SetUKLocale";
$DesiredLanguage = "en-GB"
$PackageName = "Microsoft.LanguageExperiencePacken-GB"


if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not ([System.Diagnostics.EventLog]::SourceExists($LogSource))) {
    try {
        New-EventLog -LogName $LogName -Source $LogSource
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Initialised Event Log: $LogSource" -EventId 1
    }
    catch {
        $Message = "Unable to initialise event log '$LogName' with source '$LogSource', falling back to event log 'Application' with source 'Application'"
        $LogName = "Application"; $LogSource = "Application"; # DO NOT CHANGE
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Message -EventId 1000
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 1000
    }
}

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
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to install $DesiredLanguage Language Pack" -EventId 1001
            Exit 1
        }
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to install $DesiredLanguage Language Pack" -EventId 1001
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 1001
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
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set SystemPreferredUILanguage to $DesiredLanguage" -EventId 1002
            Exit 1
        }
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set SystemPreferredUILanguage to $DesiredLanguage" -EventId 1002
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 1001
        Exit 1
    }
}
else {
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "SystemPreferredUILanguage already set to $DesiredLanguage" -EventId 0
}
