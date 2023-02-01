<#
 * ############################################################################
 * Filename: \PowerShell Scripts\AzureAD\Get-LicensedADUserJobAndContactInfo.ps1
 * Repository: Public
 * Created Date: Wednesday, January 11th 2023, 12:14:46 PM
 * Last Modified: Wednesday, February 1st 2023, 8:54:04 AM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

[CmdletBinding()]
param (
    [Parameter(HelpMessage = "File path to export results e.g. 'C:\Users\xxxxx\Desktop'")]
    [string]
    $OutputPath
)

$Data = Get-ADUser -ResultSetSize $Null -Filter 'Enabled -eq $True' -Properties * | Select-Object GivenName, Surname, UserPrincipalName, Title, Company, Department, @{label = "Manager"; expression = { (Get-ADUser $_.Manager).UserPrincipalName } }, OfficePhone, HomePhone, MobilePhone, StreetAddress, POBox, City, State, PostalCode, Country, countryCode

try {
    Write-Host "Attempting to connect to Azure AD MSOL Service"
    Connect-MsolService
}
catch {
    Write-Warning "Unable to connect to MSOL Service"
    Write-Warning $Error[0]
    Exit 1
}

$Output = @()

foreach ($i in $Data) {
    try {
        if ((Get-MsolUser -UserPrincipalName $i.UserPrincipalName).isLicensed) {
            Write-Host "$($i.UserPrincipalName) is licensed."
            $Output += $i
        }
        else {
            Write-Host "$($i.UserPrincipalName) is unlicensed."
        }
    }
    catch {
        Write-Warning "$($i.DisplayName) Does not have a UPN or does not exist in AzureAD. Skipping..."
        Write-Warning $Error[0]
    }

}


#Export the Data to CSV file
if ($OutputPath) {
    if ( Test-Path $OutputPath ) {
        $OutputPath = "$OutputPath\UserJob&ContactInfo.csv"
        try {
            Write-Host -f Green "Exporting results to '$OutputPath'"
            $Output | Export-Csv -Path $OutputPath -NoTypeInformation
            Exit 0
        }
        catch {
            Write-Warning "Failed to export results to '$OutputPath'"
            Write-Verbose $Error[0]
            Write-Warning "Outputting to console..."
            Write-Output $Output
            Exit 1
        }
    }
    else {
        Write-Warning "'$OutputPath' Does not exist, outputting to console"
        Write-Output $Output
        Exit 1
    }
}
else {
    Write-Output $Output
    Exit 0
}
