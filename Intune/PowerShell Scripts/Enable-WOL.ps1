<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Enable-WOL.ps1                          #
# Repository: Public                                                           #
# Created Date: Friday, June 2nd 2023, 5:22:51 PM                              #
# Last Modified: Thursday, November 23rd 2023, 4:20:29 PM                      #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

<#
.SYNOPSIS
    Enables WOL
.DESCRIPTION
    Enables Wake On LAN on the executing device
.EXAMPLE
    & .\Enable-WOL.ps1
#>
begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Enable-WOL";
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
    $networkAdapters = @()
    $Errors = 0
}

process {
    $networkAdapters += Get-NetAdapterPowerManagement | Where-Object { (($_.Name -like "*Ethernet*") -or ($_.Name -like "*WiFi*")) -and (($_.WakeOnMagicPacket -eq "Disabled") -or ($_.WakeOnPattern -eq "Disabled")) }
    foreach ($item in $networkAdapters) {
        try {
            powercfg.exe /deviceenablewake "$($item.InterfaceDescription)"
            Enable-NetAdapterPowerManagement -InputObject $item -WakeOnMagicPacket -WakeOnPattern
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Enabled WOL on '$($item.Name)' - '$($item.InterfaceDescription)'." -EventId 0
        }
        catch {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message "Unable to enable WOL on '$($item.Name)' - '$($item.InterfaceDescription)'." -EventId 0
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
            $Errors++
        }
    }
}

end {
    $failedAdapters = @()
    $failedAdapters += Get-NetAdapterPowerManagement | Where-Object { (($_.Name -like "*Ethernet*") -or ($_.Name -like "*WiFi*")) -and (($_.WakeOnMagicPacket -eq "Disabled") -or ($_.WakeOnPattern -eq "Disabled")) }
    if (($failedAdapters.Count -eq 0) -and ($Errors -eq 0)) {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Enabled WOL on all network devices." -EventId 0
        Exit 0
    }
    else {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message "Unable to enable WOL on all devices. Check Event Log for more info." -EventId 0
        Exit 1
    }
}
