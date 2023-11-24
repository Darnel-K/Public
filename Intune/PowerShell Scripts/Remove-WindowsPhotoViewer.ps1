<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Remove-WindowsPhotoViewer.ps1           #
# Repository: Public                                                           #
# Created Date: Friday, November 24th 2023, 11:42:03 AM                        #
# Last Modified: Friday, November 24th 2023, 2:43:02 PM                        #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

<#
.SYNOPSIS
    Removes Windows Photo Viewer
.DESCRIPTION
    Removes Windows Photo Viewer on the executing device by setting the file associations
.EXAMPLE
    & .\Remove-WindowsPhotoViewer.ps1
#>
begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Remove-WindowsPhotoViewer";
    if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not ([System.Diagnostics.EventLog]::SourceExists($LogSource))) {
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
            Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        }
        [PSCustomObject]@{
            Path = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.BITMAP"
        }
        [PSCustomObject]@{
            Path = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JPEG"
        }
        [PSCustomObject]@{
            Path = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF"
        }
        [PSCustomObject]@{
            Path = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.GIF"
        }
        [PSCustomObject]@{
            Path = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.PNG"
        }
        [PSCustomObject]@{
            Path = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.WDP"
        }
        [PSCustomObject]@{
            Path = "HKLM:\SOFTWARE\Classes\jpegfile\shell\open\DropTarget"
            Name = "Clsid"
        }
        [PSCustomObject]@{
            Path = "HKLM:\SOFTWARE\Classes\pngfile\shell\open\DropTarget"
            Name = "Clsid"
        }
    )
}

process {
    foreach ($i in $RegData) {
        if (Test-Path -Path $i.Path) {
            if ($i.Name) {
                try {
                    Remove-ItemProperty -Path $i.Path -Name $i.Name
                    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message (@('Removed registry Property:', "Key: $($i.Path)", "Property: $($i.Name)") | Out-String) -EventId 0
                }
                catch {
                    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message "Failed to remove registy property: $($i.Name) at path: $($i.Path)" -EventId 0
                    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
                }
            }
            else {
                try {
                    Remove-Item -Path $i.Path -Recurse -Force
                    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message (@('Removed registry Key:', "Key: $($i.Path)") | Out-String) -EventId 0
                }
                catch {
                    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message "Failed to remove registy path: $($i.Path)" -EventId 0
                    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Error -Message $Error[0] -EventId 0
                }
            }
        }
    }
    Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Completed registry update successfully." -EventId 0
    Exit 0
}
