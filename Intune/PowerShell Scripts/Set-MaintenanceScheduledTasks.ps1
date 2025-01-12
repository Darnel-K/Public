<#
# #################################################################################################################### #
# Filename: \Intune\PowerShell Scripts\Set-MaintenanceScheduledTasks.ps1                                               #
# Repository: Public                                                                                                   #
# Created Date: Friday, December 27th 2024, 10:55:46 PM                                                                #
# Last Modified: Sunday, January 12th 2025, 10:42:55 PM                                                                #
# Original Author: Darnel Kumar                                                                                        #
# Author Github: https://github.com/Darnel-K                                                                           #
#                                                                                                                      #
# This code complies with: https://gist.github.com/Darnel-K/8badda0cabdabb15359350f7af911c90                           #
#                                                                                                                      #
# License: GNU General Public License v3.0 only - https://www.gnu.org/licenses/gpl-3.0-standalone.html                 #
# Copyright (c) 2024 - 2025 Darnel Kumar                                                                               #
#                                                                                                                      #
# This program is free software: you can redistribute it and/or modify                                                 #
# it under the terms of the GNU General Public License as published by                                                 #
# the Free Software Foundation, either version 3 of the License, or                                                    #
# (at your option) any later version.                                                                                  #
#                                                                                                                      #
# This program is distributed in the hope that it will be useful,                                                      #
# but WITHOUT ANY WARRANTY; without even the implied warranty of                                                       #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                                                        #
# GNU General Public License for more details.                                                                         #
# #################################################################################################################### #
#>

<#
.SYNOPSIS
    Created 2 scheduled tasks for maintenance purposes
.DESCRIPTION
    Creates a scheduled task to run a few commands to help identify and fix corruption as well as cleanup the OS. This also creates a second task to cleanup each users area.
.EXAMPLE
    & .\Set-MaintenanceScheduledTasks.ps1
#>

# Script functions

