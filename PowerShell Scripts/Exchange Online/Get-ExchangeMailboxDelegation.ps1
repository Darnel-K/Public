<#
 * ############################################################################
 * Filename: \PowerShell Scripts\Exchange Online\Get-ExchangeMailboxDelegation.ps1
 * Repository: Public
 * Created Date: Monday, March 13th 2023, 5:24:01 PM
 * Last Modified: Wednesday, March 22nd 2023, 1:58:52 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

<#
.SYNOPSIS
    Gets permissions for exchange mailboxes
.DESCRIPTION
    This script will get the permissions for the specified mailbox or the mailboxes a user has access to across Exchange Online
.PARAMETER Identity
    The Identity parameter specifies the mailbox you want to view. You can use any value that uniquely identifies the mailbox. For example:

     - Name
     - Alias
     - Distinguished name (DN)
     - Canonical DN
     - Email Address
     - GUID
     - User ID or user principal name (UPN)
.PARAMETER Trustee
    The Trustee parameter filters the results by who has permissions to the mailbox that's specified by the Identity parameter. If the Identity parameter is not specified, permissions given to the Trustee are checked against all mailboxes.
    You can use any value that uniquely identifies the mailbox. For example:

     - Name
     - Alias
     - Distinguished name (DN)
     - Canonical DN
     - Domain\Username
     - Email Address
     - GUID
     - LegacyExchangeDN
     - SamAccountName
     - User ID or user principal name (UPN)
.OUTPUTS
    Exports a CSV file or an object if the path is not available or not provided
.NOTES
    Does not support mail-enabled security groups or distribution groups
.EXAMPLE
    & .\Get-ExchangeMailboxDelegation.ps1 -Identity "testuser1@example.com"

    Checks permissions for the mailbox specified by the Identity parameter and outputs a list of users / mailboxes with access to this mailbox.
.EXAMPLE
    & .\Get-ExchangeMailboxDelegation.ps1 -Identity "testuser1@example.com" -Trustee "testuser2@example.com"

    Checks what permissions Trustee has been granted for the mailbox specified by the Identity parameter.
.EXAMPLE
    & .\Get-ExchangeMailboxDelegation.ps1 -Trustee "testuser1@example.com"

    Checks what permissions Trustee has been granted against all mailboxes in the tenant.
#>

[CmdletBinding()]
Param (
    [Parameter()]
    [string]
    $Identity,
    [Parameter()]
    [string]
    $Trustee,
    [Parameter()]
    [string]
    # Full folder path to export results. Without File Name. E.g. C:\Users\{YourUsername}\Desktop
    $OutputPath,
    [Parameter()]
    [switch]
    # Appends results to exported file if -OutputPath is specified
    $Append = $false
)

begin {
    $ProgressPreference = "Continue"
    $Mailboxes = @()
    $Results = @()
    $DistGroups = @()
    $isIdGroup = $false

    # Get mailboxes from Exchange
    try {
        Connect-ExchangeOnline
        Write-Host "Please wait, retrieving mailboxes from server..."
        if (($Identity -and -not $Trustee) -or ($Identity -and $Trustee)) {
            if (-not ($Mailboxes += Get-Mailbox -ResultSize Unlimited -Identity $Identity)) {
                Write-Host "Unable to find $Identity, searching Distribution & Mail-Enabled Security groups..." -ForegroundColor Yellow
                $isIdGroup = $true
                if (-not ($DistGroups += Get-DistributionGroup -Identity $Identity)) {
                    Write-Warning "Unable to find $Identity in Exchange..."
                    Exit 1
                }
            }
            else {
                # $DistGroups = Get-DistributionGroup | Where-Object { (Get-DistributionGroupMember $_.Name | ForEach-Object { $_.ExchangeObjectId }) -contains $Mailboxes[0].ExchangeObjectId }
            }
        }
        elseif ($Trustee -and -not $Identity) {
            $Mailboxes = Get-Mailbox -ResultSize Unlimited
            $DistGroups = Get-DistributionGroup -ResultSize Unlimited
        }
        else {
            Write-Error "-Identity or -Trustee parameter not specified, one or both of these parameters must be specified."
            Exit 1
        }
        if ($Trustee) {
            $t = Get-Mailbox -Identity $Trustee
            $TrusteeDisplayName = $t.DisplayName
            # if ($Trustee -and $Identity) {
            #     if ($isIdGroup) {
            #         $DistGroups += Get-DistributionGroup -Identity $Identity | Where-Object { (Get-DistributionGroupMember $_.Name | ForEach-Object { $_.ExchangeObjectId }) -contains "$($t.ExchangeObjectId)" }
            #     }
            # }
            # else {
            #     $DistGroups = Get-DistributionGroup | Where-Object { (Get-DistributionGroupMember $_.Name | ForEach-Object { $_.ExchangeObjectId }) -contains "$($t.ExchangeObjectId)" }
            # }
        }
        Write-Host "Found $($Mailboxes.Count) mailboxes" -ForegroundColor Green
        Write-Host "Found $($DistGroups.Count) Distribution / Mail-Enabled Security groups" -ForegroundColor Green
    }
    catch {
        Write-Warning "Unable to get mailboxes from Exchange..."
        Write-Warning $Error[0]
        Exit 1
    }
}

