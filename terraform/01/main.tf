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
Should solicit the default AWS region from the user. For the
purposes of a demonstration, we are defaulting to us-east-2.
**** **** **** **** **** **** **** **** **** **** **** ****/

provider "aws" {
  region = var.region
}

/**** **** **** **** **** **** **** **** **** **** **** ****
Inherit access the default AWS VPC. We do not plan to create
a dedicated VPC in this exercise.
**** **** **** **** **** **** **** **** **** **** **** ****/

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

/**** **** **** **** **** **** **** **** **** **** **** ****
Create a separate EC2 Security Group to grant ingress and 
egress network traffic to the EC2 instance via the default
Subnet, Internet Gateway and Routing.
**** **** **** **** **** **** **** **** **** **** **** ****/

resource "aws_security_group" "interrupt_app" {
  name        = "interrupt_app"
  description = "Interrupt inbound traffic"
  vpc_id      = aws_default_vpc.default.id
  tags        = merge({ "Name" = "Interrupt App NSG" }, var.tags)
}

/**** **** **** **** **** **** **** **** **** **** **** ****
Explicitly allow all egress traffic for the scurity group. 
The CIDR should be changed to reflect the localized working
environment in the demo platform.
**** **** **** **** **** **** **** **** **** **** **** ****/

resource "aws_security_group_rule" "egress_allow_all" {
  description       = "Allow all outbound traffic."
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.interrupt_app.id
}

/**** **** **** **** **** **** **** **** **** **** **** ****
Explicitly accept SSH traffic.
**** **** **** **** **** **** **** **** **** **** **** ****/

resource "aws_security_group_rule" "allow_ssh" {
  description       = "SSH Connection"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.interrupt_app.id
}

/**** **** **** **** **** **** **** **** **** **** **** ****
Explicitly accept HTTP traffic.
**** **** **** **** **** **** **** **** **** **** **** ****/

resource "aws_security_group_rule" "allow_http" {
  description       = "HTTP Connection"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.interrupt_app.id
}

/**** **** **** **** **** **** **** **** **** **** **** ****
Define a private key pair to access the EC2 instance. Do not
expose the key outside fo the demo platform environment.
**** **** **** **** **** **** **** **** **** **** **** ****/

resource "tls_private_key" "main" {
  algorithm = "RSA"
}

locals {
  private_key_filename = "${var.prefix}-ssh-key"
}

resource "aws_key_pair" "main" {
  key_name   = local.private_key_filename
  public_key = tls_private_key.main.public_key_openssh
}

/**** **** **** **** **** **** **** **** **** **** **** ****
Saving the key locally as an optional use case. It is not 
necessary for the demo sequence and can be omitted.
**** **** **** **** **** **** **** **** **** **** **** ****/

resource "null_resource" "main" {
  provisioner "local-exec" {
    command = "echo \"${tls_private_key.main.private_key_pem}\" > ${var.prefix}-ssh-key.pem"
  }

  provisioner "local-exec" {
    command = "chmod 600 ${var.prefix}-ssh-key.pem"
  }
}
