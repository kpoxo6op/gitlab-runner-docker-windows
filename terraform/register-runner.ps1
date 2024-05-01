$logFile = "C:\Logs\register-runner.txt"
$dir = Split-Path -Parent $logFile
New-Item -ItemType Directory -Path $dir
Start-Transcript -Path $logFile -Append

New-Item -Path C:\GitLab-Runner -ItemType Directory
Set-Location C:\GitLab-Runner

Invoke-WebRequest -Uri "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-windows-amd64.exe" -OutFile gitlab-runner.exe
Write-Output "Register runner with token ${runner_token}"
$registerParams = @(
    "register",
    "--builds-dir", "C:\GitLab-Runner",
    "--cache-dir", "C:\GitLab-Runner",
    "--config", "C:\GitLab-Runner\config.toml",
    "--description", "docker runner",
    "--docker-image", "alpine:latest",
    "--executor", "docker",
    "--non-interactive",
    "--token", "${runner_token}",
    "--url", "https://gitlab.com/"
)
& .\gitlab-runner.exe @registerParams

Write-Output "Install runner service"
$commonParams = @{
    FilePath    = C:\GitLab-Runner\gitlab-runner.exe
    NoNewWindow = $true
    Wait        = $true
}
$installArgs = @(
  "install",
  "--working-directory", "C:\GitLab-Runner",
  "--config", "C:\GitLab-Runner\config.toml"
)
Start-Process @commonParams -ArgumentList $installArgs

Write-Output "Start runner service"
Start-Process @commonParams -ArgumentList "start"

Write-Output "Verify runners"
& .\gitlab-runner.exe "verify"

Get-WinEvent -ProviderName gitlab-runner | Format-Table -wrap -auto

Stop-Transcript
