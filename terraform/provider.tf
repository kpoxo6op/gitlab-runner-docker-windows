terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "16.11.0"
    }
  }
}

provider "google" {
    project = "gitlab-agent-pwsh-tf-state"
    region = "australia-southeast1"
    credentials = "${var.user_home}/infra-admin-key.json"
}

provider "gitlab" {
  token    = "${var.gitlab_token}"
  base_url = "https://gitlab.com/api/v4/"
}
