<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Invoke-SetRegionUK.ps1
 * Repository: Public
 * Created Date: Friday, March 10th 2023, 4:23:48 PM
 * Last Modified: Friday, March 10th 2023, 5:34:17 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
$LanguageFeatures = (Get-InstalledLanguage -Language en-GB).LanguageFeatures
if (($null -eq $LanguageFeatures) -or ($LanguageFeatures -eq "None")) {
    try {
        Install-Language 'en-GB' -CopyToSettings
    }
    catch {
        Write-Warning $Error[0]
    }

}

if (Get-SystemPreferredUILanguage -ne "en-GB") {
    try {
        Set-SystemPreferredUILanguage en-GB
    }
    catch {
        Write-Warning $Error[0]
    }
}

Set-Culture 'en-GB'
$culture = Get-Culture

$culture.DateTimeFormat.FirstDayOfWeek = 'Monday'
$culture.DateTimeFormat.FullDateTimePattern = 'dddd, dd MMMM yyyy hh:mm:ss tt'
$culture.DateTimeFormat.LongDatePattern = 'dddd, dd MMMM yyyy'
$culture.DateTimeFormat.LongTimePattern = 'hh:mm:ss tt'
$culture.DateTimeFormat.ShortDatePattern = 'yyyy-MM-dd'
$culture.DateTimeFormat.ShortTimePattern = 'hh:mm tt'

Set-Culture $culture

Set-WinHomeLocation -GeoId 242

Set-WinSystemLocale -SystemLocale 'en-GB'
