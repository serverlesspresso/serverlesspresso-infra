output "orders_table_name" {
  description = "Orders DynamoDB table name"
  value       = aws_dynamodb_table.orders.name
}

output "orders_table_arn" {
  description = "Orders DynamoDB table ARN"
  value       = aws_dynamodb_table.orders.arn
}

output "menu_table_name" {
  description = "Menu DynamoDB table name"
  value       = aws_dynamodb_table.menu.name
}

output "menu_table_arn" {
  description = "Menu DynamoDB table ARN"
  value       = aws_dynamodb_table.menu.arn
}

output "config_table_name" {
  description = "Config DynamoDB table name"
  value       = aws_dynamodb_table.config.name
}

output "config_table_arn" {
  description = "Config DynamoDB table ARN"
  value       = aws_dynamodb_table.config.arn
}

output "counting_table_name" {
  description = "Counting DynamoDB table name"
  value       = aws_dynamodb_table.counting.name
}

output "counting_table_arn" {
  description = "Counting DynamoDB table ARN"
  value       = aws_dynamodb_table.counting.arn
}

output "validator_table_name" {
  description = "Validator DynamoDB table name"
  value       = aws_dynamodb_table.validator.name
}

output "validator_table_arn" {
  description = "Validator DynamoDB table ARN"
  value       = aws_dynamodb_table.validator.arn
}