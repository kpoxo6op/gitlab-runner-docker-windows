resource "gitlab_project" "project" {
  name = "sample project"
  description = "gcp pwsh runner"
  visibility_level = "public"
}

resource "gitlab_user_runner" "runner" {
  runner_type = "project_type"
  project_id = gitlab_project.project.id
  description = "build project on gcp vm in docker"
  tag_list = ["windows","docker"]
}
