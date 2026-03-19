# Serverlesspresso Infra — Terraform on AWS

> Terraform modules that provision all AWS infrastructure required by [serverlesspresso-eda](https://github.com/enezihe/serverlesspresso-eda). Deploy this repository first, then use its outputs to configure and deploy the application layer.

---

## What this provisions

```
┌────────────────────────────────────────────────────────────────┐
│                        AWS Account                             │
│                                                                │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │  Networking                                             │  │
│  │  VPC  │  Public Subnet  │  Private Subnet  │  IGW      │  │
│  └─────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────────┐  │
│  │   Auth       │   │   Data       │   │   Messaging      │  │
│  │  Cognito     │   │  DynamoDB    │   │  EventBridge     │  │
│  │  User Pool   │   │  3 Tables    │   │  Custom Bus      │  │
│  └──────────────┘   └──────────────┘   └──────────────────┘  │
│                                                                │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────────┐  │
│  │   Frontend   │   │  Realtime    │   │   Observability  │  │
│  │  S3 Bucket   │   │  IoT Core    │   │  CloudWatch      │  │
│  │  CloudFront  │   │  Policy      │   │  Log Groups      │  │
│  └──────────────┘   └──────────────┘   └──────────────────┘  │
│                                                                │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │  IAM                                                    │  │
│  │  Lambda execution role  │  SAM deploy role  │  CI role  │  │
│  └─────────────────────────────────────────────────────────┘  │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

Remote state is stored in an S3 backend with DynamoDB locking — consistent, auditable, and safe for team collaboration.

---

## Repository structure

```
serverlesspresso-infra/
├── modules/
│   ├── networking/           # VPC, subnets, internet gateway
│   ├── auth/                 # Cognito user pool + app client
│   ├── database/             # DynamoDB tables (orders, menu, config)
│   ├── messaging/            # EventBridge custom bus + rules
│   ├── frontend/             # S3 bucket + CloudFront distribution
│   ├── iot/                  # IoT Core policy + endpoint
│   ├── observability/        # CloudWatch log groups + dashboard
│   └── iam/                  # Lambda, SAM, and CI/CD roles
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
├── backend.tf                # S3 remote state configuration
├── outputs.tf                # Exports consumed by serverlesspresso-eda
└── versions.tf               # Terraform + provider version constraints
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) v1.6+
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured
- An S3 bucket and DynamoDB table for remote state (one-time bootstrap, see below)

---

## Bootstrap — remote state (one time only)

Before the first `terraform init`, create the S3 bucket and DynamoDB lock table:

```bash
# Create state bucket (replace with a unique name)
aws s3api create-bucket \
  --bucket serverlesspresso-tfstate-<YOUR_ACCOUNT_ID> \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket serverlesspresso-tfstate-<YOUR_ACCOUNT_ID> \
  --versioning-configuration Status=Enabled

# Create lock table
aws dynamodb create-table \
  --table-name serverlesspresso-tflock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

Then update `backend.tf` with your bucket name:

```hcl
terraform {
  backend "s3" {
    bucket         = "serverlesspresso-tfstate-<YOUR_ACCOUNT_ID>"
    key            = "serverlesspresso/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "serverlesspresso-tflock"
    encrypt        = true
  }
}
```

---

## Deploy

```bash
cd environments/dev

terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

Terraform will display all resources before applying. Confirm with `yes`.

---

## Outputs

After `terraform apply`, these values are available for the application layer:

```bash
terraform output
```

```
cognito_user_pool_id       = "us-east-1_XXXXXXXXX"
cognito_user_pool_client_id = "XXXXXXXXXXXXXXXXXXXXXXXXXX"
eventbridge_bus_arn        = "arn:aws:events:us-east-1:XXXXXXXXXXXX:event-bus/Serverlesspresso"
dynamodb_orders_table      = "serverlesspresso-orders"
dynamodb_menu_table        = "serverlesspresso-menu"
dynamodb_config_table      = "serverlesspresso-config"
iot_endpoint               = "xxxxxxxxxx-ats.iot.us-east-1.amazonaws.com"
frontend_bucket_name       = "serverlesspresso-frontend-XXXXXXXXXXXX"
cloudfront_distribution_id = "XXXXXXXXXXXXXX"
lambda_execution_role_arn  = "arn:aws:iam::XXXXXXXXXXXX:role/serverlesspresso-lambda-role"
```

Pass these to the application repo:

```bash
terraform output -json > ../../serverlesspresso-eda/backend/infra-outputs.json
```

---

## DynamoDB tables

Three tables are provisioned with on-demand billing (no capacity planning):

| Table | Partition key | Sort key | Purpose |
|---|---|---|---|
| `serverlesspresso-orders` | `pk` (orderId) | `sk` (userId) | Live order state |
| `serverlesspresso-menu` | `pk` (menuId) | — | Coffee menu items |
| `serverlesspresso-config` | `pk` (configKey) | — | Shop open/close, order limits |

Point-in-time recovery (PITR) is enabled on the orders table. Server-side encryption uses the AWS-managed key.

---

## IAM design

Following least-privilege principles, each role grants only the permissions needed:

**Lambda execution role** — can read/write the three DynamoDB tables, publish events to the Serverlesspresso EventBridge bus, connect to IoT Core, and write CloudWatch logs. No `*` actions.

**SAM deploy role** — allows CloudFormation to create/update Lambda, API Gateway, Step Functions, and IAM roles scoped to the serverlesspresso stack. Used by CI/CD.

**GitHub Actions CI role** — assumes the SAM deploy role via OIDC (no long-lived access keys stored in GitHub secrets).

---

## Environments

| Environment | Branch | State key | Notes |
|---|---|---|---|
| `dev` | `develop` | `serverlesspresso/dev/terraform.tfstate` | Free Tier, minimal retention |
| `prod` | `main` | `serverlesspresso/prod/terraform.tfstate` | CloudWatch alarms enabled |

To switch environments:

```bash
cd environments/prod
terraform init
terraform plan
```

---

## Variables

Key variables in `terraform.tfvars`:

```hcl
aws_region             = "us-east-1"
project_name           = "serverlesspresso"
environment            = "dev"
cognito_callback_urls  = ["http://localhost:3000"]
order_limit_per_user   = 1
shop_open_default      = true
```

---

## Destroy

```bash
cd environments/dev
terraform destroy
```

This removes all provisioned resources. The remote state bucket is not destroyed (intentional — it preserves history). Delete it manually if needed:

```bash
aws s3 rb s3://serverlesspresso-tfstate-<YOUR_ACCOUNT_ID> --force
aws dynamodb delete-table --table-name serverlesspresso-tflock
```

---

## Related repository

> This repo provisions **infrastructure only**.
> The application code — Lambda functions, Step Functions workflow, React frontend, SAM template — lives in:
>
> **[github.com/enezihe/serverlesspresso-eda](https://github.com/enezihe/serverlesspresso-eda)**
>
> Deploy this repo first, then deploy the application using the Terraform outputs.

---

## License

MIT-0 — see [LICENSE](./LICENSE)