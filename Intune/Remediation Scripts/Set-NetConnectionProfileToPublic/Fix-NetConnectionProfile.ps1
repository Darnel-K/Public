<#
# #################################################################################################################### #
# Filename: \Intune\Remediation Scripts\Set-NetConnectionProfileToPublic\Fix-NetConnectionProfile.ps1                  #
# Repository: Public                                                                                                   #
# Created Date: Saturday, January 4th 2025, 9:53:31 PM                                                                 #
# Last Modified: Saturday, January 4th 2025, 9:54:36 PM                                                                #
# Original Author: Darnel Kumar                                                                                        #
# Author Github: https://github.com/Darnel-K                                                                           #
#                                                                                                                      #
# This code complies with: https://gist.github.com/Darnel-K/8badda0cabdabb15359350f7af911c90                           #
#                                                                                                                      #
# License: GNU General Public License v3.0 only - https://www.gnu.org/licenses/gpl-3.0-standalone.html                 #
# Copyright (c) 2025 Darnel Kumar                                                                                      #
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
    Changes network connection profile
.DESCRIPTION
    Sets the network connection profile for all networks on the system
.EXAMPLE
    & .\Fix-NetConnectionProfile.ps1
#>
begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Fix-NetConnectionProfile";
    $sourceExists = try { ([System.Diagnostics.EventLog]::SourceExists($LogSource)) } catch { $false }
    if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not $sourceExists ) {
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
    $net_connection_profiles, $Errors = @(), 0
    $net_type_to_detect = "Private"
    $net_type_to_set = "Public"
}

process {
    Get-NetConnectionProfile | Where-Object { ($_.NetworkCategory -like $net_type_to_detect) } | Set-NetConnectionProfile -NetworkCategory $net_type_to_set
}

end {
    $net_connection_profiles += Get-NetConnectionProfile | Where-Object { ($_.NetworkCategory -like $net_type_to_detect) }
    if ($net_connection_profiles.Count -gt 0) {
        Write-Host "Detected $($net_connection_profiles.Count) $net_type_to_detect Profiles"
        Exit 1
    }
    else {
        Write-Host "Detected 0 $net_type_to_detect Profiles"
        Exit 0
    }
}
