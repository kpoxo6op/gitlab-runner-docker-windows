# create provider and state bucket

```sh
gcloud services enable storage.googleapis.com
mkdir terraform
cd terraform
# create backend.tf
# create provider.tf
export GOOGLE_APPLICATION_CREDENTIALS="/home/${USER}/terraform-admin-key.json"

# │ Error: Failed to get existing workspaces: querying Cloud Storage failed: storage: bucket doesn't exist
# https://cloud.google.com/docs/terraform/resource-management/store-state
PROJECT_ID=$(gcloud config get-value project)
gsutil mb gs://${PROJECT_ID}-tfstate
gsutil versioning set on gs://${PROJECT_ID}-tfstate
```