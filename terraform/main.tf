terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      version = "~> 3.44.0"
      source  = "hashicorp/aws"
    }
  }
}


provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    route53        = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}


data "aws_caller_identity" "current_identity" {}

data "aws_region" "current_region" {}

variable "environment" {
  default = "local"
}

locals {
  tags = {
    Environment    = var.environment
    Group          = "Fresher Academy 2"
    OwnerEmail     = "longbuivan95@gmail.com"
    PipelineRepo   = "https://github.com/longbuivan/traning.git"
    Workload       = "Mini Project"
  }
  account_id = data.aws_caller_identity.current_identity.account_id
  region     = data.aws_region.current_region.name

}