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

resource "aws_security_group" "vpc_security_group" {
  name        = "vpc_security_group"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16", var.input_personal_ip]
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

resource "aws_security_group" "private_security_group" {
  name        = "private_security_group"
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