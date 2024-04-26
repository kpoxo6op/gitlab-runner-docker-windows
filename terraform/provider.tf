provider "google" {
    project = "gitlab-agent-pwsh-tf-state"
    region = "australia-southeast1"
    credentials = "${var.user_home}/infra-admin-key.json"
}
