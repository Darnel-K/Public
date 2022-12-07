<#
 * ############################################################################
 * Filename: \PowerShell Scripts\Get-SharePointExternalUsers.ps1
 * Repository: Public
 * Created Date: Wednesday, December 7th 2022, 1:23:56 PM
 * Last Modified: Wednesday, December 7th 2022, 5:20:47 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true,
        HelpMessage = "File path to store results e.g. 'C:\Users\xxxxx\Desktop'")]
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
Connect-SPOService -URL $AdminSiteURL

#Get all Site Collections
$SitesCollection = Get-SPOSite -Limit ALL

$ExternalUsers = @()
#Iterate through each site collection
ForEach ($Site in $SitesCollection) {
    Write-host -f Yellow "Checking Site Collection:"$Site.URL
    Set-SPOUser -Site $Site.URL -LoginName $LoginName -IsSiteCollectionAdmin $true
    #Get All External users of the site collection
    $ExtUsers = Get-SPOUser -Limit All -Site $Site.URL | Where-Object { $_.LoginName -like "*#ext#*" -or $_.LoginName -like "*urn:spo:guest*" } | Select-Object *, @{label = "SiteUrl"; expression = { $Site.URL } }
    If ($ExtUsers.count -gt 0) {
        Write-host -f Green "Found $($ExtUsers.count) External User(s)!"
        $ExternalUsers += $ExtUsers
    }
    Set-SPOUser -Site $Site.URL -LoginName $LoginName -IsSiteCollectionAdmin $false
}



#Export the Data to CSV file
$ExternalUsers | Export-Csv -Path $OutputPath -NoTypeInformation
