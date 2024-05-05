<#
.SYNOPSIS
    This script installs Docker and GitLab Runner on a Windows machine.

.DESCRIPTION
    The script starts by creating a log file and a directory to store logs.
    It then installs Docker Community Edition on the machine using a PowerShell script from a URL.
    After installing Docker, it checks if the Docker service is running.
    If Docker is running, it proceeds to install and configure GitLab Runner.
    If Docker is not running, it waits before proceeding with the runner installation.

.NOTES

.LINK
    "Access to CI_SERVER_TLS_CA_FILE' is denied" workaround
    https://gitlab.com/gitlab-org/gitlab-runner/-/issues/28768#note_1789970092

.LINK
    Build with image = nanoserver (uses deafult helper image)
    https://gitlab.com/82phil/gitlab_runner_issue_28768_testing

#>
$logFile = "C:\Logs\startup.txt"
$dir = Split-Path -Parent $logFile
New-Item -ItemType Directory -Path $dir
Start-Transcript -Path $logFile -Append

Write-Output "Install Docker"
$ScriptUrl = "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1"
Invoke-WebRequest -Uri $ScriptUrl -OutFile "install-docker-ce.ps1"
.\install-docker-ce.ps1 -Force -DockerVersion '26.1.1'

if (Get-Service *docker* -ea SilentlyContinue) {

  $runnerDir = "C:\GitLab-Runner"
  New-Item -Path $runnerDir -ItemType Directory
  Set-Location $runnerDir

  # 16.11.0 at the time of the writing
  $gitlabRunnerUrl = "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-windows-amd64.exe"
  $runnerExe = Join-Path -Path $runnerDir -ChildPath "gitlab-runner.exe"

  Invoke-WebRequest -Uri $gitlabRunnerUrl -OutFile $runnerExe
  Write-Output "Register runner with token ${runner_token}"
  $registerParams = @(
    "register",
    "--builds-dir", $runnerDir,
    "--cache-dir", $runnerDir,
    "--config", "$runnerDir\config.toml",
    "--description", "Docker for Windows runner",
    "--executor", "docker-windows",
    "--non-interactive",
    "--token", "${runner_token}",
    "--url", "https://gitlab.com/",
    # https://hub.docker.com/_/microsoft-powershell
    "--docker-image", "mcr.microsoft.com/powershell:lts-nanoserver-ltsc2022",
    # https://hub.docker.com/r/gitlab/gitlab-runner-helper/tags
    "--docker-helper-image", "registry.gitlab.com/gitlab-org/gitlab-runner/gitlab-runner-helper:x86_64-bleeding-nanoserver21H2",
    "--docker-user", "ContainerAdministrator"
  )
  & $runnerExe @registerParams

  Write-Output "Install runner service"
  $commonParams = @{
    FilePath    = $runnerExe
    NoNewWindow = $true
    Wait        = $true
  }
  $installArgs = @(
    "install",
    "--working-directory", $runnerDir,
    "--config", "$runnerDir\config.toml"
  )
  Start-Process @commonParams -ArgumentList $installArgs

  Write-Output "Start runner service"
  Start-Process @commonParams -ArgumentList "start"

  Write-Output "Verify runners"
  & $runnerExe "verify"
  Get-WinEvent -ProviderName gitlab-runner | Format-Table -wrap -auto

} else {
  Write-Output "Waiting for Docker before registering runner"
}
Stop-Transcript
