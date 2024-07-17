<#
# #################################################################################################################### #
# Filename: \Intune\PowerShell Scripts\Set-WindowsThemeAndAccent.ps1                                                   #
# Repository: Public                                                                                                   #
# Created Date: Wednesday, July 17th 2024, 12:21:58 PM                                                                 #
# Last Modified: Wednesday, July 17th 2024, 2:36:46 PM                                                                 #
# Original Author: Darnel Kumar                                                                                        #
# Author Github: https://github.com/Darnel-K                                                                           #
# Github Org: https://github.com/ABYSS-ORG-UK/                                                                         #
#                                                                                                                      #
# This code complies with: https://gist.github.com/Darnel-K/8badda0cabdabb15359350f7af911c90                           #
#                                                                                                                      #
# License: GNU General Public License v3.0 only - https://www.gnu.org/licenses/gpl-3.0-standalone.html                 #
# Copyright (c) 2024 Darnel Kumar                                                                                      #
#                                                                                                                      #
# This program is free software: you can redistribute it and/or modify                                                 #
# it under the terms of the GNU General Public License as published by                                                 #
# the Free Software Foundation, either version 3 of the License, or                                                    #
# (at your option) any later version.                                                                                  #
#                                                                                                                      #
# This program is distributed in the hope that it will be useful,                                                      #
# but WITHOUT ANY WARRANTY; without even the implied warranty of                                                       #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                                                        #
# GNU General Public License for more details.                                                                         #
# #################################################################################################################### #
#>

<#
.SYNOPSIS
    This script sets the system theme for the current user
.DESCRIPTION
    This script sets the windows theme for the current user to 'dark' mode, sets the accent colour to red and enables 'Show accent colour on the title bars and window borders'
.NOTES
    This script can be run standalone or deployed using Intune
.EXAMPLE
    & .\Set-WindowsThemeAndAccent.ps1
#>

[CmdletBinding()]

#################################
#                               #
#   USER CHANGEABLE VARIABLES   #
#                               #
#################################

$SCRIPT_NAME = "Set-WindowsThemeAndAccent"
$SCRIPT_EXEC_MODE = "Update" # Update or Delete. Tells the script to either update the registry or delete the keys
$REG_DATA = @(
    [PSCustomObject]@{
        Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" # Registry key path
        Name  = "SystemUsesLightTheme" # Registry property name
        Value = "0" # Registry property value
        Type  = "DWord" # Binary, DWord, ExpandString, MultiString, String or QWord
    }
    [PSCustomObject]@{
        Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" # Registry key path
        Name  = "AppsUseLightTheme" # Registry property name
        Value = "0" # Registry property value
        Type  = "DWord" # Binary, DWord, ExpandString, MultiString, String or QWord
    }
    [PSCustomObject]@{
        Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" # Registry key path
        Name  = "AccentPalette" # Registry property name
        Value = [byte[]](("FB 9D 8B 00 F4 67 62 00 EF 27 33 00 E8 11 23 00 D2 0E 1E 00 9E 09 12 00 6F 03 06 00 69 79 7E 00").Split(' ') | ForEach-Object { "0x$_" }) # Registry property value
        Type  = "Binary" # Binary, DWord, ExpandString, MultiString, String or QWord
    }
    [PSCustomObject]@{
        Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" # Registry key path
        Name  = "StartColorMenu" # Registry property name
        Value = "4280159954" # Registry property value
        Type  = "DWord" # Binary, DWord, ExpandString, MultiString, String or QWord
    }
    [PSCustomObject]@{
        Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" # Registry key path
        Name  = "AccentColorMenu" # Registry property name
        Value = "4280488424" # Registry property value
        Type  = "DWord" # Binary, DWord, ExpandString, MultiString, String or QWord
    }
    [PSCustomObject]@{
        Path  = "HKCU:\Software\Microsoft\Windows\DWM" # Registry key path
        Name  = "AccentColor" # Registry property name
        Value = "4280488424" # Registry property value
        Type  = "" # Binary, DWord, ExpandString, MultiString, String or QWord
    }
    [PSCustomObject]@{
        Path  = "HKCU:\Software\Microsoft\Windows\DWM" # Registry key path
        Name  = "ColorizationAfterglow" # Registry property name
        Value = "3303543075" # Registry property value
        Type  = "" # Binary, DWord, ExpandString, MultiString, String or QWord
    }
    [PSCustomObject]@{
        Path  = "HKCU:\Software\Microsoft\Windows\DWM" # Registry key path
        Name  = "ColorizationColor" # Registry property name
        Value = "3303543075" # Registry property value
        Type  = "" # Binary, DWord, ExpandString, MultiString, String or QWord
    }
    [PSCustomObject]@{
        Path  = "HKCU:\Software\Microsoft\Windows\DWM" # Registry key path
        Name  = "ColorPrevalence" # Registry property name
        Value = "1" # Registry property value
        Type  = "DWord" # Binary, DWord, ExpandString, MultiString, String or QWord
    }
)

