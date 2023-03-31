terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "aws" {
  region = var.region
}

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

data "aws_vpc" "default" {
  default = true
}

data "aws_route_table" "public_route_table" {
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key.pem"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "vpc_security_group" {
  name        = "vpc_security_group"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16", var.input_ip]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_default_subnet" "public_subnet" {
  availability_zone = var.az
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.96.0/20"
  map_public_ip_on_launch = false

}

resource "aws_security_group" "vm_sg" {
  name        = "vm_sg"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.private_subnet.cidr_block}"]
    self        = true
  }
}


resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.default.id

}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_default_subnet.public_subnet.id
  route_table_id = data.aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.my_instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids      = [aws_security_group.vpc_security_group.id]
  associate_public_ip_address = true
  subnet_id                   = aws_default_subnet.public_subnet.id
}

resource "aws_instance" "vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.my_instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids      = [aws_security_group.vm_sg.id]
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.private_subnet.id
  user_data                   = file("mount.sh")
}

resource "aws_route" "gateway_route" {
  route_table_id         = data.aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.default.id
  depends_on             = [data.aws_route_table.public_route_table]
}

resource "aws_security_group_rule" "bastion_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.bastion.public_ip}/32"]
  security_group_id = aws_security_group.vpc_security_group.id
}

resource "aws_ebs_volume" "vm_vol" {
  count             = var.add_disk ? 1 : 0
  availability_zone = aws_instance.vm.availability_zone 
  size              = 5
}

resource "aws_volume_attachment" "ebs_attach_to_vm" {
  count       = var.add_disk ? 1 : 0
  device_name = "/dev/sdh"
  volume_id   = length(aws_ebs_volume.vm_vol) > 0 ? aws_ebs_volume.vm_vol[0].id : ""
  instance_id = aws_instance.vm.id
}

