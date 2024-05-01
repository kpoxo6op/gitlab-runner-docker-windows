# check docker and runner registration

```sh
gcloud compute ssh gitlab-runner-windows
pwsh
Get-Content C:\Logs\install-docker.txt
Get-Content C:\Logs\register-runner.txt
Get-Service docker
```
