# Create a new instance of the latest Ubuntu on an EC2 instance,
# t2.micro node. If you are not sure of what you are trying to find,
# try this using the AWS command line:
#
#  aws ec2 describe-images --owners 099720109477 \
#    --filters "Name=name,Values=*hvm-ssd*bionic*18.04-amd64*" \
#    --query 'sort_by(Images, &CreationDate)[].Name'
#
# aws ec2 describe-images --owners 099720109477 \
#   --filters "Name=name,Values=*hvm-ssd*focal*20.04-amd64*" \
#   --query 'sort_by(Images, &CreationDate)[].Name'

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "http" "happy_animals" {
  url = "https://raw.githubusercontent.com/gcastill0/iac-journey-01/main/bash/deploy-app.sh"
}

data "template_file" "happy_animals" {
  template = data.http.happy_animals.response_body
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.interrupt_app.id]
  user_data              = data.template_file.happy_animals.rendered
  tags                   = merge({ "Name" = "tf-iac-demo" }, var.tags)

  lifecycle {
    create_before_destroy = true
  }

}

output "public_url" {
  value = "http://${aws_instance.app.public_ip}"
}
