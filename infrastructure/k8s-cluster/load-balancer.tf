resource "aws_security_group" "k8s-lb_security_group" {
  name        = "k8s-lb_security_group"
  description = "Allow inbound traffic from client to lb"
  ingress {
    description = "allow http traffic to lb"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.client_ip}"]
  }
}


resource "aws_lb" "k8s-cluster-lb" {
  name               = "k8s-cluster-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.k8s-lb_security_group.id]
  subnets            = [for subnet in module.private_subnet.private_subnet_blocks : subnet.id]

}