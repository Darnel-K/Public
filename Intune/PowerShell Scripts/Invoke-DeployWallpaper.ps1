<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Invoke-DeployWallpaper.ps1              #
# Repository: Public                                                           #
# Created Date: Friday, June 2nd 2023, 5:22:51 PM                              #
# Last Modified: Thursday, November 23rd 2023, 4:32:47 PM                      #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

<#
.SYNOPSIS
    Deploy Wallpaper
.DESCRIPTION
    Deploy custom wallpaper to executing device.
.EXAMPLE
    & .\Invoke-DeployWallpaper.ps1
#>
begin {
    If ($ENV:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
        Try {
            Write-Host "Starting in 64 bit mode"
            &"$ENV:WINDIR\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -File $PSCOMMANDPATH
        }
        Catch {
            Throw "Failed to start $PSCOMMANDPATH"
            Exit 1
        }
        Exit 1
    }
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Invoke-DeployWallpaper";
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
    $b64 = ""
    $LockScreenWallpaperFile = ''
    $DesktopWallpaperFile = ''
    $RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
    $StatusValue = "1"
    $RegData = @()

    if (!($LockScreenWallpaperFile -eq "")) {
        if ( !(Test-Path -Path $LockScreenWallpaperFile) ) {
            New-Item -ItemType Directory -Path $LockScreenWallpaperFile
        }
        if (Test-Path -Path "$LockScreenWallpaperFile") {
            Remove-Item -Path "$LockScreenWallpaperFile"
        }
        $bytes = [Convert]::FromBase64String($b64)
        [IO.File]::WriteAllBytes("$LockScreenWallpaperFile", $bytes)
        if (Test-Path -Path "$LockScreenWallpaperFile") {
            Write-Host "File created successfully"
        }
        else {
            Write-Host "Failed to create file"
            Exit 1
        }
        $RegData += [PSCustomObject]@{
            Path  = $RegKeyPath
            Name  = "LockScreenImagePath"
            Value = $LockScreenWallpaperFile
            Type  = "STRING"
        }
        $RegData += [PSCustomObject]@{
            Path  = $RegKeyPath
            Name  = "LockScreenImageStatus"
            Value = $StatusValue
            Type  = "DWORD"
        }
    }

    if (!($DesktopWallpaperFile -eq "")) {
        if ( !(Test-Path -Path $DesktopWallpaperFile)) {
            New-Item -ItemType Directory -Path $DesktopWallpaperFile
        }
        if (Test-Path -Path "$DesktopWallpaperFile") {
            Remove-Item -Path "$DesktopWallpaperFile"
        }
        $bytes = [Convert]::FromBase64String($b64)
        [IO.File]::WriteAllBytes("$DesktopWallpaperFile", $bytes)
        if (Test-Path -Path "$DesktopWallpaperFile") {
            Write-Host "File created successfully"
        }
        else {
            Write-Host "Failed to create file"
            Exit 1
        }
        $RegData += [PSCustomObject]@{
            Path  = $RegKeyPath
            Name  = "DesktopImagePath"
            Value = $DesktopWallpaperFile
            Type  = "STRING"
        }
        $RegData += [PSCustomObject]@{
            Path  = $RegKeyPath
            Name  = "DesktopImageStatus"
            Value = $StatusValue
            Type  = "DWORD"
        }
        $RegData += [PSCustomObject]@{
            Path  = $RegKeyPath
            Name  = "DesktopImageUrl"
            Value = $DesktopWallpaperFile
            Type  = "STRING"
        }
    }
}

process {
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
}
