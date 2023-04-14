# # Create a new instance of the latest Ubuntu on an EC2 instance,
# # t2.micro node. If you are not sure of what you are trying to find,
# # try this using the AWS command line:
# #
# #  aws ec2 describe-images --owners 099720109477 \
# #    --filters "Name=name,Values=*hvm-ssd*bionic*18.04-amd64*" \
# #    --query 'sort_by(Images, &CreationDate)[].Name'
# #
# # aws ec2 describe-images --owners 099720109477 \
# #   --filters "Name=name,Values=*hvm-ssd*focal*20.04-amd64*" \
# #   --query 'sort_by(Images, &CreationDate)[].Name'

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# data "aws_availability_zones" "available" {
#   state = "available"
# }

# resource "aws_instance" "app" {
#   count                  = length(var.instance_names)
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = "t2.micro"
#   key_name               = aws_key_pair.ssh.key_name
#   subnet_id              = aws_subnet.interrupt_public_subnet[count.index].id
#   vpc_security_group_ids = [aws_security_group.interrupt_app.id]
#   depends_on             = [aws_internet_gateway.interrupt_gw]

#   // user_data = templatefile("./init-script.sh", { file_content = "version 1.0 - #${count.index}" })

#   tags = merge({ "Name" = var.instance_names[count.index] }, var.tags)

#   lifecycle {
#     create_before_destroy = true
#   }

# }

# resource "aws_instance" "bastion" {
#   count                  = 1
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = "t2.micro"
#   key_name               = aws_key_pair.ssh.key_name
#   subnet_id              = aws_subnet.interrupt_public_subnet[count.index].id
#   vpc_security_group_ids = [aws_security_group.bastion.id]
#   depends_on             = [aws_internet_gateway.interrupt_gw]

#   tags = merge({ "Name" = "bastion" }, var.tags)

#   lifecycle {
#     create_before_destroy = true
#   }

# }
