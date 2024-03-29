<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Enable-ClipboardHistory.ps1             #
# Repository: Public                                                           #
# Created Date: Tuesday, November 28th 2023, 2:48:31 PM                        #
# Last Modified: Tuesday, November 28th 2023, 2:50:20 PM                       #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

<#
.SYNOPSIS
    Enables Clipboard History
.DESCRIPTION
    Enables Clipboard History
.EXAMPLE
    & .\Enable-ClipboardHistory.ps1
#>
begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Enable-ClipboardHistory";
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
    $RegData = @(
        [PSCustomObject]@{
            Path  = "HKCU:\Software\Microsoft\Clipboard"
            Name  = "EnableClipboardHistory" # 0 = Disabled, 1 = Enabled
            Value = "1"
            Type  = "DWord"
        }
    )
}

process {
    foreach ($i in $RegData) {
        if (!(Test-Path -Path $i.Path)) {
            try {
                New-Item -Path $i.Path -Force
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Created path: $($i.Path)" -EventId 0
            }
            catch {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message "Failed to create registry path: $($i.Path)" -EventId 0
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
                Exit 1
            }
        }
        if ((Get-ItemProperty $i.Path).PSObject.Properties.Name -contains $i.Name) {
            try {
                Set-ItemProperty -Path $i.Path -Name $i.Name -Value $i.Value
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message (@('Successfully made the following registry edit:', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)") | Out-String) -EventId 0
            }
            catch {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message @('Failed to make the following registry edit:', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)") -EventId 0
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
                Exit 1
            }
        }
        else {
            try {
                New-ItemProperty -Path $i.Path -Name $i.Name -Value $i.Value -Type $i.Type
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message (@('Created the following registry entry:', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)") | Out-String) -EventId 0
            }
            catch {
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message @('Failed to make the following registry edit:', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)") -EventId 0
                Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
                Exit 1
            }
        }
    }
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Completed registry update successfully." -EventId 0
    Exit 0
}
