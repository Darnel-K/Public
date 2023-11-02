<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Invoke-DeployWallpaper.ps1              #
# Repository: Public                                                           #
# Created Date: Wednesday, June 14th 2023, 9:52:14 AM                          #
# Last Modified: Thursday, November 2nd 2023, 10:57:32 AM                      #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

$b64 = ""
$Filename = ""
$LockScreenWallpaperPath = ''
$DesktopWallpaperPath = ''
$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$StatusValue = "1"

if ( !(Test-Path -Path $LockScreenWallpaperPath) ) {
    New-Item -ItemType Directory -Path $LockScreenWallpaperPath
}
if ( !(Test-Path -Path $DesktopWallpaperPath)) {
    New-Item -ItemType Directory -Path $DesktopWallpaperPath
}

if (Test-Path -Path "$LockScreenWallpaperPath\$Filename") {
    Remove-Item -Path "$LockScreenWallpaperPath\$Filename"
}
if (Test-Path -Path "$DesktopWallpaperPath\$Filename") {
    Remove-Item -Path "$DesktopWallpaperPath\$Filename"
}

$bytes = [Convert]::FromBase64String($b64)
[IO.File]::WriteAllBytes("$LockScreenWallpaperPath\$Filename", $bytes)
if (Test-Path -Path "$LockScreenWallpaperPath\$Filename") {
    Write-Host "File created successfully"
}
else {
    Write-Host "Failed to create file"
    Exit 1
}

$bytes = [Convert]::FromBase64String($b64)
[IO.File]::WriteAllBytes("$DesktopWallpaperPath\$Filename", $bytes)
if (Test-Path -Path "$DesktopWallpaperPath\$Filename") {
    Write-Host "File created successfully"
}
else {
    Write-Host "Failed to create file"
    Exit 1
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
    # [PSCustomObject]@{
    #     Path  = $RegKeyPath
    #     Name  = "LockScreenImagePath"
    #     Value = $LockScreenWallpaperFile
    #     Type  = "STRING"
    # }
    # [PSCustomObject]@{
    #     Path  = $RegKeyPath
    #     Name  = "LockScreenImageStatus"
    #     Value = $StatusValue
    #     Type  = "DWORD"
    # }
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
