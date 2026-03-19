output "cognito_user_pool_id" {
  value = module.auth.user_pool_id
}

output "cognito_user_pool_client_id" {
  value = module.auth.user_pool_client_id
}

output "eventbridge_bus_arn" {
  value = module.messaging.event_bus_arn
}

output "dynamodb_orders_table" {
  value = module.database.orders_table_name
}

output "dynamodb_menu_table" {
  value = module.database.menu_table_name
}

output "dynamodb_config_table" {
  value = module.database.config_table_name
}

output "frontend_bucket_name" {
  value = module.frontend.bucket_name
}

output "cloudfront_distribution_id" {
  value = module.frontend.distribution_id
}

output "cloudfront_domain" {
  value = module.frontend.distribution_domain
}

output "iot_endpoint" {
  value = module.iot.iot_endpoint
}

output "lambda_execution_role_arn" {
  value = module.iam.lambda_execution_role_arn
}
