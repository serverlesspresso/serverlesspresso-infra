locals {
  project_name = "serverlesspresso"
  environment  = "dev"
  aws_region   = "us-east-1"
}

data "aws_caller_identity" "current" {}

module "networking" {
  source = "../../modules/networking"

  aws_region          = local.aws_region
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

module "auth" {
  source = "../../modules/auth"

  project_name  = local.project_name
  environment   = local.environment
  callback_urls = ["http://localhost:3000"]
  logout_urls   = ["http://localhost:3000"]
}

module "database" {
  source = "../../modules/database"

  project_name = local.project_name
  environment  = local.environment
}

module "messaging" {
  source = "../../modules/messaging"

  project_name = local.project_name
  environment  = local.environment
}

module "iam" {
  source = "../../modules/iam"

  project_name = local.project_name
  environment  = local.environment

  dynamodb_table_arns = [
    module.database.orders_table_arn,
    module.database.menu_table_arn,
    module.database.config_table_arn
  ]

  event_bus_arn = module.messaging.event_bus_arn
}

module "frontend" {
  source = "../../modules/frontend"

  project_name = local.project_name
  environment  = local.environment
  account_id   = data.aws_caller_identity.current.account_id
}

module "iot" {
  source = "../../modules/iot"

  project_name = local.project_name
  environment  = local.environment
  aws_region   = local.aws_region
  account_id   = data.aws_caller_identity.current.account_id
}

module "observability" {
  source = "../../modules/observability"

  project_name       = local.project_name
  environment        = local.environment
  aws_region         = local.aws_region
  log_retention_days = 7
}
