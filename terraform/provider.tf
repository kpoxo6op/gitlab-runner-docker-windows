terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "16.11.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "5.26.0"
    }
  }
}

provider "google" {
    project = var.project_name
    region = var.gcp_region
}

provider "gitlab" {
  base_url = "https://gitlab.com/api/v4/"
}
