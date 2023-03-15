<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\Bitwarden\Add-IntuneWin32App.Bitwarden.ps1
 * Repository: Public
 * Created Date: Sunday, March 12th 2023, 2:18:06 PM
 * Last Modified: Sunday, March 12th 2023, 4:37:27 PM
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
    Not supported on linux
.LINK
    https://github.com/Darnel-K/Public/blob/master/Intune/Win32%20Apps/Bitwarden/README.md
.EXAMPLE
    & .\Add-IntuneWin32App.Bitwarden.ps1
#>

begin {
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.Win32App.Bitwarden";
    if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not ([System.Diagnostics.EventLog]::SourceExists($LogSource))) {
        New-EventLog -LogName $LogName -Source $LogSource
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Initialised Event Log: $LogSource" -EventId 0
    }
    if (Test-Path "$env:ProgramFiles\Bitwarden\Bitwarden.exe" -PathType Leaf) {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Bitwarden already installed" -EventId 0
        Exit 0
    }
}

process {
    try {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Starting Bitwarden installation" -EventId 0
        Start-Process -FilePath ".\Bitwarden-Installer-2023.2.0.exe" -Wait -WindowStyle Hidden -ArgumentList "/S /ALLUSERS" -Verb RunAs
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Bitwarden installation complete" -EventId 0
        Exit 0
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
        Exit 1
    }

}

end {

}
