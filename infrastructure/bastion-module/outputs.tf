output "key_name" {
  value = aws_key_pair.ssh_key.key_name
}

output "private_security_group_id" {
  value = [aws_security_group.private_security_group.id]
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "bastion_server_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "EC2 instance public ip"
}

output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}