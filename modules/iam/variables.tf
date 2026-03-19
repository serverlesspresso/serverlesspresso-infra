variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "dynamodb_table_arns" {
  description = "List of DynamoDB table ARNs Lambda can access"
  type        = list(string)
}

variable "event_bus_arn" {
  description = "EventBridge custom bus ARN"
  type        = string
}
