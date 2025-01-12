<#
# #################################################################################################################### #
# Filename: \Intune\Remediation Scripts\Docker-Users Local Group Membership\Fix-DockerUsersLocalGroupMembership.ps1    #
# Repository: Public                                                                                                   #
# Created Date: Saturday, January 4th 2025, 9:53:31 PM                                                                 #
# Last Modified: Sunday, January 12th 2025, 10:48:54 PM                                                                #
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
    Remediation script
.DESCRIPTION
    Sets the membership of the docker-users group to the current active user profiles
.EXAMPLE
    & .\Fix-DockerUsersLocalGroupMembership.ps1
#>

# Script functions

function init {
    $CUSTOM_LOG.Information("Checking local group 'docker-users' exists and Docker Desktop is installed.")
    $group = Get-LocalGroup | Where-Object -Property Name -EQ "docker-users"
    if ((detectAppInstallState) -and ($group.Count -eq 1)) {
        $CUSTOM_LOG.Information("Local group 'docker-users' exists and Docker Desktop is installed")
        $CUSTOM_LOG.Information("Getting local user profiles active in the last 30 days")
        $filter_date = (Get-Date).AddDays(-30)
        $user_profiles = Get-CimInstance Win32_UserProfile | Where-Object { ($_.Special -EQ $false) -and ($_.Loaded -EQ $true) -and ($_.LastUseTime -GE $filter_date) }
        if ($user_profiles.Count -gt 0) {
            $CUSTOM_LOG.Success("Found '$($user_profiles.Count)' user profiles")
            $CUSTOM_LOG.Information("Removing current members of 'docker-users'")
            try {
                Get-LocalGroupMember -Group docker-users | Remove-LocalGroupMember -Group docker-users
                if ((Get-LocalGroupMember -Group docker-users).Count -EQ 0) {
                    $CUSTOM_LOG.Success("Successfully removed current members of 'docker-users'")
                    $CUSTOM_LOG.Information("Attempting to add active user profiles to 'docker-users'")
                    foreach ($user_profile in $user_profiles) {
                        try {
                            Add-LocalGroupMember -Group docker-users -Member $user_profile.SID
                            $CUSTOM_LOG.Success("Added '$($user_profile.SID)' to 'docker-users' successfully")
                        }
                        catch {
                            $CUSTOM_LOG.Fail("Unable to add '$($user_profile.SID)' to 'docker-users'")
                            $CUSTOM_LOG.Error($Error)
                        }
                    }
                    $CUSTOM_LOG.Information("Checking group membership matches active user profiles")
                    if ((Get-LocalGroupMember -Group "docker-users").Count -EQ $user_profiles.Count) {
                        $CUSTOM_LOG.Success("Group membership count and active user profile count matches")
                        if ((Compare-Object -ReferenceObject $user_profiles -DifferenceObject (Get-LocalGroupMember -Group "docker-users") -Property SID -IncludeEqual | Where-Object -Property SideIndicator -EQ "==").Count -eq $user_profiles.Count) {
                            $CUSTOM_LOG.Success("Current group membership matches active user profiles")
                            $CUSTOM_LOG.Information("No further action required.")
                            Exit 0
                        }
                        else {
                            $CUSTOM_LOG.Error("Group membership does not match active user profiles")
                            $CUSTOM_LOG.Error($Error)
                            Exit 1
                        }
                    }
                    else {
                        $CUSTOM_LOG.Error("Group membership and user profile count does not match")
                        $CUSTOM_LOG.Error($Error)
                        Exit 1
                    }
                }
            }
            catch {
                $CUSTOM_LOG.Error($Error)
                Exit 1
            }
        }
        else {
            $CUSTOM_LOG.Error("Found '$($user_profiles.Count)' user profiles")
            Exit 1
        }
    }
    else {
        $CUSTOM_LOG.Information("Local group 'docker-users' does not exist or Docker Desktop is not installed")
        Exit 1
    }
}

$APP_NAME = "Docker Desktop" # Name of the software (Bitwarden, Python, Google Chrome)
$INSTALL_DIRECTORY = "$env:ProgramFiles\Docker\Docker" # Folder path that the software is installed
$INSTALLED_EXECUTABLE = "Docker Desktop.exe" # Installed software executable
$FULL_INSTALLED_SOFTWARE_PATH = "$INSTALL_DIRECTORY\$INSTALLED_EXECUTABLE"

