variable "my_ip_address" {
  description = "The IP address allowed for RDP access"
  type        = string
}

variable "project_name" {
  description = "Google Cloud project name"
  type = string
  default = "runner-demo-xxxx"
}

variable "gitlab_token" {
  description = "gitlab personal token"
  type        = string
}
