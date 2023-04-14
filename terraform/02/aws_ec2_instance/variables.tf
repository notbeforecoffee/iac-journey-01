/**** **** **** **** **** **** **** **** **** **** **** ****
Prefix is here to emulate a required naming convention.
**** **** **** **** **** **** **** **** **** **** **** ****/

variable "prefix" {
  default = "tf-iac-demo"
}

/**** **** **** **** **** **** **** **** **** **** **** ****
Defaulting to US-EAST-2
**** **** **** **** **** **** **** **** **** **** **** ****/

variable "region" {
  default = "us-east-2"
}

/**** **** **** **** **** **** **** **** **** **** **** ****
Default tags used to determine the identity and meta-data 
for the deployment. 
**** **** **** **** **** **** **** **** **** **** **** ****/

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
