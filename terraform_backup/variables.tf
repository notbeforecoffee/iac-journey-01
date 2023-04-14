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

variable "instance_names" {
  type    = list(string)
  default = ["nginx1", "nginx2", "nginx3"]
}

variable "private_subnet" {
  type    = list(string)
  default = ["10.168.1.0/24", "10.168.2.0/24", "10.168.3.0/24"]

}

variable "public_subnet" {
  type    = list(string)
  default = ["10.168.101.0/24", "10.168.102.0/24", "10.168.103.0/24"]
}
