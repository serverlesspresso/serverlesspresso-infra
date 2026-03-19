output "event_bus_name" {
  description = "EventBridge custom bus name"
  value       = aws_cloudwatch_event_bus.main.name
}

output "event_bus_arn" {
  description = "EventBridge custom bus ARN"
  value       = aws_cloudwatch_event_bus.main.arn
}
