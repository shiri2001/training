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
}

resource "aws_default_subnet" "public_subnet" {
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.96.0/20"
  map_public_ip_on_launch = false

}

resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.default.id

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
  vpc_security_group_ids      = [aws_security_group.vpc_security_group.id]
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.private_subnet.id
}

resource "aws_route" "personal_ip_route" {
  route_table_id         = data.aws_route_table.public_route_table.id
  destination_cidr_block = var.input_ip
  gateway_id             = data.aws_internet_gateway.default.id
  depends_on             = [data.aws_route_table.public_route_table]
}

