<#
 * ############################################################################
 * Filename: \PowerShell Scripts\Exchange Online\Invoke-GenerateExchangeUserPermsReport.ps1
 * Repository: Public
 * Created Date: Wednesday, February 1st 2023, 3:35:18 PM
 * Last Modified: Thursday, February 2nd 2023, 4:19:09 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

[CmdletBinding()]
param (
    [Parameter(HelpMessage = "The Identity parameter identifies the recipient that you want to view permissions for.")][string]$Identity,
    [Parameter(HelpMessage = "The Trustee parameter filters the results by who has permissions on the specified recipient.")][string]$Trustee,
    [Parameter(HelpMessage = "Full path to save report to")][string]$OutputPath,
    [Parameter()][switch]$Append = $false
)
$ProgressPreference = "Continue"

$Mailboxes = @()
$Results = @()

try {
    Connect-ExchangeOnline
}
catch {
    Write-Warning "Unable to connect to Exchange Online..."
    Write-Warning $Error[0]
    Exit 1
}

# Get mailboxes from Exchange
try {
    if ($Identity -and -not $Trustee) {
        Write-Host "Please wait, retrieving mailboxes from server..."
        $Mailboxes += Get-Mailbox -ResultSize Unlimited -Identity $Identity
    }
    elseif ($Trustee -and -not $Identity) {
        Write-Host "Please wait, retrieving mailboxes from server..."
        $Mailboxes = Get-Mailbox -ResultSize Unlimited
        $TrusteeDisplayName = (Get-Mailbox -Identity $Trustee).DisplayName
    }
    elseif ($Identity -and $Trustee) {
        Write-Host "Please wait, retrieving mailboxes from server..."
        $Mailboxes += Get-Mailbox -ResultSize Unlimited -Identity $Identity
        $TrusteeDisplayName = (Get-Mailbox -Identity $Trustee).DisplayName
    }
    else {
        Write-Error "-Identity or -Trustee parameter not specified, one or both of these parameters must be specified."
        Exit 1
    }
    Write-Host "Found $($Mailboxes.Count) mailboxes" -ForegroundColor Green
}
catch {
    Write-Warning "Unable to get mailboxes from Exchange..."
    Write-Warning $Error[0]
    Exit 1
}


Write-Host "Checking Mailbox Permissions"
$i = 0
foreach ($item in $Mailboxes) {
    # Generate progress bar
    $i++
    $PercentComplete = ($i / $Mailboxes.count) * 100
    Write-Progress -Id 0 -Activity "Checking Mailbox Permissions" -Status "$([math]::Round($PercentComplete))% Complete" -PercentComplete $PercentComplete -CurrentOperation "Checking Mailbox: $($item.UserPrincipalName)"
    try {
        if ($Identity -and -not $Trustee) {
            $rp = Get-RecipientPermission -Identity $item.ExchangeGUID
            $mp = Get-MailboxPermission -Identity $item.ExchangeGUID
        }
        elseif (($Trustee -and -not $Identity) -or ($Identity -and $Trustee)) {
            $rp = Get-RecipientPermission -Identity $item.ExchangeGUID -Trustee $Trustee
            $mp = Get-MailboxPermission -Identity $item.ExchangeGUID -User $Trustee
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


    if ($rp -ne $null) {
        $Results += [PSCustomObject]@{
            Identity     = $item.UserPrincipalName
            Trustee      = $rp.Trustee
            AccessRights = $rp.AccessRights
        }
    }
    if ($mp -ne $null) {
        $Results += [PSCustomObject]@{
            Identity     = $item.UserPrincipalName
            Trustee      = $mp.User
            AccessRights = $mp.AccessRights
        }
    }
    if ( $Trustee -and ($TrusteeDisplayName -in $item.GrantSendOnBehalfTo)) {
        $Results += [PSCustomObject]@{
            Identity     = $item.UserPrincipalName
            Trustee      = $item.GrantSendOnBehalfTo
            AccessRights = "SendOnBehalf"
        }
    }
    elseif (!($Trustee) -and $item.GrantSendOnBehalfTo) {
        $Results += [PSCustomObject]@{
            Identity     = $item.UserPrincipalName
            Trustee      = $item.GrantSendOnBehalfTo
            AccessRights = "SendOnBehalf"
        }
    }
}
Write-Host "Completed Permissions Check" -ForegroundColor Green

#Export the Data to CSV file
if ($OutputPath) {
    if ( Test-Path $OutputPath ) {
        $OutputPath = "$OutputPath\ExchangeMailboxPermissions.csv"
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
