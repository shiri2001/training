output "public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "EC2 instance public ip"
}

output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "volume_id" {
  value     = length(aws_ebs_volume.vm_vol) > 0 ? aws_ebs_volume.vm_vol[0].id : ""
}