function init {
    $SCRIPT_EXEC_MODE = "Update" # Update or Delete. Tells the script to either update the registry or delete the keys
    $REG_ROOT_PATH = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
    $REG_DATA = @(
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Active Setup Temp Folders"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\BranchCache"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\D3D Shader Cache"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Delivery Optimization Files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Diagnostic Data Viewer database files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Downloaded Program Files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Feedback Hub Archive log files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Internet Cache Files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Old ChkDsk Files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Recycle Bin"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\RetailDemo Offline Content"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Setup Log Files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\System error memory dump files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\System error minidump files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Temporary Files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Thumbnail Cache"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Update Cleanup"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\User file versions"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Windows Defender"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Windows Error Reporting Files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
        [PSCustomObject]@{
            Path  = "$REG_ROOT_PATH\Windows Upgrade Log Files"
            Key   = "StateFlags2048"
            Value = "2"
            Type  = "DWord"
        }
    )
    if (beginRegistryUpdate -data $REG_DATA -mode $SCRIPT_EXEC_MODE) {
        $NEW_TASKS = @(
            [PSCustomObject]@{
                Name   = "ScheduledMaintenance"
                Folder = "ABYSS.ORG.UK"
                B64XML = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTE2Ij8+DQo8VGFzayB2ZXJzaW9uPSIxLjQiIHhtbG5zPSJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dpbmRvd3MvMjAwNC8wMi9taXQvdGFzayI+DQogIDxSZWdpc3RyYXRpb25JbmZvPg0KICAgIDxEYXRlPjIwMjQtMTItMjhUMDA6MzI6MjMuODk1MTwvRGF0ZT4NCiAgICA8QXV0aG9yPkFCWVNTXGRhcm5lbC5rdW1hcjwvQXV0aG9yPg0KICAgIDxVUkk+XEFCWVNTLk9SRy5VS1xTY2hlZHVsZWRNYWludGVuYW5jZTwvVVJJPg0KICA8L1JlZ2lzdHJhdGlvbkluZm8+DQogIDxUcmlnZ2Vycz4NCiAgICA8Q2FsZW5kYXJUcmlnZ2VyPg0KICAgICAgPFN0YXJ0Qm91bmRhcnk+MjAyNC0xMi0yN1QxMjowMDowMDwvU3RhcnRCb3VuZGFyeT4NCiAgICAgIDxFbmFibGVkPnRydWU8L0VuYWJsZWQ+DQogICAgICA8U2NoZWR1bGVCeU1vbnRoPg0KICAgICAgICA8RGF5c09mTW9udGg+DQogICAgICAgICAgPERheT4xPC9EYXk+DQogICAgICAgIDwvRGF5c09mTW9udGg+DQogICAgICAgIDxNb250aHM+DQogICAgICAgICAgPEphbnVhcnkgLz4NCiAgICAgICAgICA8RmVicnVhcnkgLz4NCiAgICAgICAgICA8TWFyY2ggLz4NCiAgICAgICAgICA8QXByaWwgLz4NCiAgICAgICAgICA8TWF5IC8+DQogICAgICAgICAgPEp1bmUgLz4NCiAgICAgICAgICA8SnVseSAvPg0KICAgICAgICAgIDxBdWd1c3QgLz4NCiAgICAgICAgICA8U2VwdGVtYmVyIC8+DQogICAgICAgICAgPE9jdG9iZXIgLz4NCiAgICAgICAgICA8Tm92ZW1iZXIgLz4NCiAgICAgICAgICA8RGVjZW1iZXIgLz4NCiAgICAgICAgPC9Nb250aHM+DQogICAgICA8L1NjaGVkdWxlQnlNb250aD4NCiAgICA8L0NhbGVuZGFyVHJpZ2dlcj4NCiAgICA8RXZlbnRUcmlnZ2VyPg0KICAgICAgPEVuYWJsZWQ+dHJ1ZTwvRW5hYmxlZD4NCiAgICAgIDxTdWJzY3JpcHRpb24+Jmx0O1F1ZXJ5TGlzdCZndDsmbHQ7UXVlcnkgSWQ9IjAiIFBhdGg9IlN5c3RlbSImZ3Q7Jmx0O1NlbGVjdCBQYXRoPSJTeXN0ZW0iJmd0OypbU3lzdGVtW0V2ZW50SUQ9NDFdXSZsdDsvU2VsZWN0Jmd0OyZsdDsvUXVlcnkmZ3Q7Jmx0Oy9RdWVyeUxpc3QmZ3Q7PC9TdWJzY3JpcHRpb24+DQogICAgICA8RGVsYXk+UFQ1TTwvRGVsYXk+DQogICAgPC9FdmVudFRyaWdnZXI+DQogICAgPFJlZ2lzdHJhdGlvblRyaWdnZXI+DQogICAgICA8RW5hYmxlZD50cnVlPC9FbmFibGVkPg0KICAgIDwvUmVnaXN0cmF0aW9uVHJpZ2dlcj4NCiAgPC9UcmlnZ2Vycz4NCiAgPFByaW5jaXBhbHM+DQogICAgPFByaW5jaXBhbCBpZD0iQXV0aG9yIj4NCiAgICAgIDxVc2VySWQ+Uy0xLTUtMTg8L1VzZXJJZD4NCiAgICAgIDxSdW5MZXZlbD5IaWdoZXN0QXZhaWxhYmxlPC9SdW5MZXZlbD4NCiAgICA8L1ByaW5jaXBhbD4NCiAgPC9QcmluY2lwYWxzPg0KICA8U2V0dGluZ3M+DQogICAgPE11bHRpcGxlSW5zdGFuY2VzUG9saWN5Pklnbm9yZU5ldzwvTXVsdGlwbGVJbnN0YW5jZXNQb2xpY3k+DQogICAgPERpc2FsbG93U3RhcnRJZk9uQmF0dGVyaWVzPmZhbHNlPC9EaXNhbGxvd1N0YXJ0SWZPbkJhdHRlcmllcz4NCiAgICA8U3RvcElmR29pbmdPbkJhdHRlcmllcz5mYWxzZTwvU3RvcElmR29pbmdPbkJhdHRlcmllcz4NCiAgICA8QWxsb3dIYXJkVGVybWluYXRlPmZhbHNlPC9BbGxvd0hhcmRUZXJtaW5hdGU+DQogICAgPFN0YXJ0V2hlbkF2YWlsYWJsZT50cnVlPC9TdGFydFdoZW5BdmFpbGFibGU+DQogICAgPFJ1bk9ubHlJZk5ldHdvcmtBdmFpbGFibGU+dHJ1ZTwvUnVuT25seUlmTmV0d29ya0F2YWlsYWJsZT4NCiAgICA8SWRsZVNldHRpbmdzPg0KICAgICAgPFN0b3BPbklkbGVFbmQ+ZmFsc2U8L1N0b3BPbklkbGVFbmQ+DQogICAgICA8UmVzdGFydE9uSWRsZT5mYWxzZTwvUmVzdGFydE9uSWRsZT4NCiAgICA8L0lkbGVTZXR0aW5ncz4NCiAgICA8QWxsb3dTdGFydE9uRGVtYW5kPnRydWU8L0FsbG93U3RhcnRPbkRlbWFuZD4NCiAgICA8RW5hYmxlZD50cnVlPC9FbmFibGVkPg0KICAgIDxIaWRkZW4+ZmFsc2U8L0hpZGRlbj4NCiAgICA8UnVuT25seUlmSWRsZT5mYWxzZTwvUnVuT25seUlmSWRsZT4NCiAgICA8RGlzYWxsb3dTdGFydE9uUmVtb3RlQXBwU2Vzc2lvbj5mYWxzZTwvRGlzYWxsb3dTdGFydE9uUmVtb3RlQXBwU2Vzc2lvbj4NCiAgICA8VXNlVW5pZmllZFNjaGVkdWxpbmdFbmdpbmU+dHJ1ZTwvVXNlVW5pZmllZFNjaGVkdWxpbmdFbmdpbmU+DQogICAgPFdha2VUb1J1bj50cnVlPC9XYWtlVG9SdW4+DQogICAgPEV4ZWN1dGlvblRpbWVMaW1pdD5QVDBTPC9FeGVjdXRpb25UaW1lTGltaXQ+DQogICAgPFByaW9yaXR5Pjc8L1ByaW9yaXR5Pg0KICAgIDxSZXN0YXJ0T25GYWlsdXJlPg0KICAgICAgPEludGVydmFsPlBUNU08L0ludGVydmFsPg0KICAgICAgPENvdW50PjM8L0NvdW50Pg0KICAgIDwvUmVzdGFydE9uRmFpbHVyZT4NCiAgPC9TZXR0aW5ncz4NCiAgPEFjdGlvbnMgQ29udGV4dD0iQXV0aG9yIj4NCiAgICA8RXhlYz4NCiAgICAgIDxDb21tYW5kPkM6XFdpbmRvd3NcU3lzdGVtMzJcbmV0c2guZXhlPC9Db21tYW5kPg0KICAgICAgPEFyZ3VtZW50cz53aW5zb2NrIHJlc2V0PC9Bcmd1bWVudHM+DQogICAgPC9FeGVjPg0KICAgIDxFeGVjPg0KICAgICAgPENvbW1hbmQ+QzpcV2luZG93c1xTeXN0ZW0zMlxzZmMuZXhlPC9Db21tYW5kPg0KICAgICAgPEFyZ3VtZW50cz4vc2Nhbm5vdzwvQXJndW1lbnRzPg0KICAgIDwvRXhlYz4NCiAgICA8RXhlYz4NCiAgICAgIDxDb21tYW5kPkM6XFdpbmRvd3NcU3lzdGVtMzJcRGlzbS5leGU8L0NvbW1hbmQ+DQogICAgICA8QXJndW1lbnRzPi9PbmxpbmUgL0NsZWFudXAtSW1hZ2UgL1Jlc3RvcmVIZWFsdGg8L0FyZ3VtZW50cz4NCiAgICA8L0V4ZWM+DQogICAgPEV4ZWM+DQogICAgICA8Q29tbWFuZD5DOlxXaW5kb3dzXFN5c3RlbTMyXGNsZWFubWdyLmV4ZTwvQ29tbWFuZD4NCiAgICAgIDxBcmd1bWVudHM+L3NhZ2VydW46MjA0ODwvQXJndW1lbnRzPg0KICAgIDwvRXhlYz4NCiAgPC9BY3Rpb25zPg0KPC9UYXNrPg0K"
                System = $true
            }
            [PSCustomObject]@{
                Name   = "ScheduledCleanup"
                Folder = "ABYSS.ORG.UK"
                B64XML = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTE2Ij8+DQo8VGFzayB2ZXJzaW9uPSIxLjQiIHhtbG5zPSJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dpbmRvd3MvMjAwNC8wMi9taXQvdGFzayI+DQogIDxSZWdpc3RyYXRpb25JbmZvPg0KICAgIDxEYXRlPjIwMjQtMTItMjhUMjM6Mjk6NDAuNDU1MDY3MTwvRGF0ZT4NCiAgICA8QXV0aG9yPkFCWVNTXGRhcm5lbC5rdW1hcjwvQXV0aG9yPg0KICAgIDxVUkk+XEFCWVNTLk9SRy5VS1xTY2hlZHVsZWRDbGVhbnVwPC9VUkk+DQogIDwvUmVnaXN0cmF0aW9uSW5mbz4NCiAgPFRyaWdnZXJzPg0KICAgIDxDYWxlbmRhclRyaWdnZXI+DQogICAgICA8U3RhcnRCb3VuZGFyeT4yMDI1LTAxLTAxVDEyOjAwOjAwKzAwOjAwPC9TdGFydEJvdW5kYXJ5Pg0KICAgICAgPEVuYWJsZWQ+dHJ1ZTwvRW5hYmxlZD4NCiAgICAgIDxTY2hlZHVsZUJ5RGF5Pg0KICAgICAgICA8RGF5c0ludGVydmFsPjkwPC9EYXlzSW50ZXJ2YWw+DQogICAgICA8L1NjaGVkdWxlQnlEYXk+DQogICAgPC9DYWxlbmRhclRyaWdnZXI+DQogICAgPFJlZ2lzdHJhdGlvblRyaWdnZXI+DQogICAgICA8RW5hYmxlZD50cnVlPC9FbmFibGVkPg0KICAgIDwvUmVnaXN0cmF0aW9uVHJpZ2dlcj4NCiAgPC9UcmlnZ2Vycz4NCiAgPFByaW5jaXBhbHM+DQogICAgPFByaW5jaXBhbCBpZD0iQXV0aG9yIj4NCiAgICAgIDxHcm91cElkPlMtMS01LTMyLTU0NTwvR3JvdXBJZD4NCiAgICAgIDxSdW5MZXZlbD5MZWFzdFByaXZpbGVnZTwvUnVuTGV2ZWw+DQogICAgPC9QcmluY2lwYWw+DQogIDwvUHJpbmNpcGFscz4NCiAgPFNldHRpbmdzPg0KICAgIDxNdWx0aXBsZUluc3RhbmNlc1BvbGljeT5TdG9wRXhpc3Rpbmc8L011bHRpcGxlSW5zdGFuY2VzUG9saWN5Pg0KICAgIDxEaXNhbGxvd1N0YXJ0SWZPbkJhdHRlcmllcz5mYWxzZTwvRGlzYWxsb3dTdGFydElmT25CYXR0ZXJpZXM+DQogICAgPFN0b3BJZkdvaW5nT25CYXR0ZXJpZXM+ZmFsc2U8L1N0b3BJZkdvaW5nT25CYXR0ZXJpZXM+DQogICAgPEFsbG93SGFyZFRlcm1pbmF0ZT5mYWxzZTwvQWxsb3dIYXJkVGVybWluYXRlPg0KICAgIDxTdGFydFdoZW5BdmFpbGFibGU+dHJ1ZTwvU3RhcnRXaGVuQXZhaWxhYmxlPg0KICAgIDxSdW5Pbmx5SWZOZXR3b3JrQXZhaWxhYmxlPmZhbHNlPC9SdW5Pbmx5SWZOZXR3b3JrQXZhaWxhYmxlPg0KICAgIDxJZGxlU2V0dGluZ3M+DQogICAgICA8U3RvcE9uSWRsZUVuZD5mYWxzZTwvU3RvcE9uSWRsZUVuZD4NCiAgICAgIDxSZXN0YXJ0T25JZGxlPmZhbHNlPC9SZXN0YXJ0T25JZGxlPg0KICAgIDwvSWRsZVNldHRpbmdzPg0KICAgIDxBbGxvd1N0YXJ0T25EZW1hbmQ+dHJ1ZTwvQWxsb3dTdGFydE9uRGVtYW5kPg0KICAgIDxFbmFibGVkPnRydWU8L0VuYWJsZWQ+DQogICAgPEhpZGRlbj5mYWxzZTwvSGlkZGVuPg0KICAgIDxSdW5Pbmx5SWZJZGxlPmZhbHNlPC9SdW5Pbmx5SWZJZGxlPg0KICAgIDxEaXNhbGxvd1N0YXJ0T25SZW1vdGVBcHBTZXNzaW9uPmZhbHNlPC9EaXNhbGxvd1N0YXJ0T25SZW1vdGVBcHBTZXNzaW9uPg0KICAgIDxVc2VVbmlmaWVkU2NoZWR1bGluZ0VuZ2luZT50cnVlPC9Vc2VVbmlmaWVkU2NoZWR1bGluZ0VuZ2luZT4NCiAgICA8V2FrZVRvUnVuPnRydWU8L1dha2VUb1J1bj4NCiAgICA8RXhlY3V0aW9uVGltZUxpbWl0PlBUMFM8L0V4ZWN1dGlvblRpbWVMaW1pdD4NCiAgICA8UHJpb3JpdHk+NzwvUHJpb3JpdHk+DQogICAgPFJlc3RhcnRPbkZhaWx1cmU+DQogICAgICA8SW50ZXJ2YWw+UFQ1TTwvSW50ZXJ2YWw+DQogICAgICA8Q291bnQ+MzwvQ291bnQ+DQogICAgPC9SZXN0YXJ0T25GYWlsdXJlPg0KICA8L1NldHRpbmdzPg0KICA8QWN0aW9ucyBDb250ZXh0PSJBdXRob3IiPg0KICAgIDxFeGVjPg0KICAgICAgPENvbW1hbmQ+QzpcV2luZG93c1xTeXN0ZW0zMlxjbGVhbm1nci5leGU8L0NvbW1hbmQ+DQogICAgICA8QXJndW1lbnRzPi9zYWdlcnVuOjIwNDg8L0FyZ3VtZW50cz4NCiAgICA8L0V4ZWM+DQogIDwvQWN0aW9ucz4NCjwvVGFzaz4NCg=="
                System = $false
            }
        )
        foreach ($new_task in $NEW_TASKS) {
            $existing_tasks = @()
            $existing_tasks += (Get-ScheduledTask -TaskName "$($new_task.Name)" -ErrorAction SilentlyContinue | Where-Object -Property TaskPath -Like "*$($new_task.Folder)*")
            if (($existing_tasks).Count -gt 0) {
                $CUSTOM_LOG.Information("Scheduled task '$($new_task.Name)' already exists, the existing task will be replaced with the deployed task")
                try {
                    foreach ($existing_task in $existing_tasks) {
                        $existing_task | Unregister-ScheduledTask -Confirm:$false
                        $CUSTOM_LOG.Information("Scheduled task '$($existing_task.TaskName)' has been unregistered")
                    }
                }
                catch {
                    $CUSTOM_LOG.Fail("Something went wrong, unable to remove existing task '$($existing_task.TaskName)'")
                    $CUSTOM_LOG.Error($Error)
                    Exit 1
                }
            }
            $tmp_file = New-TemporaryFile
            $CUSTOM_LOG.Information("Created temporary file '$($tmp_file.FullName)'")
            $CUSTOM_LOG.Information("Decoding & exporting Base64 XML date to temporary file")
            try {
                Out-File -FilePath $tmp_file -InputObject ([Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($new_task.B64XML)))
                $CUSTOM_LOG.Information("Decoded & exported Base64 XML date to temporary file")
            }
            catch {
                $CUSTOM_LOG.Fail("Something went wrong, unable to decode and export xml data to temporary file")
                $CUSTOM_LOG.Error($Error)
                Exit 1
            }
            try {
                if ($new_task.System) {
                    Start-Process -FilePath "$env:windir\System32\schtasks.exe" -ArgumentList "/Create /ru System /XML `"$($tmp_file.FullName)`" /TN `"$($new_task.Folder)\$($new_task.Name)`"" -Verb RunAs -Wait -WindowStyle Hidden
                    $CUSTOM_LOG.Success("Imported scheduled task '$($new_task.Name)' XML data")
                }
                else {
                    Start-Process -FilePath "$env:windir\System32\schtasks.exe" -ArgumentList "/Create /XML `"$($tmp_file.FullName)`" /TN `"$($new_task.Folder)\$($new_task.Name)`"" -Verb RunAs -Wait -WindowStyle Hidden
                    $CUSTOM_LOG.Success("Imported scheduled task '$($new_task.Name)' XML data")
                }

            }
            catch {
                $CUSTOM_LOG.Fail("Something went wrong, unable to import scheduled task from temporary file")
                $CUSTOM_LOG.Error($Error)
                Exit 1
            }
        }
        Exit 0
    }
    else {
        $CUSTOM_LOG.Fail("Unable to update registry data")
        $CUSTOM_LOG.Error($Error)
        Exit 1
    }
}

