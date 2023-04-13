<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Set-UKLocale.ps1
 * Repository: Public
 * Created Date: Monday, March 13th 2023, 5:24:01 PM
 * Last Modified: Thursday, April 13th 2023, 11:49:46 AM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

<#
.SYNOPSIS
    A brief description of the function or script. This keyword can be used only once in each topic.
.DESCRIPTION
    A detailed description of the function or script. This keyword can be used only once in each topic.
.NOTES
    This script can be run standalone or deployed using Intune
.EXAMPLE
    & .\Set-UKLocale.ps1
#>

[CmdletBinding()]
Param ()

# Declare Variables
$ProgressPreference = "Continue"
$host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
$LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.SetUKLocale";


if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not ([System.Diagnostics.EventLog]::SourceExists($LogSource))) {
    try {
        New-EventLog -LogName $LogName -Source $LogSource
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Initialised Event Log: $LogSource" -EventId 1
    }
    catch {
        $Message = "Unable to initialise event log '$LogName' with source '$LogSource', falling back to event log 'Application' with source 'Application'"
        $LogName = "Application"; $LogSource = "Application"; # DO NOT CHANGE
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Message -EventId 1000
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 1000
    }
}
# Add any code here that needs be done once during the initialisation phase
# e.g. database connections, variable declarations, Event Log checks
