<#
# ############################################################################
# Filename: \Intune\Remediation Scripts\Set-NetConnectionProfileToPublic\Detect-NetConnectionProfile.ps1
# Repository: Public
# Created Date: Tuesday, June 25th 2024, 4:23:52 PM
# Last Modified: Tuesday, June 25th 2024, 4:55:36 PM
# Original Author: Darnel Kumar
# Author Github: https://github.com/Darnel-K
# Github Org: https://github.com/ABYSS-ORG-UK/
#
# This code complies with: https://gist.github.com/Darnel-K/8badda0cabdabb15359350f7af911c90
# Copyright (c) 2024 Darnel Kumar
# ############################################################################
#>

<#
.SYNOPSIS
    Detects if there are any non-private network connections
.DESCRIPTION
    Detects if any of the connection profiles on the system are set to private
.EXAMPLE
    & .\Detect-NetConnectionProfile.ps1
#>
begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Detect-NetConnectionProfile";
    $sourceExists = try { ([System.Diagnostics.EventLog]::SourceExists($LogSource)) } catch { $false }
    if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not $sourceExists ) {
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
    $net_connection_profiles, $Errors = @(), 0
    $net_type_to_detect = "Private"
}

process {
    $net_connection_profiles += Get-NetConnectionProfile | Where-Object { ($_.NetworkCategory -like $net_type_to_detect) }
}

end {
    if ($net_connection_profiles.Count -gt 0) {
        Write-Host "Detected $($net_connection_profiles.Count) $net_type_to_detect Profiles"
        Exit 1
    }
    else {
        Write-Host "Detected 0 $net_type_to_detect Profiles"
        Exit 0
    }
}
