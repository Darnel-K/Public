<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Disable-IPv6.ps1
 * Repository: Public
 * Created Date: Monday, May 15th 2023, 10:15:02 PM
 * Last Modified: Monday, May 15th 2023, 10:18:02 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6
