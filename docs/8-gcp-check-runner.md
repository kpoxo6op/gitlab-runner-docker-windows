# check docker and runner registration

```sh
gcloud compute ssh gitlab-runner-windows --project=gitlab-agent-pwsh --zone=australia-southeast1-a
pwsh
Get-Content C:\Logs\startup.txt -Wait
Get-Content C:\GitLab-Runner\config.toml
Get-Service docker, gitlab-runner
Get-Eventlog Application -Source gitlab-runner -Newest 20 | Format-Table -Wrap -Auto
```
