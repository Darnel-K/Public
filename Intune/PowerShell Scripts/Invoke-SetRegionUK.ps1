<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Invoke-SetRegionUK.ps1
 * Repository: Public
 * Created Date: Friday, March 10th 2023, 4:23:48 PM
 * Last Modified: Friday, April 14th 2023, 2:03:08 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

# https://superuser.com/questions/1579847/what-do-i-have-to-specify-to-make-set-culture-set-a-default-of-24-hours-rather-t
# https://stackoverflow.com/questions/28749439/changing-windows-time-and-date-format
# https://github.com/okieselbach/Intune/blob/master/Win32/SetLanguage-de-DE/Install-LanguageExperiencePack.ps1


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
