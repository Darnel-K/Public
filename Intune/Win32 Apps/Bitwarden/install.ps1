<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\Bitwarden\install.ps1
 * Repository: Public
 * Created Date: Saturday, March 11th 2023, 7:20:57 PM
 * Last Modified: Sunday, March 12th 2023, 1:57:46 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
$LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.Win32App.Bitwarden";
if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not ([System.Diagnostics.EventLog]::SourceExists($LogSource))) {
    New-EventLog -LogName $LogName -Source $LogSource
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Initialised Event Log: $LogSource" -EventId 0
}

try {
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Starting Bitwarden installation" -EventId 0
    # Start-Process -FilePath ".\Bitwarden-Installer-2023.2.0.exe" -Wait -WindowStyle Hidden -ArgumentList "/S" -Verb RunAs
}
catch {
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0]. -EventId 0
}
