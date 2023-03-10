<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Invoke-SetRegionUK.ps1
 * Repository: Public
 * Created Date: Friday, March 10th 2023, 4:23:48 PM
 * Last Modified: Friday, March 10th 2023, 5:47:57 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

# https://superuser.com/questions/1579847/what-do-i-have-to-specify-to-make-set-culture-set-a-default-of-24-hours-rather-t
# https://stackoverflow.com/questions/28749439/changing-windows-time-and-date-format
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
