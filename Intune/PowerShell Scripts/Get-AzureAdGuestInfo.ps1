<#
 * ############################################################################
 * Filename: \Intune\PowerShell Scripts\Get-AzureAdGuestInfo.ps1
 * Repository: Public
 * Created Date: Friday, November 11th 2022, 12:45:10 PM
 * Last Modified: Friday, November 11th 2022, 12:46:06 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2022 Darnel Kumar
 * ############################################################################
#>


Get-AzureADUser -All $true -Filter "UserType eq 'Guest'" | Select -Property ObjectId, ObjectType, AccountEnabled, DisplayName, Mail, UserPrincipalName, @{label = "CreatedDateTime"; expression = { (Get-AzureADUserExtension -ObjectId $_.ObjectId).Get_Item("createdDateTime") } }, UserType
