$logFile = "C:\Logs\startup-log.txt"
$dir = Split-Path -Parent $logFile
New-Item -ItemType Directory -Path $dir
Start-Transcript -Path $logFile -Append

Write-Output "Create GitLab runner"

Stop-Transcript
