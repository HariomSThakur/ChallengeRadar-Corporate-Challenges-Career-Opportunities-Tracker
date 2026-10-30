$ErrorActionPreference = 'Stop'
$TaskName = 'Corporate Challenge Tracker'
$Task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue

if ($Task) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    Write-Host 'Daily task removed.'
} else {
    Write-Host 'No Corporate Challenge Tracker task is registered.'
}
