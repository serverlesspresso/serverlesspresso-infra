resource "aws_cloudwatch_log_group" "order_processor" {
  name              = "/aws/lambda/${var.project_name}-order-processor-${var.environment}"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_group" "menu_manager" {
  name              = "/aws/lambda/${var.project_name}-menu-manager-${var.environment}"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_group" "count_manager" {
  name              = "/aws/lambda/${var.project_name}-count-manager-${var.environment}"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_group" "config_manager" {
  name              = "/aws/lambda/${var.project_name}-config-manager-${var.environment}"
  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          title  = "Lambda Invocations"
          region = var.aws_region
          period = 300
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", "${var.project_name}-order-processor-${var.environment}"],
            ["AWS/Lambda", "Invocations", "FunctionName", "${var.project_name}-menu-manager-${var.environment}"]
          ]
          view = "timeSeries"
          stat = "Sum"
        }
      },
      {
        type = "metric"
        properties = {
          title  = "Lambda Errors"
          region = var.aws_region
          period = 300
          metrics = [
            ["AWS/Lambda", "Errors", "FunctionName", "${var.project_name}-order-processor-${var.environment}"],
            ["AWS/Lambda", "Errors", "FunctionName", "${var.project_name}-menu-manager-${var.environment}"]
          ]
          view = "timeSeries"
          stat = "Sum"
        }
      },
      {
        type = "metric"
        properties = {
          title  = "DynamoDB Consumed Write Capacity"
          region = var.aws_region
          period = 300
          metrics = [
            ["AWS/DynamoDB", "ConsumedWriteCapacityUnits", "TableName", "${var.project_name}-orders-${var.environment}"]
          ]
          view = "timeSeries"
          stat = "Sum"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.project_name}-lambda-errors-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Lambda error rate exceeded threshold"
}
