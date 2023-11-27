<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Set-TaskbarOptions.ps1                  #
# Repository: Public                                                           #
# Created Date: Friday, November 24th 2023, 10:02:01 PM                        #
# Last Modified: Monday, November 27th 2023, 6:40:10 PM                        #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

<#
.SYNOPSIS
    Sets taskbar options
.DESCRIPTION
    Removes the below buttons from the taskbar:
     - Chat
     - Widgets
     - Taskview
    Aligns taskbar to the left
.EXAMPLE
    & .\Set-TaskbarOptions.ps1
#>
begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Set-TaskbarOptions";
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
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name  = "ShowTaskViewButton" # Shows / Hides Task View Taskbar Button: 0 = Hidden, 1 = Shown
            Value = "0"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name  = "TaskbarMn" # Shows / Hides Chat Taskbar Button: 0 = Hidden, 1 = Shown
            Value = "0"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name  = "TaskbarDa" # Shows / Hides Widgets Taskbar Button: 0 = Hidden, 1 = Shown
            Value = "0"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            Name  = "TaskbarAl" # Aligns Taskbar to the left or center: 0 = Left, 1 = Center
            Value = "0"
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
