<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Set-WallpaperStyle.ps1
 * Repository: Public
 * Created Date: Monday, May 15th 2023, 8:37:17 PM
 * Last Modified: Monday, May 15th 2023, 10:04:34 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

$RegKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System"

if ( !(Test-Path -Path $filename) ) {
    $bytes = [Convert]::FromBase64String($b64)
    [IO.File]::WriteAllBytes($filename, $bytes)
    if ( Test-Path -Path $filename) {
        Write-Output "File created successfully"
    }
    else {
        Write-Output "Failed to create file"
        Exit 1
    }
}
else {
    Write-Output "File already exists"
}

$RegData = @(
    [PSCustomObject]@{
        Path  = $RegKeyPath
        Name  = "WallpaperStyle"
        Value = "3"
        Type  = "STRING"
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

RUNDLL32.EXE USER32.DLL, UpdatePerUserSystemParameters 1, True
Exit 0
