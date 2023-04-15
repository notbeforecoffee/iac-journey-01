# Create a new instance of the latest Ubuntu on an EC2 instance,
# t2.micro node. We can find more options using the AWS command line:
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

# To build our simple Web application, we need to obtain
# the bootstrap script for Nginx and the Web app. 

data "http" "happy_animals" {
  url = "https://raw.githubusercontent.com/gcastill0/iac-journey-01/main/bash/deploy-app.sh"
}

# We are opting to use an URL for portability so that 
# changes to the bootstrap script do not affect the 
# final deployment.

data "template_file" "happy_animals" {
  template = data.http.happy_animals.response_body
}

# This EC2 instace inherits all of the default values
# from the AWS intrumentation. We are passing a list
# of names to create an instance as part of a group.

resource "aws_instance" "app" {

  for_each = toset(var.instance_names)

  key_name               = aws_key_pair.main.key_name
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.nano"
  vpc_security_group_ids = [aws_security_group.interrupt_app.id]
  user_data              = data.template_file.happy_animals.rendered
  tags                   = merge({ "Name" = "${var.prefix}-${each.key}" }, var.tags)

  lifecycle {
    create_before_destroy = true
  }

}
