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
