<#
 * ############################################################################
 * Filename: \PowerShell Scripts\Get-ADUserJobAndContactInfo.ps1
 * Repository: Public
 * Created Date: Wednesday, January 11th 2023, 12:14:46 PM
 * Last Modified: Wednesday, January 11th 2023, 12:25:02 PM
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


#Export the Data to CSV file
if ($OutputPath) {
    if ( Test-Path $OutputPath ) {
        $OutputPath = "$OutputPath\UserJob&ContactInfo.csv"
        try {
            Write-Host -f Green "Exporting results to '$OutputPath'"
            $Data | Export-Csv -Path $OutputPath -NoTypeInformation
            Exit 0
        }
        catch {
            Write-Warning "Failed to export results to '$OutputPath'"
            Write-Verbose $Error[0]
            Write-Warning "Outputting to console..."
            Write-Output $Data
            Exit 1
        }
    }
    else {
        Write-Warning "'$OutputPath' Does not exist, outputting to console"
        Write-Output $Data
        Exit 1
    }
}
else {
    Write-Output $Data
    Exit 0
}
