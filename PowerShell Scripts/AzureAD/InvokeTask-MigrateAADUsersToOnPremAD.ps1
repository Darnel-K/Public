<#
 * ############################################################################
 * Filename: \PowerShell Scripts\AzureAD\InvokeTask-MigrateAADUsersToOnPremAD.ps1
 * Repository: Public
 * Created Date: Monday, August 14th 2023, 12:26:40 PM
 * Last Modified: Monday, August 14th 2023, 2:19:03 PM
 * Original Author: Darnel Kumar
 * Author Github: https://github.com/Darnel-K
 *
 * Copyright (c) 2023 Darnel Kumar
 * ############################################################################
#>

<#
.SYNOPSIS
    A brief description of the function or script. This keyword can be used only once in each topic.
.DESCRIPTION
    A detailed description of the function or script. This keyword can be used only once in each topic.
.PARAMETER Param1
    The description of a parameter. You can include a .PARAMETER keyword for each parameter in the function or script.

    The .PARAMETER keywords can appear in any order in the comment block, but the order in which the parameters appear in the Param statement or function declaration determines the order in which the parameters appear in Help topic. To change the order of parameters in the Help topic, change the order of the parameters in the Param statement or function declaration.

    You can also specify a parameter description by placing a comment in the Param statement immediately before the parameter variable name. If you use both a Param statement comment and a .PARAMETER keyword, the description associated with the .PARAMETER keyword is used, and the Param statement comment is ignored.
.INPUTS
    The Microsoft .NET Framework types of objects that can be piped to the function or script. You can also include a description of the input objects.
.OUTPUTS
    The .NET Framework type of the objects that the cmdlet returns. You can also include a description of the returned objects.
.NOTES
    Additional information about the function or script.
.LINK
    The name of a related topic. Repeat this keyword for each related topic. This content appears in the Related Links section of the Help topic.

    The .LINK keyword content can also include a Uniform Resource Identifier (URI) to an online version of the same Help topic. The online version opens when you use the Online parameter of Get-Help. The URI must begin with "http" or "https".
.EXAMPLE
    A sample command that uses the function or script, optionally followed by sample output and a description. Repeat this keyword for each example.
#>

begin {
    $ProgressPreference = "Continue"
    $host.ui.RawUI.WindowTitle = $MyInvocation.MyCommand.Name
    # Update LogName and LogSource
    $LogName = "ABYSS.ORG.UK"; $LogSource = ".ScheduledTask.PSScript.MigrateAADUsersToOnPremAD";
    if (-not ([System.Diagnostics.EventLog]::Exists($LogName)) -or -not ([System.Diagnostics.EventLog]::SourceExists($LogSource))) {
        try {
            New-EventLog -LogName $LogName -Source $LogSource
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Information -Message "Initialised Event Log: $LogSource" -EventId 0
        }
        catch {
            $Message = "Unable to initialise event log '$LogName' with source '$LogSource', falling back to event log 'Application' with source 'Application'"
            $LogName = "Application"; $LogSource = "Application"; # DO NOT CHANGE
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Message -EventId 0
            Write-EventLog -LogName $LogName -Source $LogSource -EntryType Warning -Message $Error[0] -EventId 0
        }
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
