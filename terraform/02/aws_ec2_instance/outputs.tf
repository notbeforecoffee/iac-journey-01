output "public_url" {
  value = "http://${aws_instance.app.public_ip}"
}
