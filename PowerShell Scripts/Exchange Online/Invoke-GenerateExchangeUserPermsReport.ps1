<#
 * ############################################################################
 * Filename: \PowerShell Scripts\Exchange Online\Invoke-GenerateExchangeUserPermsReport.ps1
 * Repository: Public
 * Created Date: Wednesday, February 1st 2023, 3:35:18 PM
 * Last Modified: Wednesday, February 1st 2023, 5:11:24 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

[CmdletBinding()]
param (
    [Parameter(HelpMessage = "The Identity parameter identifies the recipient that you want to view permissions for.")][string]$Identity,
    [Parameter(HelpMessage = "User principal name of the mailbox to check access rights for")][string]$Trustee,
    [Parameter(HelpMessage = "Full path to save report to")][string]$OutputPath = [Environment]::GetFolderPath("MyDocuments")
)

$Username = ""
# $Mailboxes = @()
# $Mailboxes += Get-Mailbox -ResultSize Unlimited -Identity ""
$Mailboxes = Get-Mailbox -ResultSize Unlimited
$Results = @()

$i = 0
foreach ($item in $Mailboxes) {
    # Generate progress bar
    $i++
    $PercentComplete = ($i / $Mailboxes.count) * 100
    Write-Progress -Id 0 -Activity "Checking Mailbox Permissions" -Status "$([math]::Round($PercentComplete))% Complete" -PercentComplete $PercentComplete -CurrentOperation "Checking Mailbox: $($item.UserPrincipalName)"
    $val = Get-RecipientPermission -Identity $item.ExchangeGUID -Trustee $Username
    if ($val -ne $null) {
        $Results += [PSCustomObject]@{
            Identity     = $item.UserPrincipalName
            Trustee      = $val.Trustee
            AccessRights = $val.AccessRights
        }
    }
    $val = Get-MailboxPermission -Identity $item.ExchangeGUID -User $Username
    if ($val -ne $null) {
        $Results += [PSCustomObject]@{
            Identity     = $item.UserPrincipalName
            Trustee      = $val.User
            AccessRights = $val.AccessRights
        }
    }
    if ($item.GrantSendOnBehalfTo) {
        $Results += [PSCustomObject]@{
            Identity     = $item.UserPrincipalName
            Trustee      = $item.GrantSendOnBehalfTo
            AccessRights = "SendOnBehalf"
        }
    }
}

Write-Output $Results
