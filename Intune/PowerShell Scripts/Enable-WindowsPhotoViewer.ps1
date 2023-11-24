<#
# ############################################################################ #
# Filename: \Intune\PowerShell Scripts\Enable-WindowsPhotoViewer.ps1           #
# Repository: Public                                                           #
# Created Date: Friday, November 24th 2023, 11:42:03 AM                        #
# Last Modified: Friday, November 24th 2023, 11:50:24 AM                       #
# Original Author: Darnel Kumar                                                #
# Author Github: https://github.com/Darnel-K                                   #
#                                                                              #
# Copyright (c) 2023 Darnel Kumar                                              #
# ############################################################################ #
#>

<#
.SYNOPSIS
    Re-enables Windows Photo Viewer
.DESCRIPTION
    Re-enables Windows Photo Viewer on the executing device by setting the file associations
.EXAMPLE
    & .\Enable-WindowsPhotoViewer.ps1
#>
begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".Intune.PSScript.Enable-WindowsPhotoViewer";
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
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".bmp"
            Value = "PhotoViewer.FileAssoc.BITMAP"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".dib"
            Value = "PhotoViewer.FileAssoc.BITMAP"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".jpg"
            Value = "PhotoViewer.FileAssoc.JPEG"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".jpe"
            Value = "PhotoViewer.FileAssoc.JPEG"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".jpeg"
            Value = "PhotoViewer.FileAssoc.JPEG"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".jxr"
            Value = "PhotoViewer.FileAssoc.JPEG"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".jfif"
            Value = "PhotoViewer.FileAssoc.JFIF"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".wdp"
            Value = "PhotoViewer.FileAssoc.WDP"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".png"
            Value = "PhotoViewer.FileAssoc.PNG"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".gif"
            Value = "PhotoViewer.FileAssoc.TIFF"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".tiff"
            Value = "PhotoViewer.FileAssoc.TIFF"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
            Name  = ".tif"
            Value = "PhotoViewer.FileAssoc.TIFF"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.BITMAP"
            Name  = "ImageOptionFlags"
            Value = "00000001"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.BITMAP"
            Name  = "FriendlyTypeName"
            Value = "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3056"
            Type  = "ExpandString"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.BITMAP\DefaultIcon"
            Name  = "(Default)"
            Value = "%SystemRoot%\System32\imageres.dll,-72"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.BITMAP\shell\open\command"
            Name  = "(Default)"
            Value = "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
            Type  = "ExpandString"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.BITMAP\shell\open\DropTarget"
            Name  = "CLSID"
            Value = "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF"
            Name  = "EditFlags"
            Value = "00010000"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF"
            Name  = "ImageOptionFlags"
            Value = "00000001"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF"
            Name  = "FriendlyTypeName"
            Value = "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3055"
            Type  = "ExpandString"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\DefaultIcon"
            Name  = "(Default)"
            Value = "%SystemRoot%\System32\imageres.dll,-72"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open"
            Name  = "MuiVerb"
            Value = "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
            Type  = "ExpandString"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\command"
            Name  = "(Default)"
            Value = "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
            Type  = "ExpandString"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\DropTarget"
            Name  = "CLSID"
            Value = "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JPEG"
            Name  = "EditFlags"
            Value = "00010000"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JPEG"
            Name  = "ImageOptionFlags"
            Value = "00000001"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JPEG"
            Name  = "FriendlyTypeName"
            Value = "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3055"
            Type  = "ExpandString"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JPEG\DefaultIcon"
            Name  = "(Default)"
            Value = "%SystemRoot%\System32\imageres.dll,-72"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JPEG\shell\open"
            Name  = "MuiVerb"
            Value = "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
            Type  = "ExpandString"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JPEG\shell\open\command"
            Name  = "(Default)"
            Value = "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.JPEG\shell\open\DropTarget"
            Name  = "CLSID"
            Value = "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.PNG"
            Name  = "ImageOptionFlags"
            Value = "00000001"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.PNG"
            Name  = "FriendlyTypeName"
            Value = "@%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll,-3057"
            Type  = "ExpandString"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.PNG\DefaultIcon"
            Name  = "(Default)"
            Value = "%SystemRoot%\System32\imageres.dll,-71"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.PNG\shell\open\command"
            Name  = "(Default)"
            Value = "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
            Type  = "ExpandString"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.PNG\shell\open\DropTarget"
            Name  = "CLSID"
            Value = "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.WDP"
            Name  = "EditFlags"
            Value = "00010000"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.WDP"
            Name  = "ImageOptionFlags"
            Value = "00000001"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.WDP\DefaultIcon"
            Name  = "(Default)"
            Value = "%SystemRoot%\System32\wmphoto.dll,-400"
            Type  = "String"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.WDP\shell\open"
            Name  = "MuiVerb"
            Value = "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
            Type  = "ExpandString"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.WDP\shell\open\command"
            Name  = "(Default)"
            Value = "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
            Type  = "ExpandString"
        }
        [PSCustomObject]@{
            Path  = "HKLM:\SOFTWARE\Classes\PhotoViewer.FileAssoc.WDP\shell\open\DropTarget"
            Name  = "CLSID"
            Value = "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
            Type  = "String"
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