process {
    if ($Mailboxes.Count -gt 0) {
        Write-Host "Checking Mailbox Permissions"
        $i = 0
        foreach ($item in $Mailboxes) {
            # Generate progress bar
            $i++
            $PercentComplete = ($i / $Mailboxes.count) * 100
            Write-Progress -Id 0 -Activity "Checking Mailbox Permissions" -Status "$([math]::Round($PercentComplete))% Complete" -PercentComplete $PercentComplete -CurrentOperation "Checking Mailbox: $($item.UserPrincipalName)"
        }
        # foreach ($item in $Mailboxes) {
        #     # Generate progress bar
        #     $i++
        #     $PercentComplete = ($i / $Mailboxes.count) * 100
        #     Write-Progress -Id 0 -Activity "Checking Mailbox Permissions" -Status "$([math]::Round($PercentComplete))% Complete" -PercentComplete $PercentComplete -CurrentOperation "Checking Mailbox: $($item.UserPrincipalName)"
        #     try {
        #         if ($Identity -and -not $Trustee) {
        #             $rp = Get-RecipientPermission -Identity $item.ExchangeGUID
        #             $mp = Get-MailboxPermission -Identity $item.ExchangeGUID
        #         }
        #         elseif (($Trustee -and -not $Identity) -or ($Identity -and $Trustee)) {
        #             $rp = Get-RecipientPermission -Identity $item.ExchangeGUID -Trustee $Trustee
        #             $mp = Get-MailboxPermission -Identity $item.ExchangeGUID -User $Trustee
        #         }
        #         else {
        #             Write-Error "-Identity or -Trustee parameter not specified, one or both of these parameters must be specified."
        #             Exit 1
        #         }
        #     }
        #     catch {
        #         Write-Warning "Failed checking '$($item.UserPrincipalName)' permissions"
        #         Write-Warning $Error[0]
        #     }
        #     if ($null -ne $rp) {
        #         $Results += [PSCustomObject]@{
        #             Identity     = $item.UserPrincipalName
        #             Trustee      = $rp.Trustee
        #             AccessRights = $rp.AccessRights
        #         }
        #     }
        #     if ($null -ne $mp) {
        #         $Results += [PSCustomObject]@{
        #             Identity     = $item.UserPrincipalName
        #             Trustee      = $mp.User
        #             AccessRights = $mp.AccessRights
        #         }
        #     }
        #     if ( $Trustee -and ($TrusteeDisplayName -in $item.GrantSendOnBehalfTo)) {
        #         $Results += [PSCustomObject]@{
        #             Identity     = $item.UserPrincipalName
        #             Trustee      = $item.GrantSendOnBehalfTo
        #             AccessRights = "SendOnBehalf"
        #         }
        #     }
        #     elseif (!($Trustee) -and $item.GrantSendOnBehalfTo) {
        #         $Results += [PSCustomObject]@{
        #             Identity     = $item.UserPrincipalName
        #             Trustee      = $item.GrantSendOnBehalfTo
        #             AccessRights = "SendOnBehalf"
        #         }
        #     }
        # }
        # Write-Host "Completed Permissions Check" -ForegroundColor Green
    }
    if ($DistGroups.Count -gt 0) {
        Write-Host $DistGroups.Count
    }

}

end {
    Disconnect-ExchangeOnline -Confirm:$false
    # #Export the Data to CSV file
    # if ($OutputPath) {
    #     if ( Test-Path $OutputPath ) {
    #         $OutputPath = "$OutputPath\ExchangeMailboxPermissions.csv"
    #         try {
    #             Write-Host -f Green "Exporting results to '$OutputPath'"
    #             if ($Append.IsPresent) {
    #                 $Results | Export-Csv -Path $OutputPath -NoTypeInformation -Append
    #             }
    #             else {
    #                 $Results | Export-Csv -Path $OutputPath -NoTypeInformation
    #             }
    #         }
    #         catch {
    #             Write-Warning "Failed to export results to '$OutputPath'"
    #             Write-Verbose $Error[0]
    #             Write-Warning "Outputting to console..."
    #             Write-Output $Results
    #         }
    #     }
    #     else {
    #         Write-Warning "'$OutputPath' Does not exist, outputting to console"
    #         Write-Output $Results
    #     }
    # }
    # else {
    #     Write-Output $Results
    # }

}
