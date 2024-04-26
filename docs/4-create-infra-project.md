# create infra project

```sh
# swith to the main account
# gcloud config set account yourmainaccounemail@gmail.com
gcloud projects create gitlab-agent-pwsh
gcloud services list --enabled --project gitlab-agent-pwsh
#link billing account
gcloud beta billing accounts list
gcloud beta billing projects link gitlab-agent-pwsh --billing-account=[redacted]
gcloud services enable compute.googleapis.com --project gitlab-agent-pwsh
```
