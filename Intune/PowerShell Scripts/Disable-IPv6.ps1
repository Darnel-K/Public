<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Disable-IPv6.ps1                        #
# Repository: Public                                                           #
# Created Date: Friday, November 24th 2023, 10:02:01 PM                        #
# Last Modified: Monday, November 27th 2023, 6:40:10 PM                        #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
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
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Disable-IPv6";
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
    $networkAdapters, $Errors = @(), 0
}

process {
    $networkAdapters += Get-NetAdapterBinding | Where-Object -Property ComponentID -Like "*tcpip6*" | Where-Object -Property Enabled -EQ $true
    foreach ($item in $networkAdapters) {
        try {
            Disable-NetAdapterBinding -InputObject $item
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Disabled '$($item.DisplayName)' on '$($item.Name)'." -EventId 0
        }
        catch {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message "Unable to disable '$($item.DisplayName)' on '$($item.Name)'." -EventId 0
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
            $Errors++
        }
    }
}

end {
    $failedAdapters = @()
    $failedAdapters += Get-NetAdapterBinding | Where-Object -Property ComponentID -Like "*tcpip6*" | Where-Object -Property Enabled -EQ $true
    if (($failedAdapters.Count -eq 0) -and ($Errors -eq 0)) {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Disabled IPv6 on all network devices." -EventId 0
        Exit 0
    }
    else {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message "Unable to disable IPv6 on all devices. Check Event Log for more info." -EventId 0
        Exit 1
    }
}
