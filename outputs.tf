output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.auth.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  value       = module.auth.user_pool_client_id
}

output "eventbridge_bus_arn" {
  description = "EventBridge custom bus ARN"
  value       = module.messaging.event_bus_arn
}

output "dynamodb_orders_table" {
  description = "DynamoDB orders table name"
  value       = module.database.orders_table_name
}

output "dynamodb_menu_table" {
  description = "DynamoDB menu table name"
  value       = module.database.menu_table_name
}

output "dynamodb_config_table" {
  description = "DynamoDB config table name"
  value       = module.database.config_table_name
}

output "frontend_bucket_name" {
  description = "S3 frontend bucket name"
  value       = module.frontend.bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.frontend.distribution_id
}

output "lambda_execution_role_arn" {
  description = "Lambda execution role ARN"
  value       = module.iam.lambda_execution_role_arn
}
