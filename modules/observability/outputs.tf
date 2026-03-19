output "dashboard_name" {
  description = "CloudWatch dashboard name"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "log_group_order_processor" {
  description = "Order processor log group name"
  value       = aws_cloudwatch_log_group.order_processor.name
}
