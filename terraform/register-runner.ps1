$logFile = "C:\Logs\register-runner.txt"
$dir = Split-Path -Parent $logFile
New-Item -ItemType Directory -Path $dir
Start-Transcript -Path $logFile -Append

New-Item -Path C:\GitLab-Runner -ItemType Directory

Invoke-WebRequest -Uri "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-windows-amd64.exe" -OutFile C:\GitLab-Runner\gitlab-runner.exe

Write-Output "Regsiter runner with token ${runner_token}"

Stop-Transcript