################################################
#                                              #
#   DO NOT EDIT ANYTHING BELOW THIS MESSAGE!   #
#                                              #
################################################

# Script functions

function updateRegistry {
    foreach ($i in $REG_DATA) {
        if (!(Test-Path -Path $i.Path)) {
            try {
                New-Item -Path $i.Path -Force -ErrorAction Stop | Out-Null
                $CUSTOM_LOG.Success("Created path: $($i.Path)")
            }
            catch {
                $CUSTOM_LOG.Fail("Failed to create registry path: $($i.Path)")
                $CUSTOM_LOG.Error($Error[0])
                Exit 1
            }
        }
        if ((Get-ItemProperty $i.Path).PSObject.Properties.Name -contains $i.Name) {
            try {
                Set-ItemProperty -Path $i.Path -Name $i.Name -Value $i.Value -Force -ErrorAction Stop | Out-Null
                $CUSTOM_LOG.Success("Successfully made the following registry edit:`n - Key: $($i.Path)`n - Property: $($i.Name)`n - Value: $($i.Value)`n - Type: $($i.Type)")
            }
            catch {
                $CUSTOM_LOG.Fail("Failed to make the following registry edit:`n - Key: $($i.Path)`n - Property: $($i.Name)`n - Value: $($i.Value)`n - Type: $($i.Type)")
                $CUSTOM_LOG.Error($Error[0])
                Exit 1
            }
        }
        else {
            try {
                New-ItemProperty -Path $i.Path -Name $i.Name -Value $i.Value -Type $i.Type -Force -ErrorAction Stop | Out-Null
                $CUSTOM_LOG.Success("Created the following registry entry:`n - Key: $($i.Path)`n - Property: $($i.Name)`n - Value: $($i.Value)`n - Type: $($i.Type)")
            }
            catch {
                $CUSTOM_LOG.Fail("Failed to make the following registry edit:`n - Key: $($i.Path)`n - Property: $($i.Name)`n - Value: $($i.Value)`n - Type: $($i.Type)")
                $CUSTOM_LOG.Error($Error[0])
                Exit 1
            }
        }
    }
    $CUSTOM_LOG.Success("Completed registry update successfully.")
    Exit 0
}

function removeRegistry {
    foreach ($i in $REG_DATA) {
        if (Test-Path -Path $i.Path) {
            if ($i.Name) {
                try {
                    Remove-ItemProperty -Path $i.Path -Name $i.Name
                    $CUSTOM_LOG.Success("Removed registry Property:`n - Key: $($i.Path)`n - Property: $($i.Name)")
                }
                catch {
                    $CUSTOM_LOG.Fail("Failed to remove registy property: $($i.Name) at path: $($i.Path)")
                    $CUSTOM_LOG.Error($Error[0])
                    Exit 1
                }
            }
            else {
                try {
                    Remove-Item -Path $i.Path -Recurse -Force
                    $CUSTOM_LOG.Success("Removed registry Key:`n - Key: $($i.Path)")
                }
                catch {
                    $CUSTOM_LOG.Fail("Failed to remove registy path: $($i.Path)")
                    $CUSTOM_LOG.Error($Error[0])
                    Exit 1
                }
            }
        }
    }
    $CUSTOM_LOG.Success("Completed registry update successfully.")
    Exit 0
}

function init {
    switch ($SCRIPT_EXEC_MODE) {
        "Update" { updateRegistry }
        "Delete" { removeRegistry }
        Default { updateRegistry }
    }
}

