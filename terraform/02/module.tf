module "web_servers" {
  source                = "./aws_ec2_instance"
  prefix                = var.prefix
  instance_names        = var.instance_names
  region                = var.region
  tags                  = var.tags
  key_name              = aws_key_pair.main.key_name
  vpc_security_group_id = aws_security_group.interrupt_app_module.id
}
