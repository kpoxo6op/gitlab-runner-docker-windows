# Gitlab agent pwsh

Demo code for article <https://borisascode.com/blog/gitlab-docker-for-windows-runner>

Create gitlab agent with terraform and powershell on GCP.
```sh
# follow docs
# gcp account
# billing enabled on projects
# ~/infra-admin-key.json
# ~/terraform-admin-key.json
source .env
terraform init
terraform plan
```
