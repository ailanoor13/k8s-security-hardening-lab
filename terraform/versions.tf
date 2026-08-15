terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Billing metrics only exist in us-east-1, regardless of what region
# your actual resources live in — this alias is just for the billing alarm.
provider "aws" {
  alias  = "billing"
  region = "us-east-1"
}
