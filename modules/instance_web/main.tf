provider "aws" {
  region = var.region
}

data "aws_ami_ids" "aws_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  count = var.instance_count
  ami = data.aws_ami_ids.aws_linux.id
  instance_type = var.instance_type
  subnet_id = var.subnet_ids
  vpc_security_group_ids = [var.security_group]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = var.first_name
    l_name = var.last_name
    names  = var.names
  })
  tags = {
    Name = "Web"
  }
}
