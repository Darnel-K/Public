<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\Bitwarden\Remove-IntuneWin32App.Bitwarden.ps1
 * Repository: Public
 * Created Date: Sunday, March 12th 2023, 2:18:06 PM
 * Last Modified: Sunday, March 12th 2023, 10:59:14 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
<#
.SYNOPSIS
    Uninstalls Bitwarden
.DESCRIPTION
    Script for an Intune Win32 to uninstall bitwarden silently
.NOTES
    Not supported on linux
.LINK
    https://github.com/Darnel-K/Public/blob/master/Intune/Win32%20Apps/Bitwarden/README.md
.EXAMPLE
    & .\Remove-IntuneWin32App.Bitwarden.ps1
#>

begin {
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.Win32App.Bitwarden";
    if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not ([System.Diagnostics.EventLog]::SourceExists($LogSource))) {
        New-EventLog -LogName $LogName -Source $LogSource
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Initialised Event Log: $LogSource" -EventId 0
    }
    if (-not (Test-Path "$env:ProgramFiles\Bitwarden\Bitwarden.exe" -PathType Leaf)) {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Bitwarden already uninstalled" -EventId 0
        Exit 0
    }
}

process {
    try {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Starting Bitwarden uninstallation" -EventId 0
        Start-Process -FilePath $env:ProgramFiles"\Bitwarden\Uninstall Bitwarden.exe" -Wait -WindowStyle Hidden -ArgumentList "/S /ALLUSERS" -Verb RunAs
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Bitwarden uninstallation complete" -EventId 0
        Exit 0
    }
    catch {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
        Exit 1
    }
}

end {

}