function checkRunIn64BitPowershell {
    if (($env:PROCESSOR_ARCHITECTURE -eq "x86") -or ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64")) {
        $CUSTOM_LOG.Warning("'$SCRIPT_NAME' is running in 32-bit (x86) mode")
        try {
            $CUSTOM_LOG.Information("Attempting to start $SCRIPT_NAME in 64-bit (x64) mode")
            Start-Process -FilePath "$env:windir\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -Wait -NoNewWindow -ArgumentList "-File ""$PSCOMMANDPATH"""
            Exit 0
        }
        catch {
            $CUSTOM_LOG.Error("Unable to start '$SCRIPT_NAME' in 64-bit (x64) mode")
            $CUSTOM_LOG.Error($Error[0])
            Exit 1
        }
        Exit 1
    }
    else {
        $CUSTOM_LOG.Information("'$SCRIPT_NAME' is running in 64-bit (x64) mode")
    }
}

# Script Variables - DO NOT CHANGE!
$SCRIPT_NAME = ".Intune.PSScript.$($SCRIPT_NAME.Replace(' ',''))"
[Boolean]$IS_SYSTEM = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).Identities.IsSystem
[Boolean]$IS_ADMIN = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Script & Terminal Preferences - DO NOT CHANGE!
$ProgressPreference = "Continue"
$InformationPreference = "Continue"
$DebugPreference = "SilentlyContinue"
$ErrorActionPreference = "Continue"
$VerbosePreference = "SilentlyContinue"
$WarningPreference = "Continue"
$host.ui.RawUI.WindowTitle = $SCRIPT_NAME

# Initialise CustomLog class for event log
$CUSTOM_LOG = [CustomLog]@{log_source = $SCRIPT_NAME }
$CUSTOM_LOG.InitEventLog()

# Console Signature
$SCRIPT_FILENAME = $MyInvocation.MyCommand.Name
function sig {
    $len = @(($SCRIPT_NAME.Length + 13), ($SCRIPT_FILENAME.Length + 10), 20, 42, 29, 40, 63, 62, 61, 44)
    $len_max = ($len | Measure-Object -Maximum).Maximum
    Write-Host "`t####$('#'*$len_max)####`n`t#   $(' '*$len_max)   #`n`t#   Script Name: $($SCRIPT_NAME)$(' '*($len_max-$len[0]))   #`n`t#   Filename: $($SCRIPT_FILENAME)$(' '*($len_max-$len[1]))   #`n`t#   $(' '*$len_max)   #`n`t#   Author: Darnel Kumar$(' '*($len_max-$len[2]))   #`n`t#   Author GitHub: https://github.com/Darnel-K$(' '*($len_max-$len[3]))   #`n`t#   Copyright $([char]0x00A9) $(Get-Date -Format  'yyyy') Darnel Kumar$(' '*($len_max-$len[4]))   #`n`t#   $(' '*$len_max)   #`n`t#   $('-'*$len_max)   #`n`t#   $(' '*$len_max)   #`n`t#   License: GNU General Public License v3.0$(' '*($len_max-$len[5]))   #`n`t#   $(' '*$len_max)   #`n`t#   This program is distributed in the hope that it will be useful,$(' '*($len_max-$len[6]))   #`n`t#   but WITHOUT ANY WARRANTY; without even the implied warranty of$(' '*($len_max-$len[7]))   #`n`t#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the$(' '*($len_max-$len[8]))   #`n`t#   GNU General Public License for more details.$(' '*($len_max-$len[9]))   #`n`t#   $(' '*$len_max)   #`n`t####$('#'*$len_max)####" -ForegroundColor Green
}

# Define CustomLog class
class CustomLog {
    hidden [string] $log_name
    [string] $log_source
    hidden [Boolean] $event_log_init

    CustomLog() {
        $this.log_name = "ABYSS.ORG.UK"
        $this.event_log_init = $false
    }

    [void] InitEventLog() {
        if (-not $this.CheckEventLogExists()) {
            if (-not $this.CreateEventLog()) {
                Write-Warning "Unable to initialise event log '$($this.log_name)' with source '$($this.log_source)', falling back to event log 'Application' with source 'Application'"
                $this.log_name, $this.log_source = "Application", "Application"
                $this.event_log_init = $true
            }
            else {
                $this.event_log_init = $true
                $this.Success("Log initialised using event log '$($this.log_name)' with source '$($this.log_source)'")
            }
        }
        else {
            $this.event_log_init = $true
            Write-Verbose "Event log '$($this.log_name)' with source '$($this.log_source)' already exists, using existing event log"
        }
    }

    [Boolean] CheckEventLogInit($event_log_enabled_per_message = $this.event_log_init) {
        if ($this.event_log_init -and $event_log_enabled_per_message) {
            return $true
        }
        elseif ($this.event_log_init -and -not $event_log_enabled_per_message) {
            return $false
        }
        elseif (-not $this.event_log_init -and -not $event_log_enabled_per_message) {
            return $false
        }
        else {
            Write-Warning "Cannot write to event log!"
            Write-Warning "Event log not initialised, please initialise logging system!"
            return $false
        }
    }

    [Boolean] CheckEventLogExists() {
        Write-Verbose "Checking if event log '$($this.log_name)' & source '$($this.log_source)' exists"
        try {
            if (-not ([System.Diagnostics.EventLog]::Exists($this.log_name)) -or -not ([System.Diagnostics.EventLog]::SourceExists($this.log_source))) {
                Write-Verbose "Event log '$($this.log_name)' or source '$($this.log_source)' does not exist"
                return $false
            }
            else {
                return $true
            }
        }
        catch {
            Write-Verbose "Unable to check if event log '$($this.log_name)' or source '$($this.log_source)' exists"
            Write-Debug $Error[0]
            return $false
        }

    }

    [Boolean] CreateEventLog() {
        try {
            Write-Verbose "Attempting to create event log '$($this.log_name)' & source '$($this.log_source)'"
            New-EventLog -LogName $this.log_name -Source $this.log_source -ErrorAction Stop
            if ($this.CheckEventLogExists()) {
                return $true
            }
            else {
                throw "Unable to create event log '$($this.log_name)' or source '$($this.log_source)'"
            }
        }
        catch {
            Write-Verbose "Unable to create event log '$($this.log_name)' or source '$($this.log_source)'"
            Write-Debug $Error[0]
            return $false
        }
    }

    [void] Success([string]$msg) {
        $this.Success($msg, 0, $this.event_log_init)
    }
    [void] Success([string]$msg, [Boolean]$event_log_enabled) {
        $this.Success($msg, 0, $event_log_enabled)
    }
    [void] Success([string]$msg, [int]$event_id) {
        $this.Success($msg, $event_id, $this.event_log_init)
    }
    [void] Success([string]$msg, [int]$event_id, [Boolean]$event_log_enabled) {
        if ($this.CheckEventLogInit($event_log_enabled)) {
            Write-EventLog -LogName $this.log_name -Source $this.log_source -EntryType SuccessAudit -Message $msg -EventId $event_id
        }
        Write-Host "SUCCESS: $msg" -ForegroundColor Green
    }

    [void] Fail([string]$msg) {
        $this.Fail($msg, 0, $this.event_log_init)
    }
    [void] Fail([string]$msg, [Boolean]$event_log_enabled) {
        $this.Fail($msg, 0, $event_log_enabled)
    }
    [void] Fail([string]$msg, [int]$event_id) {
        $this.Fail($msg, $event_id, $this.event_log_init)
    }
    [void] Fail([string]$msg, [int]$event_id, [Boolean]$event_log_enabled) {
        if ($this.CheckEventLogInit($event_log_enabled)) {
            Write-EventLog -LogName $this.log_name -Source $this.log_source -EntryType FailureAudit -Message $msg -EventId $event_id
        }
        Write-Host "FAILURE: $msg" -ForegroundColor Red
    }

    [void] Information([string]$msg) {
        $this.Information($msg, 0, $this.event_log_init)
    }
    [void] Information([string]$msg, [Boolean]$event_log_enabled) {
        $this.Information($msg, 0, $event_log_enabled)
    }
    [void] Information([string]$msg, [int]$event_id) {
        $this.Information($msg, $event_id, $this.event_log_init)
    }
    [void] Information([string]$msg, [int]$event_id, [Boolean]$event_log_enabled) {
        if ($this.CheckEventLogInit($event_log_enabled)) {
            Write-EventLog -LogName $this.log_name -Source $this.log_source -EntryType Information -Message $msg -EventId $event_id
        }
        Write-Information "INFO: $msg" -InformationAction Continue
    }

    [void] Warning([string]$msg) {
        $this.Warning($msg, 0, $this.event_log_init)
    }
    [void] Warning([string]$msg, [Boolean]$event_log_enabled) {
        $this.Warning($msg, 0, $event_log_enabled)
    }
    [void] Warning([string]$msg, [int]$event_id) {
        $this.Warning($msg, $event_id, $this.event_log_init)
    }
    [void] Warning([string]$msg, [int]$event_id, [Boolean]$event_log_enabled) {
        if ($this.CheckEventLogInit($event_log_enabled)) {
            Write-EventLog -LogName $this.log_name -Source $this.log_source -EntryType Warning -Message $msg -EventId $event_id
        }
        Write-Warning $msg -WarningAction Continue
    }

    [void] Error([string]$msg) {
        $this.Error($msg, 0, $this.event_log_init)
    }
    [void] Error([string]$msg, [Boolean]$event_log_enabled) {
        $this.Error($msg, 0, $event_log_enabled)
    }
    [void] Error([string]$msg, [int]$event_id) {
        $this.Error($msg, $event_id, $this.event_log_init)
    }
    [void] Error([string]$msg, [int]$event_id, [Boolean]$event_log_enabled) {
        if ($this.CheckEventLogInit($event_log_enabled)) {
            Write-EventLog -LogName $this.log_name -Source $this.log_source -EntryType Error -Message $msg -EventId $event_id
        }
        Write-Error "ERROR: $msg" -ErrorAction Continue
    }

}

# Clear console & display signature before script initialisation
Clear-Host
sig
checkRunIn64BitPowershell
init
