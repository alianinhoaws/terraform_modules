provider "aws" {
  region = var.region
}

resource "aws_security_group" "web" {
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      to_port = ingress.value
      from_port = ingress.value
      protocol = "tcp"
      cidr_blocks = var.cidr_block_ingress
    }
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = var.cidr_block_egress
  }
  tags = {
    Name = "Web"
  }
}
