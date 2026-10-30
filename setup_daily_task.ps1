$ErrorActionPreference = 'Stop'
$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PythonCommand = Get-Command 'python.exe' -ErrorAction SilentlyContinue

if (-not $PythonCommand) {
    $PythonCommand = Get-Command 'py.exe' -ErrorAction SilentlyContinue
}
if (-not $PythonCommand) {
    throw 'Python was not found. Install Python, then run this script again.'
}

$PythonPath = $PythonCommand.Source
$ScriptPath = Join-Path $ProjectDir 'tracker.py'
$Action = New-ScheduledTaskAction -Execute $PythonPath -Argument ('"{0}"' -f $ScriptPath) -WorkingDirectory $ProjectDir
$Trigger = New-ScheduledTaskTrigger -Daily -At '9:00 AM'
$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew
$Principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Limited

Register-ScheduledTask -TaskName 'Corporate Challenge Tracker' -Action $Action -Trigger $Trigger -Settings $Settings -Principal $Principal -Description 'Search configured public sources for company challenges and hiring opportunities.' -Force | Out-Null
Write-Host 'Daily task created for 9:00 AM. It runs when you are signed in and Python is available.'
