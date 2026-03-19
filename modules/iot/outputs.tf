output "iot_endpoint" {
  description = "IoT Core endpoint URL"
  value       = data.aws_iot_endpoint.main.endpoint_address
}

output "iot_policy_name" {
  description = "IoT barista policy name"
  value       = aws_iot_policy.barista.name
}
