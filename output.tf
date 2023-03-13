output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "EC2 instance public ip"
}

output "private_key" {
  value     = tls_private_key.my_key.private_key_pem
  sensitive = true
}