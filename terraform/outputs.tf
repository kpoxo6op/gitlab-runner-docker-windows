output "gitlab_runner_registration_token" {
  value = gitlab_user_runner.runner.token
  sensitive = true
}
