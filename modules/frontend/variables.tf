variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "account_id" {
  description = "AWS account ID for unique bucket naming"
  type        = string
}
