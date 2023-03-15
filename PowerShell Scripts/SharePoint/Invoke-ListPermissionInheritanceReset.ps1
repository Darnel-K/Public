<#
 * ############################################################################
 * Filename: \PowerShell Scripts\SharePoint\Invoke-ListPermissionInheritanceReset.ps1
 * Repository: Public
 * Created Date: Wednesday, January 25th 2023, 11:54:43 AM
 * Last Modified: Wednesday, March 15th 2023, 4:20:47 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

<#
.SYNOPSIS
    Removes unique permissions from a sharepoint list / document library
.DESCRIPTION
    This script resets permissions for all items in a sharepoint list or document library, this removes unquie permissions forcing items to inherit permissions from the site. This will unshare anything that has been shared with a specific person or been shared using a link.
.OUTPUTS
    Exports a CSV file or an object if the path is not available or not provided
.NOTES
    You will need to be a Site Admin on the site you wish to run this against
.EXAMPLE
    & .\Invoke-ListPermissionInheritanceReset.ps1 -Url "https://{CompanyName}.sharepoint.com/sites/{SiteName}" -ListName "Documents"

    Resets inheritance for items in the specified site and library
    This will not stop members from sharing items again
    Results will be exported to the console session rather than a CSV file
.EXAMPLE
    & .\Invoke-ListPermissionInheritanceReset.ps1 -Url "https://{CompanyName}.sharepoint.com/sites/{SiteName}" -ListName "Documents" -OutputPath "C:\Users\{YourUsername}\Desktop"

    Resets inheritance for items in the specified site and library
    This will not stop members from sharing items again
    Results will be exported to a CSV file rather than the console at the path 'C:\Users\{YourUsername}\Desktop\SharepointItemsUniquePermissions.csv'

    & .\Invoke-ListPermissionInheritanceReset.ps1 -Url "https://{CompanyName}.sharepoint.com/sites/{SiteName}" -ListName "Documents" -OutputPath "C:\Users\{YourUsername}\Desktop" -Append
    This will append the results to an exisiting file or create a new file if one doesn't exist
.EXAMPLE
    & .\Invoke-ListPermissionInheritanceReset.ps1 -Url "https://{CompanyName}.sharepoint.com/sites/{SiteName}" -ListName "Documents" -DisableSharingForNonOwners

    Resets inheritance for items in the specified site and library
    This will stop members from sharing items again unless they are one of the site owners
    Results will be exported to the console session rather than a CSV file
.EXAMPLE
    & .\Invoke-ListPermissionInheritanceReset.ps1 -Url "https://{CompanyName}.sharepoint.com/sites/{SiteName}" -ListName "Documents" -OutputPath "C:\Users\{YourUsername}\Desktop" -DisableSharingForNonOwners

    Resets inheritance for items in the specified site and library
    This will stop members from sharing items again unless they are one of the site owners
    Results will be exported to a CSV file rather than the console at the path 'C:\Users\{YourUsername}\Desktop\SharepointItemsUniquePermissions.csv'
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true,
        Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    # Full URL to SharePoint site root. e.g. https://{CompanyName}.sharepoint.com/sites/{SiteName}
    $Url,
    [Parameter(Mandatory = $true,
        Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]
    # Name of the List or Document library
    $ListName,
    [Parameter(Position = 2)]
    [ValidateNotNullOrEmpty()]
    [string]
    # Full folder path to export results. Without File Name. E.g. C:\Users\{YourUsername}\Desktop
    $OutputPath,
    [Parameter()]
    [switch]
    # Appends results to exported file if -OutputPath is specified
    $Append = $false,
    [Parameter()]
    [switch]
    # Disables members from being able to share items in the List / Document library if specified
    $DisableSharingForNonOwners = $false
)
begin {
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
    try {
        $items = Get-PnPListItem -List $ListName -PageSize 5000
    }
    catch {
        Write-Warning "Unable to get items from '$ListName'..."
        Write-Warning $Error[0]
        Exit 1
    }
    Write-Host "Found $($items.Count) Item(s)"

}

process {
    # Disable Sharing For Non Owners
    if ($DisableSharingForNonOwners) {
        try {
            Write-Host "Disabling Sharing For Non Owners" -ForegroundColor Yellow
            Set-PnPSite -Identity $Url -DisableSharingForNonOwners
            Write-Host "Disabled Sharing For Non Owners" -ForegroundColor Green
        }
        catch {
            Write-Warning "Unable to disable Sharing For Non Owners. Disable manually from the WebUI."
        }
    }
    # Reset library permissions
    try {
        Write-Host "Enabling inheritance for '$ListName'" -ForegroundColor Yellow
        Set-PnPList -Identity $ListName -ResetRoleInheritance | Out-Null
        Write-Host "Enabled inheritance for '$ListName'" -ForegroundColor Green
    }
    catch {
        Write-Warning "Unable to enable inheritance for '$ListName'. Enable manually from the WebUI."
    }

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
            # Update progress bar
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
}

end {
    # Disconnect PnP session
    Disconnect-PnPOnline
    # Export the Data to CSV file
    if ($OutputPath) {
        if ( Test-Path $OutputPath ) {
            $OutputPath = "$OutputPath\SharepointItemsUniquePermissions.csv"
            try {
                Write-Host -f Green "Exporting results to '$OutputPath'"
                if ($Append.IsPresent) {
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
}
