provider "aws" {
  region = var.region
}

resource "aws_instance" "web" {
  count = var.instance_count
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_ids
  vpc_security_group_ids = [var.security_group]
  user_data = templatefile(var.file, var.variables) ? var.filetype == "template" : file(var.file)
  tags = {
    Name = "${var.env}-web-instnce"
  }
}
