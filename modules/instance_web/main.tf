provider "aws" {
  region = var.region
}

locals {
  variables = {
    l_name = var.last_name
    f_mame = var.first_name
    names = var.names
  }
}


resource "aws_instance" "web" {
  count = var.instance_count
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_ids
  vpc_security_group_ids = [var.security_group]
  user_data = var.filetype == "template" ? templatefile(var.file, local.variables) : file(var.file)
  tags = {
    Name = "${var.env}-web-instnce"
  }
}
