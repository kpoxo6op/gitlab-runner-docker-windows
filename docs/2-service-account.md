# create service account for managing tf state

```sh

gcloud iam service-accounts create terraform-admin \
    --description="Service account for Terraform operations" \
    --display-name="Terraform Admin"

gcloud projects describe gitlab-agent-pwsh-tf-state
# get proj id such as 'gitlab-agent-pwsh-tf-state'

gcloud projects add-iam-policy-binding gitlab-agent-pwsh-tf-state \
    --member="serviceAccount:terraform-admin@gitlab-agent-pwsh-tf-state.iam.gserviceaccount.com" \
    --role="roles/editor"

gcloud iam service-accounts keys create ~/terraform-admin-key.json \
    --iam-account terraform-admin@gitlab-agent-pwsh-tf-state.iam.gserviceaccount.com

cat ~/terraform-admin-key.json
```