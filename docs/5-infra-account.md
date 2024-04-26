# create infra account 

```sh
gcloud iam service-accounts create infra-admin \
    --description="Service account for managing infrastructure resources" \
    --display-name="Infrastructure Admin" \
    --project=gitlab-agent-pwsh

gcloud projects add-iam-policy-binding gitlab-agent-pwsh \
    --member="serviceAccount:infra-admin@gitlab-agent-pwsh.iam.gserviceaccount.com" \
    --role="roles/compute.instanceAdmin.v1"

gcloud projects add-iam-policy-binding gitlab-agent-pwsh \
    --member="serviceAccount:infra-admin@gitlab-agent-pwsh.iam.gserviceaccount.com" \
    --role="roles/compute.networkAdmin"

gcloud iam service-accounts keys create ~/infra-admin-key.json \
    --iam-account=infra-admin@gitlab-agent-pwsh.iam.gserviceaccount.com

```