output "public_instance_ips" {
  value = aws_instance.web[*].public_ip
}

output "private_instance_ips" {
  value = aws_instance.private[*].private_ip
}
