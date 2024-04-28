$logFile = "C:\Logs\register-runner.txt"
$dir = Split-Path -Parent $logFile
New-Item -ItemType Directory -Path $dir
Start-Transcript -Path $logFile -Append

Write-Output "Regsiter runner with token ${runner_token}"

Stop-Transcript
