resource "aws_iot_policy" "barista" {
  name = "${var.project_name}-barista-policy-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["iot:Connect"]
        Resource = "arn:aws:iot:${var.aws_region}:${var.account_id}:client/*"
      },
      {
        Effect   = "Allow"
        Action   = ["iot:Subscribe"]
        Resource = "arn:aws:iot:${var.aws_region}:${var.account_id}:topicfilter/${var.project_name}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["iot:Receive"]
        Resource = "arn:aws:iot:${var.aws_region}:${var.account_id}:topic/${var.project_name}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["iot:Publish"]
        Resource = "arn:aws:iot:${var.aws_region}:${var.account_id}:topic/${var.project_name}/*"
      }
    ]
  })
}

data "aws_iot_endpoint" "main" {
  endpoint_type = "iot:Data-ATS"
}
