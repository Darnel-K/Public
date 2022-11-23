<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Get-AzureAdGuestInfo.ps1
 * Repository: Public
 * Created Date: Friday, November 11th 2022, 12:45:10 PM
 * Last Modified: Wednesday, November 23rd 2022, 10:10:52 AM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>
param (
    [Parameter()]
    [string]$OutFile
)
function Get-ModuleInstallStatus {
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )
    $Module = Get-Module -Name $Name -ListAvailable -ErrorAction SilentlyContinue
    if ($Module.count -eq 0) {
        return $false
    }
    else {
        return $true
    }
}

if (Get-ModuleInstallStatus -Name AzureAD) {
    try {
        $SessionInfo = Connect-AzureAD -ErrorAction Stop | Select-Object Account, TenantId, TenantDomain
    }
    catch {
        Write-Warning "Authentication Failed..."
        Write-Warning $Error[0]
        Exit 1
    }
}
else {
    Install-Module AzureAD -Force
    try {
        $SessionInfo = Connect-AzureAD -ErrorAction Stop | Select-Object Account, TenantId, TenantDomain
    }
    catch {
        Write-Warning "Authentication Failed..."
        Write-Warning $Error[0]
        Exit 1
    }
}

try {
    Get-AzureADUser -All $true -Filter "UserType eq 'Guest'" -OutVariable AzureADGuests | Out-Null

    [PSCustomObject]$data = foreach ($guest in $AzureADGuests) {
        Select-Object -InputObject $guest -Property ObjectId, ObjectType, AccountEnabled, DisplayName, Mail, UserPrincipalName, @{label = "CreatedDateTime"; expression = { (Get-AzureADUserExtension -ObjectId $_.ObjectId).Get_Item("createdDateTime") } }, UserType -OutVariable FilteredGuest | Out-Null
        [PSCustomObject]@{
            ObjectId          = $FilteredGuest.ObjectID;
            ObjectType        = $FilteredGuest.ObjectType;
            AccountEnabled    = $FilteredGuest.AccountEnabled;
            DisplayName       = $FilteredGuest.DisplayName;
            Mail              = $FilteredGuest.Mail;
            UserPrincipalName = $FilteredGuest.UserPrincipalName;
            CreatedDateTime   = $FilteredGuest.CreatedDateTime;
            UserType          = $FilteredGuest.UserType
        }
    }
}
catch {
    Write-Warning $Error[0]
    Exit 1
}

try {
    $ExportPath = "$env:USERPROFILE\Desktop"
    $OneDriveExportPath = "$env:OneDrive\Desktop"
    $Filename = "$($SessionInfo.TenantDomain) AzureAD Guest Info.csv"
    if (Test-Path -Path $OneDriveExportPath) {
        $data | Export-Csv -Path "$OneDriveExportPath\$Filename" -NoTypeInformation -Force
        Write-Host "Task Complete... Saved to $OneDriveExportPath\$Filename" -ForegroundColor green
    }
    elseif (Test-Path -Path $ExportPath) {
        $data | Export-Csv -Path "$ExportPath\$Filename" -NoTypeInformation -Force
        Write-Host "Task Complete... Saved to $ExportPath\$Filename" -ForegroundColor green
    }
    else {
        Write-Output $data
        Exit 1
    }
}
catch {
    Write-Warning $Error[0]
    Exit 1
}
