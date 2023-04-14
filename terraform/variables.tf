variable "prefix" {
  default = "tf-iac-demo"
}

variable "region" {
  default = "us-east-2"
}

variable "private_subnet_cidr" {
  default = "10.2.0.0/32"
}

variable "public_subnet_cidr" {
  default = "10.3.0.0/32"
}

variable "tags" {
  type = map(any)

  default = {
    Organization = "Interrupt Software"
    DoNotDelete  = "True"
    Keep         = "True"
    Owner        = "gilberto@hashicorp.com"
    Region       = "US-EAST-2"
    Purpose      = "York University Lecture"
    TTL          = "168"
    Terraform    = "true"
    TFE          = "false"
    TFE_Worspace = "null"
  }
}
