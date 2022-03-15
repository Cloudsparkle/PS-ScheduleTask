$taskname = "Test"
$taskdescription = "Dit is een test"
$taskExe = "c:\program Files (x86)\BV16\BV16.exe"
$taskExeArgument = ""
$taskUserID = "ITGLO\sa_taskflow"
$taskUserCred = Get-Credential -Message "Please enter password" -UserName $taskUserID
$taskminutes = 1

if ($taskExeArgument -eq "")
{
    $taskAction = New-ScheduledTaskAction -Execute $taskExe
}
else
{
    $taskAction = New-ScheduledTaskAction -Execute $taskExe -Argument $taskExeArgument
}

$tasktrigger = New-ScheduledTaskTrigger -Once -at (get-date).AddMinutes($taskminutes) -RepetitionInterval (new-timespan -minute $taskminutes)
$tasksettings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -ExecutionTimeLimit "00:00:00"

#Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $taskTrigger -Description $taskdescription -User $taskUserCred.UserName -Password $taskUserCred.GetNetworkCredential().Password

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

Register-ScheduledTask @params
 
