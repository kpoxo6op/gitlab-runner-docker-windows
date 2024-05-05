variable "my_ip_address" {
  description = "The IP address allowed for RDP access"
  type        = string
}

variable "project_name" {
  description = "Google Cloud project name"
  type        = string
  default     = "runner-demo-xxxx"
}

variable "gitlab_token" {
  description = "gitlab personal token"
  type        = string
}

variable "gcp_zone" {
  description = "Google Cloud Zone"
  type        = string
  default     = "australia-southeast1-a"
}

variable "gcp_region" {
  description = "Google Cloud Region"
  type        = string
  default     = "australia-southeast1"
}
