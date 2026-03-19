terraform {
  backend "s3" {
    bucket         = "serverlesspresso-tfstate"
    key            = "serverlesspresso/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "serverlesspresso-tflock"
    encrypt        = true
  }
}
