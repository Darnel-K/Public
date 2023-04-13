<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Invoke-SetRegionUK.ps1
 * Repository: Public
 * Created Date: Friday, March 10th 2023, 4:23:48 PM
 * Last Modified: Thursday, April 13th 2023, 4:41:52 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

# https://superuser.com/questions/1579847/what-do-i-have-to-specify-to-make-set-culture-set-a-default-of-24-hours-rather-t
# https://stackoverflow.com/questions/28749439/changing-windows-time-and-date-format
# https://github.com/okieselbach/Intune/blob/master/Win32/SetLanguage-de-DE/Install-LanguageExperiencePack.ps1
$DesiredLanguage = "en-GB"
$LanguageFeatures = (Get-InstalledLanguage -Language $DesiredLanguage).LanguageFeatures
if (($null -eq $LanguageFeatures) -or ($LanguageFeatures -eq "None")) {
    try {
        Install-Language $DesiredLanguage -CopyToSettings
    }
    catch {
        Write-Warning $Error[0]
    }

}

if ((Get-SystemPreferredUILanguage) -ne $DesiredLanguage) {
    try {
        Set-SystemPreferredUILanguage $DesiredLanguage
    }
    catch {
        Write-Warning $Error[0]
    }
}

try {
    Set-Culture $DesiredLanguage
}
catch {
    Write-Warning $Error[0]
}


try {
    Set-WinHomeLocation -GeoId 242
}
catch {
    Write-Warning $Error[0]
}
try {
    Set-WinSystemLocale -SystemLocale $DesiredLanguage
}
catch {
    Write-Warning $Error[0]
}

$CultureName = 'ABYSS-ORG-UK_en-GB'
$BaseCulture = [cultureinfo]::GetCultureInfo('en-GB')
$BaseRegion = New-Object System.Globalization.RegionInfo 'GB'
$Changes = @{
    GregorianDateTimeFormat = [Hashtable]@{
        FullDateTimePattern = "dddd, dd MMMM yyyy - hh:mm:ss tt"
        LongDatePattern     = "dddd, dd MMMM yyyy"
        LongTimePattern     = "hh:mm:ss tt"
        MonthDayPattern     = "dd MMMM"
        ShortDatePattern    = "yyyy-MM-dd"
        ShortTimePattern    = "hh:mm tt"
    }
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

}
catch {
    throw
}

$culture = Get-Culture

$culture.DateTimeFormat.FirstDayOfWeek = 'Monday'
$culture.DateTimeFormat.FullDateTimePattern = 'dddd, dd MMMM yyyy hh:mm:ss tt'
$culture.DateTimeFormat.LongDatePattern = 'dddd, dd MMMM yyyy'
$culture.DateTimeFormat.LongTimePattern = 'hh:mm:ss tt'
$culture.DateTimeFormat.ShortDatePattern = 'yyyy-MM-dd'
$culture.DateTimeFormat.ShortTimePattern = 'hh:mm tt'

try {
    Set-Culture $culture
}
catch {
    Write-Warning $Error[0]
}