#################################
#                               #
#   REQUIRED SCRIPT VARIABLES   #
#                               #
#################################

# DO NOT REMOVE THESE VARIABLES
# DO NOT LEAVE THESE VARIABLES BLANK

$SCRIPT_NAME = "Maintenance Scheduled Tasks" # This is used in the window title and the event log entries.

################################################
#                                              #
#   DO NOT EDIT ANYTHING BELOW THIS MESSAGE!   #
#                                              #
################################################

# Script functions - DO NOT CHANGE!

function updateRegistry {
    param (
        [Parameter()]
        $data
    )
    foreach ($i in ($data | Sort-Object -Property Path)) {
        if (!(Test-Path -Path $i.Path)) {
            try {
                New-Item -Path $i.Path -Force -ErrorAction Stop | Out-Null
                $CUSTOM_LOG.Success("Created path: $($i.Path)")
            }
            catch {
                $CUSTOM_LOG.Fail("Failed to create registry path: $($i.Path)")
                $CUSTOM_LOG.Error($Error[0])
                return $false
            }
        }
        if ($i.Key) {
            if ((Get-ItemProperty $i.Path).PSObject.Properties.Name -contains $i.Key) {
                try {
                    Set-ItemProperty -Path $i.Path -Name $i.Key -Value $i.Value -Force -ErrorAction Stop | Out-Null
                    $CUSTOM_LOG.Success("Successfully made the following registry edit:`n - Key: $($i.Path)`n - Property: $($i.Key)`n - Value: $($i.Value)`n - Type: $($i.Type)")
                }
                catch {
                    $CUSTOM_LOG.Fail("Failed to make the following registry edit:`n - Key: $($i.Path)`n - Property: $($i.Key)`n - Value: $($i.Value)`n - Type: $($i.Type)")
                    $CUSTOM_LOG.Error($Error[0])
                    return $false
                }
            }
            else {
                try {
                    New-ItemProperty -Path $i.Path -Name $i.Key -Value $i.Value -Type $i.Type -Force -ErrorAction Stop | Out-Null
                    $CUSTOM_LOG.Success("Created the following registry entry:`n - Key: $($i.Path)`n - Property: $($i.Key)`n - Value: $($i.Value)`n - Type: $($i.Type)")
                }
                catch {
                    $CUSTOM_LOG.Fail("Failed to make the following registry edit:`n - Key: $($i.Path)`n - Property: $($i.Key)`n - Value: $($i.Value)`n - Type: $($i.Type)")
                    $CUSTOM_LOG.Error($Error[0])
                    return $false
                }
            }
        }
    }
    $CUSTOM_LOG.Success("Completed registry update successfully.")
    return $true
}

