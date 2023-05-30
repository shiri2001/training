resource "aws_ebs_volume" "vm_vol" {
  count             = var.add_disk ? 1 : 0
  availability_zone = var.vm_availability_zone
  size              = 5
}

resource "aws_volume_attachment" "ebs_attach_to_vm" {
  count       = var.add_disk ? 1 : 0
  device_name = "/dev/sdh"
  volume_id   = length(aws_ebs_volume.vm_vol) > 0 ? aws_ebs_volume.vm_vol[0].id : ""
  instance_id = var.vm_id
}
