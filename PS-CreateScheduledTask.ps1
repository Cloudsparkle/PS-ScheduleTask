<#
.SYNOPSIS
  Create a new scheduled task
.DESCRIPTION
  Create a new scheduled task, and make it run after reboot
.INPUTS
  Password of service account
.OUTPUTS
  Scheduled Task
.NOTES
  Version:        1.0
  Author:         Bart Jacobs - @Cloudsparkle
  Creation Date:  16/03/2022
  Purpose/Change: Create a new scheduled task
 .EXAMPLE
  None
#>

$taskname = "Test"
$taskdescription = "This is a test"
$taskExe = "c:\program Files (x86)\BV16\BV16.exe"
$taskExeArgument = ""
$taskUserID = "ITGLO\sa_taskflow"
$taskminutes = 1
$taskUserCred = Get-Credential -Message "Please enter password" -UserName $taskUserID

# Determine if we are using command-line arguments
if ($taskExeArgument -eq "")
{
    $taskAction = New-ScheduledTaskAction -Execute $taskExe
}
else
{
    $taskAction = New-ScheduledTaskAction -Execute $taskExe -Argument $taskExeArgument
}

# Set the scheduled task to start x number of minutes from now, and try to repeat starting every x number of minutes
$tasktrigger = New-ScheduledTaskTrigger -Once -at (get-date).AddMinutes($taskminutes) -RepetitionInterval (new-timespan -minute $taskminutes)

# Set the scheduled task to have only one instance running, deny new from starting on the schedule
$tasksettings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -ExecutionTimeLimit "00:00:00"

# Bundle all paramters set
$params = @{
"Action"      = $taskAction
"TaskName"    = $taskname
"Trigger"     = $tasktrigger
"User"        = $taskUserCred.UserName
"Password"    = $taskUserCred.GetNetworkCredential().Password
"RunLevel"    = "Highest"
"Description" = $taskdescription
"Settings"    = $tasksettings
}

# Create the actual scheduled task
Register-ScheduledTask @params