function removeRegistry {
    param (
        [Parameter()]
        $data
    )
    foreach ($i in ($data | Sort-Object -Property Path, Key -Descending)) {
        if (Test-Path -Path $i.Path) {
            if ($i.Key) {
                try {
                    Remove-ItemProperty -Path $i.Path -Name $i.Key | Out-Null
                    $CUSTOM_LOG.Success("Removed registry Property:`n - Key: $($i.Path)`n - Property: $($i.Key)")
                }
                catch {
                    $CUSTOM_LOG.Fail("Failed to remove registy property: $($i.Key) at path: $($i.Path)")
                    $CUSTOM_LOG.Error($Error[0])
                    return $false
                }
            }
            else {
                try {
                    Remove-Item -Path $i.Path -Recurse -Force | Out-Null
                    $CUSTOM_LOG.Success("Removed registry Key:`n - Key: $($i.Path)")
                }
                catch {
                    $CUSTOM_LOG.Fail("Failed to remove registy path: $($i.Path)")
                    $CUSTOM_LOG.Error($Error[0])
                    return $false
                }
            }
        }
        else {
            $CUSTOM_LOG.Information("Registry Path '$($i.Path)' does not exist")
        }
    }
    $CUSTOM_LOG.Success("Completed registry update successfully.")
    return $true
}

