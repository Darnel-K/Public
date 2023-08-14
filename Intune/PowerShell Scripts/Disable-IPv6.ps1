<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Disable-IPv6.ps1
 * Repository: Public
 * Created Date: Monday, August 14th 2023, 12:26:40 PM
 * Last Modified: Monday, August 14th 2023, 2:13:42 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

<#
.SYNOPSIS
    Disables IPv6
.DESCRIPTION
    Disables IPv6 on the executing device
.EXAMPLE
    & .\Disable-IPv6.ps1
#>
begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.DisableIPv6";
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
}

process {
    try {
        Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Disabled IPv6 on all network devices." -EventId 0
        Exit 0
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message "Unable to disable IPv6" -EventId 0
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
        Exit 1
    }
}
