$logFile = "C:\Logs\install-docker.txt"
$dir = Split-Path -Parent $logFile
New-Item -ItemType Directory -Path $dir
Start-Transcript -Path $logFile -Append

Write-Output "Install Docker"
$ScriptUrl = "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1"
Invoke-WebRequest -Uri $ScriptUrl -OutFile "install-docker-ce.ps1"
.\install-docker-ce.ps1 -Force -DockerVersion '26.1.1'

if (get-service *docker* -ea SilentlyContinue) {

  $logFile = "C:\Logs\register-runner.txt"
  $runnerDir = "C:\GitLab-Runner"
  $dir = Split-Path -Parent $logFile
  New-Item -ItemType Directory -Path $dir
  Start-Transcript -Path $logFile -Append

  New-Item -Path $runnerDir -ItemType Directory
  Set-Location $runnerDir

  $gitlabRunnerUrl = "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-windows-amd64.exe"
  $gitlabRunnerExe = Join-Path -Path $runnerDir -ChildPath "gitlab-runner.exe"

  Invoke-WebRequest -Uri $gitlabRunnerUrl -OutFile $gitlabRunnerExe
  Write-Output "Register runner with token ${runner_token}"
  $registerParams = @(
    "register",
    "--builds-dir", $runnerDir,
    "--cache-dir", $runnerDir,
    "--config", "$runnerDir\config.toml",
    "--description", "docker for windows runner",
    "--executor", "docker-windows",
    "--non-interactive",
    "--token", "${runner_token}",
    "--url", "https://gitlab.com/",
    "--docker-image", "mcr.microsoft.com/windows/nanoserver:ltsc2022",
    "--docker-helper-image", "registry.gitlab.com/gitlab-org/gitlab-runner/gitlab-runner-helper:x86_64-bleeding-nanoserver21H2"
  )
  & $gitlabRunnerExe @registerParams

  Write-Output "Install runner service"
  $commonParams = @{
    FilePath    = $gitlabRunnerExe
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
  & $gitlabRunnerExe "verify"
  Get-WinEvent -ProviderName gitlab-runner | Format-Table -wrap -auto

} else {
  Write-Output "wait for docker before registering runner"
}

Stop-Transcript
