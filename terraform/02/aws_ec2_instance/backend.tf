terraform {
  backend "s3" {
    bucket = var.prefix
    key    = var.prefix
    region = var.region
  }
}
