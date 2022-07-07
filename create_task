

$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "& {get-eventlog -logname Application -After ((get-date).AddDays(-1)) | Export-Csv -Path c:\temp\applog.csv -Force -NoTypeInformation}"'
$trigger =  New-ScheduledTaskTrigger -Once -At "10/13/2020 15:13"
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -MultipleInstances Parallel


Register-ScheduledTask -TaskName <Action_name> -Action $action -Trigger $trigger -Settings $settings -Principal $principal 


###########################################



schtasks /create /sc once /sd 04/09/2020 /st 08:42 /tr "shutdown -r -f -t 50" /RU  SYSTEM /tn "restart test"
