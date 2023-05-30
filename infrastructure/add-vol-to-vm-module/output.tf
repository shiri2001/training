output "app_volume_id" {
  value = length(aws_ebs_volume.vm_vol) > 0 ? aws_ebs_volume.vm_vol[0].id : ""
}