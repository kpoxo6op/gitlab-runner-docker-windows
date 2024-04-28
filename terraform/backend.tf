# https://cloud.google.com/docs/terraform/resource-management/store-state
# STATE MUST BE ENCRYPTED AS it contains secrets
terraform {
    backend "gcs" {
      #  That bucket name is taken. Try another.
      bucket = "gitlab-agent-pwsh-tf-state-tfstate"
      prefix = "terraform/state"
      # using GOOGLE_APPLICATION_CREDENTIALS ennvar
      # credentials =
    }
}
