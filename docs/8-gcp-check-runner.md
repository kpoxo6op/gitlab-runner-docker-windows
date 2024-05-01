# check docker and runner registration

```sh
gcloud compute ssh gitlab-runner-windows
pwsh
Get-Content C:\Logs\startup-log.txt
Get-Service docker
```
