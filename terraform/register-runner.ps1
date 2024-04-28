$logFile = "C:\Logs\register-runner.txt"
$dir = Split-Path -Parent $logFile
New-Item -ItemType Directory -Path $dir
Start-Transcript -Path $logFile -Append

New-Item -Path C:\GitLab-Runner -ItemType Directory
Set-Location C:\GitLab-Runner

Invoke-WebRequest -Uri "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-windows-amd64.exe" -OutFile gitlab-runner.exe
Write-Output "Regsiter runner with token ${runner_token}"
# todo fix syntax
$args = @(
    "register",
    "--non-interactive",
    "--url", "https://gitlab.com/",
    "--token", "${runner_token}",
    "--executor", "docker",
    "--docker-image", "alpine:latest",
    "--builds-dir", "C:\GitLab-Runner",
    "--cache-dir", "C:\GitLab-Runner",
    "--description", "docker runner"
)
& .\gitlab-runner.exe @args

Stop-Transcript
