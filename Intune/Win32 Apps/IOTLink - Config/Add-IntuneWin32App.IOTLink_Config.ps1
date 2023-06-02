<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\IOTLink - Config\Add-IntuneWin32App.IOTLink_Config.ps1
 * Repository: Public
 * Created Date: Sunday, March 12th 2023, 2:18:06 PM
 * Last Modified: Friday, June 2nd 2023, 4:02:41 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

<#
.SYNOPSIS
    Installs IOTLink Config
.DESCRIPTION
    Script for an Intune Win32 to install IOTLink Config silently
.NOTES
    Not supported on linux
.EXAMPLE
    & .\Add-IntuneWin32App.IOTLink_Config.ps1
#>

begin {
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.Win32App.IOTLink_Config";
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
    if (Test-Path $env:ProgramData"\IOTLink\Configs\configuration.yaml" -PathType Leaf) {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Removing existing IOTLink Config" -EventId 0
        Remove-Item -Path $env:ProgramData"\IOTLink\Configs\configuration.yaml" -Recurse -Force -Confirm:$false
    }
}

process {
    try {
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Copying IOTLink Config" -EventId 0
        Copy-Item -Path "$PSScriptRoot\configuration.yaml" -Destination $env:ProgramData"\IOTLink\Configs\configuration.yaml"
        Copy-Item -Path "$PSScriptRoot\CustomConfig.txt" -Destination $env:ProgramData"\IOTLink\Configs\CustomConfig.txt"
        if (Test-Path $env:ProgramData"\IOTLink\Configs\configuration.yaml" -PathType Leaf) {
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "IOTLink Config copied successfully" -EventId 0
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
