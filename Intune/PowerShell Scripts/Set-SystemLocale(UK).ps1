<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Set-SystemLocale(UK).ps1                #
# Repository: Public                                                           #
# Created Date: Thursday, April 13th 2023, 11:41:25 AM                         #
# Last Modified: Friday, November 24th 2023, 2:10:23 PM                        #
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
    & .\Set-SystemLocale(UK).ps1
#>

[CmdletBinding()]
Param ()

# Declare Variables
$ProgressPreference = "Continue"
$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
$LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Set-SystemLocale(UK)";
$DesiredLanguage = "en-GB"
$DesiredRegion = "GB"


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

# Create new Culture
$CultureName = "ABYSS-ORG-UK_$DesiredLanguage"
$CultureExists = $false
Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Checking if culture: '$CultureName' exists" -EventId 0
try {
    if (-not (([cultureinfo]::GetCultureInfo($CultureName)).DisplayName -like "*Unknown*")) {
        $CultureExists = $true
    }
}
catch {
    $CultureExists = $false
}
if (-not $CultureExists) {
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Culture: '$CultureName' does not exist" -EventId 0
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Attempting to create new windows culture: '$CultureName'" -EventId 0
    $BaseCulture = [cultureinfo]::GetCultureInfo($DesiredLanguage)
    $BaseRegion = New-Object System.Globalization.RegionInfo "$DesiredRegion"
    $Changes = @{
        GregorianDateTimeFormat = [Hashtable]@{
            FullDateTimePattern = "dddd, dd MMMM yyyy - hh:mm:ss tt"
            LongDatePattern     = "dddd, dd MMMM yyyy"
            LongTimePattern     = "hh:mm:ss tt"
            MonthDayPattern     = "dd MMMM"
            ShortDatePattern    = "yyyy-MM-dd"
            ShortTimePattern    = "hh:mm tt"
        }
        CultureEnglishName      = "English (United Kingdom) - Modified"
        CultureNativeName       = "English (United Kingdom) - Modified"
    }

    try {
        # Set up CultureAndRegionInfoBuilder
        Add-Type -AssemblyName sysglobl
        $CultureBuilder = New-Object System.Globalization.CultureAndRegionInfoBuilder @($CultureName, [System.Globalization.CultureAndRegionModifiers]::None)
        $CultureBuilder.LoadDataFromCultureInfo($BaseCulture)
        $CultureBuilder.LoadDataFromRegionInfo($BaseRegion)
        # Make appropriate changes
        foreach ($Property in $Changes.Keys) {
            if (($CultureBuilder.$Property -is [string]) -or ($CultureBuilder.$Property -is [int])) {
                $CultureBuilder.$Property = $Changes[$Property]
            }
            else {
                foreach ($item in $Changes.$Property.Keys) {
                    $CultureBuilder.$Property.$item = $Changes.$Property.$item
                }
            }
        }
        # Register your new culture
        $CultureBuilder.Register()
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Culture: '$CultureName' created successfully" -EventId 0
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to create culture: '$CultureName'" -EventId 1003
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 1003
        Exit 1
    }
}
else {
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Culture: '$CultureName' already exists" -EventId 0
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
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 1002
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
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set WinSystemLocale to $DesiredLanguage" -EventId 1007
            Exit 1
        }
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set WinSystemLocale to $DesiredLanguage" -EventId 1007
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 1007
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
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set WinHomeLocation to United Kingdom" -EventId 1005
            Exit 1
        }
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set WinHomeLocation to United Kingdom" -EventId 1005
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 1005
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
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to uninstall '$($item.LanguageId)' Language Pack" -EventId 1008
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 1008
    }
}

# Set user culture
try {
    Set-Culture $CultureName
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Culture '$CultureName' set successfully" -EventId 0
}
catch {
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to set culture '$CultureName'" -EventId 1006
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 1006
    Exit 1
}

# Copy locale settings to system
try {
    Copy-UserInternationalSettingsToSystem -WelcomeScreen $True -NewUser $True
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Copied locale settings to system" -EventId 0
}
catch {
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message "Unable to copy locale settings to system" -EventId 1004
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 1004
}
Exit 0
