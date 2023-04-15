output "public_url" {
  value = [for instance in aws_instance.app : instance.public_ip]
}
