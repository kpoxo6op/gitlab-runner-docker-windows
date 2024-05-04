resource "gitlab_project" "project" {
  name             = "GitLab-${var.project_name}"
  description      = "Build an app inside Windows Container"
  visibility_level = "public"
  build_timeout    = "36000"
}

resource "gitlab_user_runner" "runner" {
  runner_type = "project_type"
  project_id  = gitlab_project.project.id
  description = "Runner with Docker for Windows executor"
  tag_list    = ["windows", "docker"]
}

resource "gitlab_repository_file" "pipeline" {
  project        = gitlab_project.project.id
  file_path      = ".gitlab-ci.yml"
  branch         = "main"
  content        = base64encode(file("${path.module}/.gitlab-ci.yml"))
  commit_message = "Init pipeline"
  author_name    = "Terraform"
}