function beginRegistryUpdate {
    param (
        [Parameter()]
        $data,
        [Parameter()]
        [ValidateSet("Update", "Delete")]
        [string]
        $mode
    )
    switch ($mode) {
        "Update" { return updateRegistry -data $data }
        "Delete" { return removeRegistry -data $data }
        Default { return updateRegistry -data $data }
    }
}

function checkRunIn64BitPowershell {
    if (($env:PROCESSOR_ARCHITECTURE -eq "x86") -or ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64")) {
        $CUSTOM_LOG.Warning("'$SCRIPT_NAME' is running in 32-bit (x86) mode")
        try {
            $CUSTOM_LOG.Information("Attempting to start $SCRIPT_NAME in 64-bit (x64) mode")
            Start-Process -FilePath "$env:windir\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -Wait -NoNewWindow -ArgumentList "-File ""$PSCOMMANDPATH"""
            Exit 0
        }
        catch {
            $CUSTOM_LOG.Error("Unable to start '$SCRIPT_NAME' in 64-bit (x64) mode")
            $CUSTOM_LOG.Error($Error[0])
            Exit 1
        }
        Exit 1
    }
    else {
        $CUSTOM_LOG.Information("'$SCRIPT_NAME' is running in 64-bit (x64) mode")
    }
}

# Pre-defined Variables - DO NOT CHANGE!
$SCRIPT_NAME = ".Intune.PSScript.$($SCRIPT_NAME.Replace(' ',''))"
[Boolean]$IS_SYSTEM = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).Identities.IsSystem
[Boolean]$IS_ADMIN = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
[String]$EXEC_USER = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).Identities.Name
[Int]$PID = [System.Diagnostics.Process]::GetCurrentProcess().Id

# Script & Terminal Preferences - DO NOT CHANGE!
$ProgressPreference = "Continue"
$InformationPreference = "Continue"
$DebugPreference = "SilentlyContinue"
$ErrorActionPreference = "Continue"
$VerbosePreference = "SilentlyContinue"
$WarningPreference = "Continue"
$host.ui.RawUI.WindowTitle = $SCRIPT_NAME

# Create new instance of CustomLog class and initialise Event Log - DO NOT CHANGE!
$CUSTOM_LOG = [CustomLog]::new($SCRIPT_NAME)
$CUSTOM_LOG.InitEventLog()

# Console Signature - DO NOT CHANGE!
$SCRIPT_FILENAME = $MyInvocation.MyCommand.Name
function sig {
    $len = @(($SCRIPT_NAME.Length + 13), ($SCRIPT_FILENAME.Length + 10), 20, 42, 29, 40, 63, 62, 61, 44)
    $len_max = ($len | Measure-Object -Maximum).Maximum
    Write-Host "`t####$('#'*$len_max)####`n`t#   $(' '*$len_max)   #`n`t#   Script Name: $($SCRIPT_NAME)$(' '*($len_max-$len[0]))   #`n`t#   Filename: $($SCRIPT_FILENAME)$(' '*($len_max-$len[1]))   #`n`t#   $(' '*$len_max)   #`n`t#   Author: Darnel Kumar$(' '*($len_max-$len[2]))   #`n`t#   Author GitHub: https://github.com/Darnel-K$(' '*($len_max-$len[3]))   #`n`t#   Copyright $([char]0x00A9) $(Get-Date -Format  'yyyy') Darnel Kumar$(' '*($len_max-$len[4]))   #`n`t#   $(' '*$len_max)   #`n`t#   $('-'*$len_max)   #`n`t#   $(' '*$len_max)   #`n`t#   License: GNU General Public License v3.0$(' '*($len_max-$len[5]))   #`n`t#   $(' '*$len_max)   #`n`t#   This program is distributed in the hope that it will be useful,$(' '*($len_max-$len[6]))   #`n`t#   but WITHOUT ANY WARRANTY; without even the implied warranty of$(' '*($len_max-$len[7]))   #`n`t#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the$(' '*($len_max-$len[8]))   #`n`t#   GNU General Public License for more details.$(' '*($len_max-$len[9]))   #`n`t#   $(' '*$len_max)   #`n`t####$('#'*$len_max)####`n" -ForegroundColor Green
}

# Define CustomLog class - DO NOT CHANGE!
class CustomLog {
    [string] $log_name
    [string] $log_source
    hidden [Boolean] $event_log_init

    CustomLog() {
        $this.log_name = "ABYSS.ORG.UK"
        $this.event_log_init = $false
        $this.log_source = "Default"
    }

    CustomLog([String]$log_source) {
        $this.log_name = "ABYSS.ORG.UK"
        $this.event_log_init = $false
        $this.log_source = $log_source
    }

    CustomLog([String]$log_name, [String]$log_source) {
        $this.log_name = $log_name
        $this.event_log_init = $false
        $this.log_source = $log_source
    }

    [void] InitEventLog() {
        if (-not $this.CheckEventLogExists()) {
            if (-not $this.CreateEventLog()) {
                Write-Warning "Unable to initialise event log '$($this.log_name)' with source '$($this.log_source)', falling back to event log 'Application' with source 'Application'"
                $this.log_name, $this.log_source = "Application", "Application"
                $this.event_log_init = $true
            }
            else {
                $this.event_log_init = $true
                $this.Success("Log initialised using event log '$($this.log_name)' with source '$($this.log_source)'")
            }
        }
        else {
            $this.event_log_init = $true
            Write-Verbose "Event log '$($this.log_name)' with source '$($this.log_source)' already exists, using existing event log"
        }
    }

    [Boolean] CheckEventLogInit($event_log_enabled_per_message = $this.event_log_init) {
        if ($this.event_log_init -and $event_log_enabled_per_message) {
            return $true
        }
        elseif ($this.event_log_init -and -not $event_log_enabled_per_message) {
            return $false
        }
        elseif (-not $this.event_log_init -and -not $event_log_enabled_per_message) {
            return $false
        }
        else {
            Write-Warning "Cannot write to event log!"
            Write-Warning "Event log not initialised, please initialise logging system!"
            return $false
        }
    }

    [Boolean] CheckEventLogExists() {
        Write-Verbose "Checking if event log '$($this.log_name)' & source '$($this.log_source)' exists"
        try {
            if (-not ([System.Diagnostics.EventLog]::Exists($this.log_name)) -or -not ([System.Diagnostics.EventLog]::SourceExists($this.log_source))) {
                Write-Verbose "Event log '$($this.log_name)' or source '$($this.log_source)' does not exist"
                return $false
            }
            else {
                return $true
            }
        }
        catch {
            Write-Verbose "Unable to check if event log '$($this.log_name)' or source '$($this.log_source)' exists"
            Write-Debug $Error[0]
            return $false
        }

    }

    [Boolean] CreateEventLog() {
        try {
            Write-Verbose "Attempting to create event log '$($this.log_name)' & source '$($this.log_source)'"
            New-EventLog -LogName $this.log_name -Source $this.log_source -ErrorAction Stop
            if ($this.CheckEventLogExists()) {
                return $true
            }
            else {
                throw "Unable to create event log '$($this.log_name)' or source '$($this.log_source)'"
            }
        }
        catch {
            Write-Verbose "Unable to create event log '$($this.log_name)' or source '$($this.log_source)'"
            Write-Debug $Error[0]
            return $false
        }
    }

    [void] Success([string]$msg) {
        $this.Success($msg, 0, $this.event_log_init)
    }
    [void] Success([string]$msg, [Boolean]$event_log_enabled) {
        $this.Success($msg, 0, $event_log_enabled)
    }
    [void] Success([string]$msg, [int]$event_id) {
        $this.Success($msg, $event_id, $this.event_log_init)
    }
    [void] Success([string]$msg, [int]$event_id, [Boolean]$event_log_enabled) {
        if ($this.CheckEventLogInit($event_log_enabled)) {
            Write-EventLog -LogName $this.log_name -Source $this.log_source -EntryType SuccessAudit -Message $msg -EventId $event_id
        }
        Write-Host "SUCCESS: $msg" -ForegroundColor Green
    }

    [void] Fail([string]$msg) {
        $this.Fail($msg, 0, $this.event_log_init)
    }
    [void] Fail([string]$msg, [Boolean]$event_log_enabled) {
        $this.Fail($msg, 0, $event_log_enabled)
    }
    [void] Fail([string]$msg, [int]$event_id) {
        $this.Fail($msg, $event_id, $this.event_log_init)
    }
    [void] Fail([string]$msg, [int]$event_id, [Boolean]$event_log_enabled) {
        if ($this.CheckEventLogInit($event_log_enabled)) {
            Write-EventLog -LogName $this.log_name -Source $this.log_source -EntryType FailureAudit -Message $msg -EventId $event_id
        }
        Write-Host "FAILURE: $msg" -ForegroundColor Red
    }

    [void] Information([string]$msg) {
        $this.Information($msg, 0, $this.event_log_init)
    }
    [void] Information([string]$msg, [Boolean]$event_log_enabled) {
        $this.Information($msg, 0, $event_log_enabled)
    }
    [void] Information([string]$msg, [int]$event_id) {
        $this.Information($msg, $event_id, $this.event_log_init)
    }
    [void] Information([string]$msg, [int]$event_id, [Boolean]$event_log_enabled) {
        if ($this.CheckEventLogInit($event_log_enabled)) {
            Write-EventLog -LogName $this.log_name -Source $this.log_source -EntryType Information -Message $msg -EventId $event_id
        }
        Write-Information "INFO: $msg" -InformationAction Continue
    }

    [void] Warning([string]$msg) {
        $this.Warning($msg, 0, $this.event_log_init)
    }
    [void] Warning([string]$msg, [Boolean]$event_log_enabled) {
        $this.Warning($msg, 0, $event_log_enabled)
    }
    [void] Warning([string]$msg, [int]$event_id) {
        $this.Warning($msg, $event_id, $this.event_log_init)
    }
    [void] Warning([string]$msg, [int]$event_id, [Boolean]$event_log_enabled) {
        if ($this.CheckEventLogInit($event_log_enabled)) {
            Write-EventLog -LogName $this.log_name -Source $this.log_source -EntryType Warning -Message $msg -EventId $event_id
        }
        Write-Warning $msg -WarningAction Continue
    }

    [void] Error([string]$msg) {
        $this.Error($msg, 0, $this.event_log_init)
    }
    [void] Error([string]$msg, [Boolean]$event_log_enabled) {
        $this.Error($msg, 0, $event_log_enabled)
    }
    [void] Error([string]$msg, [int]$event_id) {
        $this.Error($msg, $event_id, $this.event_log_init)
    }
    [void] Error([string]$msg, [int]$event_id, [Boolean]$event_log_enabled) {
        if ($this.CheckEventLogInit($event_log_enabled)) {
            Write-EventLog -LogName $this.log_name -Source $this.log_source -EntryType Error -Message $msg -EventId $event_id
        }
        Write-Error "ERROR: $msg" -ErrorAction Continue
    }

}

# Clear console & display signature before script initialisation
Clear-Host
sig
checkRunIn64BitPowershell
$CUSTOM_LOG.Information("Script PID: $PID")
init
