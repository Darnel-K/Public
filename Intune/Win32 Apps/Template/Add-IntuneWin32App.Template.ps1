<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\Template\Add-IntuneWin32App.Template.ps1
 * Repository: Public
 * Created Date: Sunday, March 12th 2023, 2:18:06 PM
 * Last Modified: Tuesday, April 11th 2023, 2:38:05 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

<#
.SYNOPSIS
    Installs {App}
.DESCRIPTION
    Script for an Intune Win32 to install {App} silently
.NOTES
    Not supported on linux
.LINK
    https://example.org
.EXAMPLE
    & .\Add-IntuneWin32App.Template.ps1
#>

begin {
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.Win32App.{App}";
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
    # if (Test-Path "$env:ProgramFiles\Bitwarden\Bitwarden.exe" -PathType Leaf) {
    #     Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Bitwarden already installed" -EventId 0
    #     Exit 0
    # }
}

process {
    try {
        # Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Starting Bitwarden installation" -EventId 0
        # Start-Process -FilePath ".\Bitwarden-Installer-2023.2.0.exe" -Wait -WindowStyle Hidden -ArgumentList "/S /ALLUSERS" -Verb RunAs
        # if (Test-Path "$env:ProgramFiles\Bitwarden\Bitwarden.exe" -PathType Leaf) {
        #     Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Bitwarden installation complete" -EventId 0
        #     Exit 0
        # }
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
        Exit 1
    }

}

end {

}