function detectAppInstallState {
    if (Test-Path "$FULL_INSTALLED_SOFTWARE_PATH" -PathType Leaf) {
        $CUSTOM_LOG.Information("'$APP_NAME' is installed on this device")
        $CUSTOM_LOG.Information("Installation path for '$APP_NAME' is '$FULL_INSTALLED_SOFTWARE_PATH'")
        return $true
    }
    else {
        $CUSTOM_LOG.Information("'$APP_NAME' is not installed on this device")
        return $false
    }
}

#################################
#                               #
#   REQUIRED SCRIPT VARIABLES   #
#                               #
#################################

# DO NOT REMOVE THESE VARIABLES
# DO NOT LEAVE THESE VARIABLES BLANK

$SCRIPT_NAME = "Docker-Users local group membership" # This is used in the window title and the event log entries.

################################################
#                                              #
#   DO NOT EDIT ANYTHING BELOW THIS MESSAGE!   #
#                                              #
################################################

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

# Pre-defined Variables - DO NOT CHANGE!
$SCRIPT_NAME = ".Intune.PSScript.$($SCRIPT_NAME.Replace(' ',''))"
[Boolean]$IS_SYSTEM = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).Identities.IsSystem
[Boolean]$IS_ADMIN = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
[String]$EXEC_USER = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).Identities.Name
[Int]$PID = [System.Diagnostics.Process]::GetCurrentProcess().Id

# Script & Terminal Preferences - DO NOT CHANGE!
$ProgressPreference = "Continue"
$InformationPreference = "Continue"
$DebugPreference = "SilentlyContinue"
$ErrorActionPreference = "Continue"
$VerbosePreference = "SilentlyContinue"
$WarningPreference = "Continue"
$host.ui.RawUI.WindowTitle = $SCRIPT_NAME

# Create new instance of CustomLog class and initialise Event Log - DO NOT CHANGE!
$CUSTOM_LOG = [CustomLog]::new($SCRIPT_NAME)
$CUSTOM_LOG.InitEventLog()

# Console Signature - DO NOT CHANGE!
$SCRIPT_FILENAME = $MyInvocation.MyCommand.Name
function sig {
    $len = @(($SCRIPT_NAME.Length + 13), ($SCRIPT_FILENAME.Length + 10), 20, 42, 29, 40, 63, 62, 61, 44)
    $len_max = ($len | Measure-Object -Maximum).Maximum
    Write-Host "`t####$('#'*$len_max)####`n`t#   $(' '*$len_max)   #`n`t#   Script Name: $($SCRIPT_NAME)$(' '*($len_max-$len[0]))   #`n`t#   Filename: $($SCRIPT_FILENAME)$(' '*($len_max-$len[1]))   #`n`t#   $(' '*$len_max)   #`n`t#   Author: Darnel Kumar$(' '*($len_max-$len[2]))   #`n`t#   Author GitHub: https://github.com/Darnel-K$(' '*($len_max-$len[3]))   #`n`t#   Copyright $([char]0x00A9) $(Get-Date -Format  'yyyy') Darnel Kumar$(' '*($len_max-$len[4]))   #`n`t#   $(' '*$len_max)   #`n`t#   $('-'*$len_max)   #`n`t#   $(' '*$len_max)   #`n`t#   License: GNU General Public License v3.0$(' '*($len_max-$len[5]))   #`n`t#   $(' '*$len_max)   #`n`t#   This program is distributed in the hope that it will be useful,$(' '*($len_max-$len[6]))   #`n`t#   but WITHOUT ANY WARRANTY; without even the implied warranty of$(' '*($len_max-$len[7]))   #`n`t#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the$(' '*($len_max-$len[8]))   #`n`t#   GNU General Public License for more details.$(' '*($len_max-$len[9]))   #`n`t#   $(' '*$len_max)   #`n`t####$('#'*$len_max)####`n" -ForegroundColor Green
}

# Define CustomLog class - DO NOT CHANGE!
class CustomLog {
    [string] $log_name
    [string] $log_source
    hidden [Boolean] $event_log_init

    CustomLog() {
        $this.log_name = "ABYSS.ORG.UK"
        $this.event_log_init = $false
        $this.log_source = "Default"
    }

    CustomLog([String]$log_source) {
        $this.log_name = "ABYSS.ORG.UK"
        $this.event_log_init = $false
        $this.log_source = $log_source
    }

    CustomLog([String]$log_name, [String]$log_source) {
        $this.log_name = $log_name
        $this.event_log_init = $false
        $this.log_source = $log_source
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
$CUSTOM_LOG.Information("Script PID: $PID")
init
