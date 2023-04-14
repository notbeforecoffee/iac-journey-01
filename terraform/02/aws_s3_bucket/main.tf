locals {
  aws_region     = var.region
  s3_bucket_name = var.prefix
  tags           = merge({ "Name" = "${var.prefix}" }, var.tags)
}

/**** **** **** **** **** **** **** **** **** **** **** ****
2023 - Obtain an up-to-date Terraform Provider for AWS.
**** **** **** **** **** **** **** **** **** **** **** ****/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

/**** **** **** **** **** **** **** **** **** **** **** ****
Make sure all objects are private. This provides a S3 bucket.
**** **** **** **** **** **** **** **** **** **** **** ****/

resource "aws_s3_bucket" "mirror" {
  bucket = local.s3_bucket_name
  tags   = local.tags
}
