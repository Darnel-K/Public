<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Enable-WOL.ps1
 * Repository: Public
 * Created Date: Thursday, June 1st 2023, 2:47:39 PM
 * Last Modified: Thursday, June 1st 2023, 4:17:57 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

$NetAdapters = Get-NetAdapter | Where-Object { ($_.Name -like "*Ethernet*") -or ($_.Name -like "*WiFi*") }

foreach ($item in $NetAdapters) {
    powercfg.exe /deviceenablewake "$($item.InterfaceDescription)"
}

Enable-NetAdapterPowerManagement -Name * -WakeOnMagicPacket -WakeOnPattern
