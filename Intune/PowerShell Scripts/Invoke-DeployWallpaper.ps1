<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Invoke-DeployWallpaper.ps1              #
# Repository: Public                                                           #
# Created Date: Wednesday, June 14th 2023, 9:52:14 AM                          #
# Last Modified: Thursday, November 2nd 2023, 10:20:21 AM                      #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

$b64 = ""
$LockScreenWallpaperFile = 'C:\Windows\Web\DeployedWallpaper.jpg'
$DesktopWallpaperFile = '%USERPROFILE%\Local Settings\Application Data\Sysinternals\BGInfo\ModifiedWallpaper.bmp'
$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$StatusValue = "1"

if ( !(Test-Path -Path $LockScreenWallpaperFile) ) {
    $bytes = [Convert]::FromBase64String($b64)
    [IO.File]::WriteAllBytes($LockScreenWallpaperFile, $bytes)
    if ( Test-Path -Path $LockScreenWallpaperFile) {
        Write-Output "File created successfully"
    }
    else {
        Write-Output "Failed to create file"
        Exit 1
    }
}
else {
    Write-Output "File already exists"
}

$RegData = @(
    [PSCustomObject]@{
        Path  = $RegKeyPath
        Name  = "DesktopImagePath"
        Value = $DesktopWallpaperFile
        Type  = "STRING"
    }
    [PSCustomObject]@{
        Path  = $RegKeyPath
        Name  = "DesktopImageStatus"
        Value = $StatusValue
        Type  = "DWORD"
    }
    [PSCustomObject]@{
        Path  = $RegKeyPath
        Name  = "DesktopImageUrl"
        Value = $DesktopWallpaperFile
        Type  = "STRING"
    }
    [PSCustomObject]@{
        Path  = $RegKeyPath
        Name  = "LockScreenImagePath"
        Value = $LockScreenWallpaperFile
        Type  = "STRING"
    }
    [PSCustomObject]@{
        Path  = $RegKeyPath
        Name  = "LockScreenImageStatus"
        Value = $StatusValue
        Type  = "DWORD"
    }
)

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
