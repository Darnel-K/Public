<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\Bitwarden\Add-IntuneWin32App.Bitwarden.ps1
 * Repository: Public
 * Created Date: Sunday, March 12th 2023, 2:18:06 PM
 * Last Modified: Sunday, March 12th 2023, 3:55:22 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
<#
.SYNOPSIS
    Installs Bitwarden
.DESCRIPTION
    Script for an Intune Win32 to install bitwarden silently
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    https://github.com/Darnel-K/Public/blob/master/Intune/Win32%20Apps/Bitwarden/README.md
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
# [CmdletBinding()]
# Param (
#     # Param1 help description
#     [Parameter(ValueFromPipeline = $true)]
#     [string]
#     $Var1
# )
begin {
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = "TestApp";
    if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not ([System.Diagnostics.EventLog]::SourceExists($LogSource))) {
        New-EventLog -LogName $LogName -Source $LogSource
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Initialised Event Log: $LogSource" -EventId 0
    }
    # Add any code here that needs be done once during the initialisation phase
    # e.g. database connections, variable declarations, Event Log checks
}

process {
    try {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Starting Bitwarden installation" -EventId 0
        Start-Process -FilePath ".\Bitwarden-Installer-2023.2.0.exe" -Wait -WindowStyle Hidden -ArgumentList "/S" -Verb RunAs
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Bitwarden installation complete" -EventId 0
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
    }

}

end {

}
