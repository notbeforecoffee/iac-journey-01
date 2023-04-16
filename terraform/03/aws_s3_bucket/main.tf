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
Make sure all objects are private. This provides an S3 bucket.
**** **** **** **** **** **** **** **** **** **** **** ****/

resource "aws_s3_bucket" "tf_state" {
  bucket        = var.prefix
  tags          = merge({ "Name" = "${var.prefix}" }, var.tags)
  force_destroy = true
}
