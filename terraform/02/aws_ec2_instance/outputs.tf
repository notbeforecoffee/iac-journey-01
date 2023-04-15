output "public_urls" {
  value = [for instance in aws_instance.app : "http://${instance.public_ip}"]
}
