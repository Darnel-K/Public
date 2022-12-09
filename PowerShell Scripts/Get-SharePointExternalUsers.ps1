<#
 * ############################################################################
 * Filename: \PowerShell Scripts\Get-SharePointExternalUsers.ps1
 * Repository: Public
 * Created Date: Wednesday, December 7th 2022, 1:23:56 PM
 * Last Modified: Friday, December 9th 2022, 2:54:21 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>

[CmdletBinding()]
param (
    [Parameter(HelpMessage = "File path to export results e.g. 'C:\Users\xxxxx\Desktop'")]
    [string]
    $OutputPath,
    [Parameter(Mandatory = $true,
        HelpMessage = "Admin SharePoint site URL e.g. https://something-admin.sharepoint.com")]
    [string]
    $AdminSiteURL,
    [Parameter(Mandatory = $true,
        HelpMessage = "Login email address of user running this script")]
    [string]
    $LoginName
)

#Import SharePoint Online Management Shell
Import-Module Microsoft.Online.Sharepoint.PowerShell -DisableNameChecking

#Connect to SharePoint Online Tenant Admin
try {
    Connect-SPOService -URL $AdminSiteURL
}
catch {
    Write-Warning "Authentication Failed..."
    Write-Warning $Error[0]
    Exit 1
}

#Get all Site Collections
$SitesCollection = Get-SPOSite -Limit ALL

$ExternalUsers = @()
#Iterate through each site collection
$i = 0
ForEach ($Site in $SitesCollection) {
    Write-host -f Yellow "Checking Site Collection:"$Site.URL
    try {
        Set-SPOUser -Site $Site.URL -LoginName $LoginName -IsSiteCollectionAdmin $true | Out-String | Write-Verbose
    }
    catch {
        Write-Warning "Error setting $LoginName as Site Admin for site: $($Site.URL)"
        Write-Verbose $Error[0]
    }
    #Get All External users of the site collection
    try {
        $ExtUsers = Get-SPOUser -Limit All -Site $Site.URL | Where-Object { $_.LoginName -like "*#ext#*" -or $_.LoginName -like "*urn:spo:guest*" } | Select-Object *, @{label = "SiteUrl"; expression = { $Site.URL } }
        If ($ExtUsers.count -gt 0) {
            Write-host -f Green "Found $($ExtUsers.count) External User(s)!"
            $ExternalUsers += $ExtUsers
        }
    }
    catch {
        Write-Warning "Unable to fetch users for site: $($Site.URL)"
        Write-Verbose $Error[0]
    }
    try {
        Set-SPOUser -Site $Site.URL -LoginName $LoginName -IsSiteCollectionAdmin $false | Out-String | Write-Verbose
    }
    catch {
        Write-Warning "Error removing $LoginName as Site Admin for site: $($Site.URL)"
        Write-Verbose $Error[0]
    }
    $i++
    $PercentComplete = ($i / $SitesCollection.count) * 100
    Write-Progress -Id 0 -Activity "Checking SharePoint Site Permissions" -Status "$([math]::Round($PercentComplete))% Complete" -PercentComplete $PercentComplete -CurrentOperation "Checking Site: $($Site.URL)"
}

#Export the Data to CSV file
if ($OutputPath) {
    if ( Test-Path $OutputPath ) {
        $OutputPath = "$OutputPath\SharePointExternalUsers.csv"
        try {
            Write-Host -f Green "Exporting results to '$OutputPath'"
            $ExternalUsers | Export-Csv -Path $OutputPath -NoTypeInformation
        }
        catch {
            Write-Warning "Failed to export results to '$OutputPath'"
            Write-Verbose $Error[0]
            Write-Warning "Outputting to console..."
            Write-Output $ExternalUsers
        }
    }
    else {
        Write-Warning "'$OutputPath' Does not exist, outputting to console"
        Write-Output $ExternalUsers
    }
}
else {
    Write-Output $ExternalUsers
}
