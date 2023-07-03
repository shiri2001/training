data "aws_vpc" "default" {
  default = true
}

resource "aws_subnet" "private_subnet" {
  count                   = "${length(var.private_subnet)}"
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "${var.private_subnet[count.index]}"
  map_public_ip_on_launch = false
  availability_zone = var.az[count.index]  
    tags = {
    "Name"                            = "private-${var.az[count.index]}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}"  = "owned"
  }
}

resource "aws_security_group" "private_security_group" {
  name        = "private_security_group"
  description = "Allow inbound traffic to k8s ingress"

  ingress {
    description = "allow traffic to ingress port"
    from_port   = 38080
    to_port     = 38080
    protocol    = "tcp"
    cidr_blocks = ["${var.private_subnet}"]
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
