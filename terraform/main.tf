terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "interrupt_app" {
  name        = "interrupt_app"
  description = "Interrupt inbound traffic"
  vpc_id      = aws_default_vpc.default.id
  tags        = merge({ "Name" = "Interrupt App NSG" }, var.tags)
}

resource "aws_security_group_rule" "egress_allow_all" {
  description       = "Allow all outbound traffic."
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.interrupt_app.id
}

resource "aws_security_group_rule" "allow_ssh" {
  description       = "SSH Connection"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.interrupt_app.id
}

resource "aws_security_group_rule" "allow_http" {
  description       = "HTTP Connection"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.interrupt_app.id
}

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

resource "null_resource" "main" {
  provisioner "local-exec" {
    command = "echo \"${tls_private_key.main.private_key_pem}\" > ${var.prefix}-ssh-key.pem"
  }

  provisioner "local-exec" {
    command = "chmod 600 ${var.prefix}-ssh-key.pem"
  }
}
