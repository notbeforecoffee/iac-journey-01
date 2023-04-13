variable "key_name" {
  default = "interrupt-tmp-key"
}

#variable "ssh_key" {
#}

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
