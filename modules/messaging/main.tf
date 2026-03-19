resource "aws_cloudwatch_event_bus" "main" {
  name = "${var.project_name}-${var.environment}"
}

resource "aws_cloudwatch_event_rule" "order_placed" {
  name           = "${var.project_name}-order-placed-${var.environment}"
  event_bus_name = aws_cloudwatch_event_bus.main.name

  event_pattern = jsonencode({
    source      = ["orderProcessor"]
    detail-type = ["OrderPlaced"]
  })
}

resource "aws_cloudwatch_event_rule" "order_completed" {
  name           = "${var.project_name}-order-completed-${var.environment}"
  event_bus_name = aws_cloudwatch_event_bus.main.name

  event_pattern = jsonencode({
    source      = ["orderManager"]
    detail-type = ["OrderCompleted"]
  })
}

resource "aws_cloudwatch_event_rule" "order_cancelled" {
  name           = "${var.project_name}-order-cancelled-${var.environment}"
  event_bus_name = aws_cloudwatch_event_bus.main.name

  event_pattern = jsonencode({
    source      = ["orderManager"]
    detail-type = ["OrderCancelled"]
  })
}

resource "aws_cloudwatch_event_rule" "shop_status" {
  name           = "${var.project_name}-shop-status-${var.environment}"
  event_bus_name = aws_cloudwatch_event_bus.main.name

  event_pattern = jsonencode({
    source      = ["configManager"]
    detail-type = ["ShopOpened", "ShopClosed"]
  })
}
