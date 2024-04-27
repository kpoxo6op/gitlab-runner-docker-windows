$logFile = "C:\Logs\startup-log.txt"
$dir = Split-Path -Parent $logFile
New-Item -ItemType Directory -Path $dir
Start-Transcript -Path $logFile -Append

Write-Output "Install Docker"
$ScriptUrl = "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1"
Invoke-WebRequest -Uri $ScriptUrl -OutFile "install-docker-ce.ps1"
.\install-docker-ce.ps1

Stop-Transcript
