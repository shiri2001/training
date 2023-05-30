data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.app_instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.private_security_group_id
  associate_public_ip_address = false
  subnet_id                   = var.private_subnet_id
  user_data                   = templatefile("./mount.sh", { VOLUME_PATH = "/apps/volume/new-vol" })
}