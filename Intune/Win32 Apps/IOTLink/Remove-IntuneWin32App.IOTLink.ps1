<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\IOTLink\Remove-IntuneWin32App.IOTLink.ps1
 * Repository: Public
 * Created Date: Sunday, March 12th 2023, 2:18:06 PM
 * Last Modified: Friday, June 2nd 2023, 5:58:53 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

<#
.SYNOPSIS
    Uninstalls IOTLink
.DESCRIPTION
    Script for an Intune Win32 to uninstall IOTLink silently
.NOTES
    Not supported on linux
.EXAMPLE
    & .\Remove-IntuneWin32App.IOTLink.ps1
#>

begin {
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.Win32App.IOTLink";
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
    if (-not (Test-Path "$(${env:ProgramFiles(x86)})\IOTLink\IOTLinkService.exe" -PathType Leaf)) {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "IOTLink already uninstalled" -EventId 0
        Exit 0
    }
}

process {
    try {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Starting IOTLink uninstallation" -EventId 0
        Start-Process -FilePath "sc.exe" -Wait -WindowStyle Hidden -ArgumentList "delete IOTLink" -Verb RunAs
        Start-Process -FilePath "$(${env:ProgramFiles(x86)})\IOTLink\unins000.exe" -Wait -WindowStyle Hidden -ArgumentList "/SILENT /VERYSILENT /SUPPRESSMSGBOXES" -Verb RunAs
        if (-not (Test-Path "$(${env:ProgramFiles(x86)})\IOTLink\IOTLinkService.exe" -PathType Leaf)) {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "IOTLink uninstallation complete" -EventId 0
            Exit 0
        }
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
        Exit 1
    }
}

end {

}
