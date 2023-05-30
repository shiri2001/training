output "bastion_server_public_ip" {
  value       = module.bastion.bastion_server_public_ip
  description = "EC2 instance public ip"
}

output "private_key" {
  value     = module.bastion.private_key
  sensitive = true
}

output "app_volume_id" {
  value = module.add_vol.app_volume_id
}