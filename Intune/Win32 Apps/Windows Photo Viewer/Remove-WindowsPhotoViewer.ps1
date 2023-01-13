<#
 * ############################################################################
 * Filename: \Intune\Win32 Apps\Windows Photo Viewer\Remove-WindowsPhotoViewer.ps1
 * Repository: Public
 * Created Date: Friday, December 30th 2022, 5:12:06 PM
 * Last Modified: Friday, January 13th 2023, 4:09:47 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>
$ErrorActionPreference = "Stop"
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

foreach ($i in $RegData) {
    if (Test-Path -Path $i.Path) {
        if ($i.Name) {
            try {
                Remove-ItemProperty -Path $i.Path -Name $i.Name
            }
            catch {
                Write-Warning "Failed to remove registy property: $($i.Name) at path: $($i.Path)"
                Write-Verbose $Error[0]
            }
        }
        else {
            try {
                Remove-Item -Path $i.Path -Recurse -Force
            }
            catch {
                Write-Warning "Failed to remove registy path: $($i.Path)"
                Write-Verbose $Error[0]
            }
        }
    }
}
Exit 0
