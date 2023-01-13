<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\Windows Photo Viewer\Enable-WindowsPhotoViewer.ps1
 * Repository: Public
 * Created Date: Friday, December 30th 2022, 5:12:06 PM
 * Last Modified: Friday, January 13th 2023, 3:28:00 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>
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

foreach ($i in $RegData) {
    if (!(Test-Path -Path $i.Path)) {
        try {
            New-Item -Path $i.Path -Force
        }
        catch {
            Write-Warning "Failed to create registry path: $($i.Path)"
            Write-Verbose $Error[0]
            Exit 1
        }
    }
    if ((Get-ItemProperty $i.Path).PSObject.Properties.Name -contains $i.Name) {
        try {
            Set-ItemProperty -Path $i.Path -Name $i.Name -Value $i.Value
        }
        catch {
            Write-Warning @('Failed to make the following registry edit.', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)")
            Write-Verbose $Error[0]
            Exit 1
        }
    }
    else {
        try {
            New-ItemProperty -Path $i.Path -Name $i.Name -Value $i.Value -Type $i.Type
        }
        catch {
            Write-Warning @('Failed to make the following registry edit.', "Key: $($i.Path)", "Property: $($i.Name)", "Value: $($i.Value)", "Type: $($i.Type)")
            Write-Verbose $Error[0]
            Exit 1
        }
    }
}
Exit 0
