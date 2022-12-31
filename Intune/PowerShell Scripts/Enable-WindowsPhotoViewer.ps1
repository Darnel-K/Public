<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Enable-WindowsPhotoViewer.ps1
 * Repository: Public
 * Created Date: Friday, December 30th 2022, 5:12:06 PM
 * Last Modified: Friday, December 30th 2022, 5:30:22 PM
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
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ".dib"
        Value = "PhotoViewer.FileAssoc.BITMAP"
        Type = "String"
    }
    [PSCustomObject]@{
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ".jpg"
        Value = "PhotoViewer.FileAssoc.JPEG"
        Type = "String"
    }
    [PSCustomObject]@{
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ".jpe"
        Value = "PhotoViewer.FileAssoc.JPEG"
        Type = "String"
    }
    [PSCustomObject]@{
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ".jpeg"
        Value = "PhotoViewer.FileAssoc.JPEG"
        Type = "String"
    }
    [PSCustomObject]@{
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ".jxr"
        Value = "PhotoViewer.FileAssoc.JPEG"
        Type = "String"
    }
    [PSCustomObject]@{
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ".jfif"
        Value = "PhotoViewer.FileAssoc.JFIF"
        Type = "String"
    }
    [PSCustomObject]@{
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ".wdp"
        Value = "PhotoViewer.FileAssoc.WDP"
        Type = "String"
    }
    [PSCustomObject]@{
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ".png"
        Value = "PhotoViewer.FileAssoc.PNG"
        Type = "String"
    }
    [PSCustomObject]@{
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ".gif"
        Value = "PhotoViewer.FileAssoc.TIFF"
        Type = "String"
    }
    [PSCustomObject]@{
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ".tiff"
        Value = "PhotoViewer.FileAssoc.TIFF"
        Type = "String"
    }
    [PSCustomObject]@{
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ".tif"
        Value = "PhotoViewer.FileAssoc.TIFF"
        Type = "String"
    }
    [PSCustomObject]@{
        Path = "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations"
        Name = ""
        Value = ""
        Type = ""
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
