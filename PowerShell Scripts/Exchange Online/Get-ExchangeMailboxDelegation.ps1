<#
 * ############################################################################
 * Filename: \PowerShell Scripts\Exchange Online\Get-ExchangeMailboxDelegation.ps1
 * Repository: Public
 * Created Date: Monday, March 13th 2023, 5:24:01 PM
 * Last Modified: Wednesday, April 12th 2023, 9:01:42 AM
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
.EXAMPLE
    & .\Get-ExchangeMailboxDelegation.ps1 -Identity "testuser1@example.com" -RevokeTrusteeAccess

    Revokes all permissions for any mailbox with access to the mailbox specified using the identity parameter
.EXAMPLE
    & .\Get-ExchangeMailboxDelegation.ps1 -Identity "testuser1@example.com" -Trustee "testuser2@example.com" -RevokeTrusteeAccess

    Revokes all permissions for the mailbox identified by the Trustee parameter found on the mailbox specified using the identity parameter
.EXAMPLE
    & .\Get-ExchangeMailboxDelegation.ps1 -Trustee "testuser1@example.com" -RevokeTrusteeAccess

    Revokes all permissions for the mailbox identified by the Trustee parameter globally across all mailboxes
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
    $Append = $false,
    [Parameter()]
    [switch]
    # Revokes all access for the Trustee
    $RevokeTrusteeAccess = $false,
    [Parameter()]
    [switch]
    # Stops the script auto connecting to Exchange Online
    $DisableExchangeAutoConnect = $false
)

begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    $Mailboxes = @()
    $Results = @()
    $DistGroups = @()
    $PSModules = @("ExchangeOnlineManagement")

    Write-Host "Checking if required modules are installed..."
    if ((Get-PackageProvider -Name NuGet)) {
        Write-Host "[INSTALLED] - NuGet" -ForegroundColor Green
    }
    else {
        Write-Host "[ MISSING ] - NuGet" -ForegroundColor Red
        Write-Host "[INSTALLING] - NuGet" -ForegroundColor Yellow
        Install-PackageProvider -Name NuGet -Scope CurrentUser -Confirm:$false -Force -ForceBootstrap
        if ((Get-PackageProvider -Name NuGet)) {
            Write-Host "[INSTALLED] - NuGet" -ForegroundColor Green
        }
        else {
            Write-Host "[ FAILED ] - NuGet" -ForegroundColor Red
        }
    }
    foreach ($item in $PSModules) {
        $Installed = Get-InstalledModule -Name $item -ErrorAction SilentlyContinue
        if ($Installed) {
            Write-Host "[INSTALLED] - $item" -ForegroundColor Green
        }
        else {
            Write-Host "[ MISSING ] - $item" -ForegroundColor Red
            Write-Host "[INSTALLING] - $item" -ForegroundColor Yellow
            Install-Module -Name $item -Scope CurrentUser -Force -Confirm:$false -AllowClobber
            if ((Get-InstalledModule -Name $item -ErrorAction SilentlyContinue)) {
                Write-Host "[INSTALLED] - $item" -ForegroundColor Green
            }
            else {
                Write-Host "[ FAILED ] - $item" -ForegroundColor Red
                Write-Host "Please install the '$item' module using the command below."
                Write-Host "Install-Module -Name $item -Scope CurrentUser -Force -Confirm:`$false -AllowClobber"
            }
        }
    }

    # Get mailboxes from Exchange
    try {
        if ($DisableExchangeAutoConnect -eq $false) {
            Write-Host "Attempting to connect to Exchange Online."
            Connect-ExchangeOnline
        }
        Write-Host "Please wait, retrieving mailboxes from server..."
        if (($Identity -and -not $Trustee) -or ($Identity -and $Trustee)) {
            if (-not ($Mailboxes += Get-Mailbox -ResultSize Unlimited -Identity $Identity -ErrorAction SilentlyContinue)) {
                Write-Host "Unable to find $Identity, searching Distribution & Mail-Enabled Security groups..." -ForegroundColor Yellow
                if (-not ($DistGroups += Get-DistributionGroup -Identity $Identity)) {
                    Write-Warning "Unable to find $Identity in Exchange..."
                    Exit 1
                }
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
            if (-not ($TrusteeObj = Get-Mailbox -Identity $Trustee)) {
                Write-Error "Trustee should not be a Distribution / Mail-Enabled Security group"
                Exit 1
            }
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
            Write-Verbose "[ Checking ] $($item.UserPrincipalName)"
            try {
                if ($Identity -and -not $Trustee) {
                    $rp = Get-RecipientPermission -Identity $item.GUID
                    $mp = Get-MailboxPermission -Identity $item.GUID
                }
                elseif (($Trustee -and -not $Identity) -or ($Identity -and $Trustee)) {
                    $rp = Get-RecipientPermission -Identity $item.GUID -Trustee $TrusteeObj.GUID
                    $mp = Get-MailboxPermission -Identity $item.GUID -User $TrusteeObj.GUID
                }
                else {
                    Write-Error "-Identity or -Trustee parameter not specified, one or both of these parameters must be specified."
                    Exit 1
                }
            }
            catch {
                Write-Warning "Failed checking '$($item.UserPrincipalName)' permissions"
                Write-Warning $Error[0]
            }
            if ($null -ne $rp) {
                foreach ($rpItem in $rp) {
                    $tguid = $null
                    if (-not ($rpItem.Trustee -eq "NT AUTHORITY\SELF")) { $tguid = (Get-Mailbox -Identity $rpItem.Trustee -ErrorAction SilentlyContinue ).GUID }
                    $Results += [PSCustomObject]@{
                        GUID         = $item.GUID
                        Identity     = $item.UserPrincipalName
                        Trustee      = $rpItem.Trustee
                        TrusteeGUID  = $tguid
                        AccessRights = $rpItem.AccessRights
                    }
                }

            }
            if ($null -ne $mp) {
                foreach ($mpItem in $mp) {
                    $tguid = $null
                    if (-not ($mpItem.User -eq "NT AUTHORITY\SELF")) { $tguid = (Get-Mailbox -Identity $mpItem.User -ErrorAction SilentlyContinue ).GUID }
                    $Results += [PSCustomObject]@{
                        GUID         = $item.GUID
                        Identity     = $item.UserPrincipalName
                        Trustee      = $mpItem.User
                        TrusteeGUID  = $tguid
                        AccessRights = $mpItem.AccessRights
                    }
                }

            }
            if ( $Trustee -and ((($TrusteeObj.DisplayName) -in $item.GrantSendOnBehalfTo)) -or (($TrusteeObj.ExternalDirectoryObjectID ) -in $item.GrantSendOnBehalfTo)) {
                $Results += [PSCustomObject]@{
                    GUID         = $item.GUID
                    Identity     = $item.UserPrincipalName
                    Trustee      = $TrusteeObj.UserPrincipalName
                    TrusteeGUID  = $TrusteeObj.GUID
                    AccessRights = "SendOnBehalf"
                }
            }
            elseif (!($Trustee) -and $item.GrantSendOnBehalfTo) {
                foreach ($sobItem in ($item.GrantSendOnBehalfTo).Split(",")) {
                    if ( $TrusteeObj = Get-Mailbox -Identity $sobItem) {
                        $Results += [PSCustomObject]@{
                            GUID         = $item.GUID
                            Identity     = $item.UserPrincipalName
                            Trustee      = $TrusteeObj.UserPrincipalName
                            TrusteeGUID  = $TrusteeObj.GUID
                            AccessRights = "SendOnBehalf"
                        }
                    }
                    else {
                        $Results += [PSCustomObject]@{
                            GUID         = $item.GUID
                            Identity     = $item.UserPrincipalName
                            Trustee      = $sobItem
                            TrusteeGUID  = $null
                            AccessRights = "SendOnBehalf"
                        }
                    }
                }
            }
        }
        Write-Host "Completed Mailbox Permissions Check" -ForegroundColor Green
    }
    if ($DistGroups.Count -gt 0) {
        Write-Host "Checking Distribution / Mail-Enabled Security Group Membership"
        $i = 0
        foreach ($item in $DistGroups) {
            # Generate progress bar
            $i++
            $PercentComplete = ($i / $DistGroups.count) * 100
            Write-Progress -Id 0 -Activity "Checking Distribution / Mail-Enabled Security Group Membership" -Status "$([math]::Round($PercentComplete))% Complete" -PercentComplete $PercentComplete -CurrentOperation "Checking Distribution / Mail-Enabled Security Group: $($item.PrimarySmtpAddress)"
            Write-Verbose "[ Checking ] $($item.DisplayName) ($($item.PrimarySmtpAddress))"
            $Members = Get-DistributionGroupMember -Identity $item.GUID -IncludeSoftDeletedObjects -ResultSize Unlimited
            if ($Trustee) {
                foreach ($m in $Members) {
                    if ($m.PrimarySmtpAddress -contains $TrusteeObj.UserPrincipalName) {
                        $Results += [PSCustomObject]@{
                            GUID         = $item.GUID
                            Identity     = $item.PrimarySmtpAddress
                            Trustee      = $m.PrimarySmtpAddress
                            TrusteeGUID  = $m.GUID
                            AccessRights = "Member"
                        }
                    }
                }
            }
            else {
                foreach ($m in $Members) {
                    $Results += [PSCustomObject]@{
                        GUID         = $item.GUID
                        Identity     = $item.PrimarySmtpAddress
                        Trustee      = $m.PrimarySmtpAddress
                        TrusteeGUID  = $m.GUID
                        AccessRights = "Member"
                    }
                }
            }
        }
        Write-Host "Completed Distribution / Mail-Enabled Security Group Membership Check" -ForegroundColor Green
    }
    if ($RevokeTrusteeAccess -eq $true) {
        Write-Host "Removing Mailbox Permissions & Group Membership"
        $i = 0
        foreach ($item in $Results) {
            # Generate progress bar
            $i++
            $PercentComplete = ($i / $Results.count) * 100
            Write-Progress -Id 0 -Activity "Removing Mailbox Permissions & Group Membership" -Status "$([math]::Round($PercentComplete))% Complete" -PercentComplete $PercentComplete -CurrentOperation "Removing Trustee Permission '$($item.AccessRights)' for '$($item.Trustee)' from '$($item.Identity)'"
            if (-not ($null -eq $item.TrusteeGUID)) {
                switch -Wildcard ($item.AccessRights) {
                    "*SendOnBehalf*" {
                        try {
                            Set-Mailbox -Identity $item.GUID -GrantSendOnBehalfTo @{remove = "$($item.TrusteeGUID)" } -Confirm:$false -ErrorAction Stop
                            Add-Member -InputObject $item -NotePropertyName PermissionsRevoked -NotePropertyValue $true
                        }
                        catch {
                            Add-Member -InputObject $item -NotePropertyName PermissionsRevoked -NotePropertyValue "FAILED"
                            Write-Warning "Unable to remove permission '$($item.AccessRights)' for '$($item.Trustee)' from '$($item.Identity)'"
                            Write-Warning "This may need to be done manually from the on-premise Active Directory server or Exchange Online admin center"
                        }
                    }
                    "*SendAs*" {
                        try {
                            Remove-RecipientPermission  -Identity $item.GUID -Trustee $item.TrusteeGUID -AccessRights SendAs -Confirm:$false -ErrorAction Stop
                            Add-Member -InputObject $item -NotePropertyName PermissionsRevoked -NotePropertyValue $true
                        }
                        catch {
                            Add-Member -InputObject $item -NotePropertyName PermissionsRevoked -NotePropertyValue "FAILED"
                            Write-Warning "Unable to remove permission '$($item.AccessRights)' for '$($item.Trustee)' from '$($item.Identity)'"
                            Write-Warning "This may need to be done manually from the on-premise Active Directory server or Exchange Online admin center"
                        }
                        break
                    }
                    "*Member*" {
                        try {
                            Remove-DistributionGroupMember -Identity $item.GUID -Member $item.TrusteeGUID -BypassSecurityGroupManagerCheck -Confirm:$false -ErrorAction Stop
                            Add-Member -InputObject $item -NotePropertyName PermissionsRevoked -NotePropertyValue $true
                        }
                        catch {
                            Add-Member -InputObject $item -NotePropertyName PermissionsRevoked -NotePropertyValue "FAILED"
                            Write-Warning "Unable to remove membership for '$($item.Trustee)' from '$($item.Identity)'"
                            Write-Warning "This may need to be done manually from the on-premise Active Directory server or Exchange Online admin center"
                        }
                        break
                    }
                    "*FullAccess*" {
                        try {
                            Remove-MailboxPermission -Identity $item.GUID -User $item.TrusteeGUID -AccessRights FullAccess, SendAs, ExternalAccount, DeleteItem, ReadPermission, ChangePermission, ChangeOwner -InheritanceType All -Confirm:$false -ErrorAction Stop
                            Add-Member -InputObject $item -NotePropertyName PermissionsRevoked -NotePropertyValue $true
                        }
                        catch {
                            Add-Member -InputObject $item -NotePropertyName PermissionsRevoked -NotePropertyValue "FAILED"
                            Write-Warning "Unable to remove permission '$($item.AccessRights)' for '$($item.Trustee)' from '$($item.Identity)'"
                            Write-Warning "This may need to be done manually from the on-premise Active Directory server or Exchange Online admin center"
                        }
                        break
                    }
                }
            }
            else {
                Add-Member -InputObject $item -NotePropertyName PermissionsRevoked -NotePropertyValue $false
            }
        }
    }

}

end {
    if ($DisableExchangeAutoConnect -eq $false) {
        Disconnect-ExchangeOnline -Confirm:$false
    }
    #Export the Data to CSV file
    if ($OutputPath) {
        if ( Test-Path $OutputPath ) {
            $OutputPath = "$OutputPath\ExchangeMailboxDelegation.csv"
            try {
                Write-Host -f Green "Exporting results to '$OutputPath'"
                if ($Append.IsPresent) {
                    $Results | Export-Csv -Path $OutputPath -NoTypeInformation -Append
                }
                else {
                    $Results | Export-Csv -Path $OutputPath -NoTypeInformation
                }
            }
            catch {
                Write-Warning "Failed to export results to '$OutputPath'"
                Write-Verbose $Error[0]
                Write-Warning "Outputting to console..."
                Write-Output $Results
            }
        }
        else {
            Write-Warning "'$OutputPath' Does not exist, outputting to console"
            Write-Output $Results
        }
    }
    else {
        Write-Output $Results
    }

}
