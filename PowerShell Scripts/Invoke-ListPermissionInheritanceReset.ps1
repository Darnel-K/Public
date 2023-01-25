<#
 * ############################################################################
 * Filename: \PowerShell Scripts\Invoke-ListPermissionInheritanceReset.ps1
 * Repository: Public
 * Created Date: Wednesday, January 25th 2023, 11:54:43 AM
 * Last Modified: Wednesday, January 25th 2023, 4:07:51 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        HelpMessage = "Url to SharePoint Site")]
    [ValidateNotNullOrEmpty()]
    [string]
    $Url,
    [Parameter(Mandatory = $true,
        Position = 1,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        HelpMessage = "Name of the list or document library")]
    [ValidateNotNullOrEmpty()]
    [string]
    $ListName,
    [Parameter(Position = 2,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
        HelpMessage = "File path to export results e.g. 'C:\Users\xxxxx\Desktop'")]
    [ValidateNotNullOrEmpty()]
    [string]
    $OutputPath,
    [Parameter()]
    [switch]
    $Append = $false
)

# Import PnP Module
try {
    Import-Module PnP.PowerShell
}
catch {
    Write-Warning "Failed to import PnP Module..."
    Write-Warning $Error[0]
    Exit 1
}

# Connect to PnP Online
try {
    Connect-PnPOnline -Url $Url -Interactive
}
catch {
    Write-Warning "Unable to connect to '$Url'..."
    Write-Warning $Error[0]
    Exit 1
}

$ctx = Get-PnPContext

Write-Host "Looking for item(s)... Please wait..."
# Get all items in document library
$items = Get-PnPListItem -List $ListName -PageSize 5000
Write-Host "Found $($items.Count) Item(s)"

$i = 0
$resetItems = @()
foreach ($item in $items) {
    # Generate progress bar
    $i++
    $PercentComplete = ($i / $items.count) * 100
    Write-Progress -Id 0 -Activity "Checking Item Permissions" -Status "$([math]::Round($PercentComplete))% Complete" -PercentComplete $PercentComplete -CurrentOperation "Checking Item: $($item.FieldValues.FileRef)"

    # Check if item has unique permissions
    if ((Get-PnPProperty -ClientObject $item -Property HasUniqueRoleAssignments)) {
        Write-Host "Not OK! : '$($item.FieldValues.FileRef)' has unique permissions" -ForegroundColor Red
        # Add item to object for reporting
        $resetItems += [PSCustomObject]@{
            Id       = $item.Id
            Name     = $item.FieldValues.FileLeafRef
            FullPath = $item.FieldValues.FileRef
            UniqueId = $item.FieldValues.UniqueId
            Author   = $item.FieldValues.Author[0].Email
            Editor   = $item.FieldValues.Editor[0].Email
            Created  = $item.FieldValues.Created
            Modified = $item.FieldValues.Modified
        }
        Write-Progress -Id 0 -Activity "Resetting Item Permissions" -Status "$([math]::Round($PercentComplete))% Complete" -PercentComplete $PercentComplete -CurrentOperation "Resetting Item: $($item.FieldValues.FileRef)"
        Write-Host "Resetting! : '$($item.FieldValues.FileRef)' permissions" -ForegroundColor Yellow
        try {
            $item.ResetRoleInheritance()
            $item.update()
            $ctx.ExecuteQuery()
        }
        catch {
            Write-Host "FAILED! : '$($item.FieldValues.FileRef)'" -ForegroundColor Red
            Write-Warning "Failed to reset permissions for '$($item.FieldValues.FileRef)'"
            Write-Warning $Error[0]
        }
        Write-Host "OK : '$($item.FieldValues.FileRef)' has inherited permissions" -ForegroundColor Green
    }
    else {
        Write-Host "OK : '$($item.FieldValues.FileRef)' has inherited permissions" -ForegroundColor Green
    }

}

#Export the Data to CSV file
if ($OutputPath) {
    if ( Test-Path $OutputPath ) {
        $OutputPath = "$OutputPath\SharepointItemsUniquePermissions.csv"
        try {
            Write-Host -f Green "Exporting results to '$OutputPath'"
            if ($Append) {
                $resetItems | Export-Csv -Path $OutputPath -NoTypeInformation -Append
            }
            else {
                $resetItems | Export-Csv -Path $OutputPath -NoTypeInformation
            }
        }
        catch {
            Write-Warning "Failed to export results to '$OutputPath'"
            Write-Verbose $Error[0]
            Write-Warning "Outputting to console..."
            Write-Output $resetItems
        }
    }
    else {
        Write-Warning "'$OutputPath' Does not exist, outputting to console"
        Write-Output $resetItems
    }
}
else {
    Write-Output $resetItems
}
