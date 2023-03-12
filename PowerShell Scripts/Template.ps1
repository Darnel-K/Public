<#
 * ############################################################################
 * Filename: \PowerShell Scripts\Template.ps1
 * Repository: Public
 * Created Date: Sunday, March 12th 2023, 2:18:06 PM
 * Last Modified: Sunday, March 12th 2023, 3:15:45 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>
<#
.SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
# [CmdletBinding()]
# Param (
#     # Param1 help description
#     [Parameter(ValueFromPipeline = $true)]
#     [string]
#     $Var1
# )
begin {
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = "";
    if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not ([System.Diagnostics.EventLog]::SourceExists($LogSource))) {
        New-EventLog -LogName $LogName -Source $LogSource
        Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Initialised Event Log: $LogSource" -EventId 0
    }
    # Add any code here that needs be done once during the initialisation phase
    # e.g. database connections, variable declarations, Event Log checks
}

process {
    # Add code here to perform any tasks / data processing or anything else that's needed
    # If an array is piped to the script this block will run for each item in the array
    # If an array is passed to the script using a parameter this block will run once and you'll need a ForEach statement
}

end {
    # Add code here that should be run once the process block is complete.
    # E.g. closing database connections, outputing results
}
