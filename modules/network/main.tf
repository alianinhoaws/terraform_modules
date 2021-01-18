
provider "aws" {
  region = var.region
}

locals {
  default_cird = "0.0.0.0/0"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-main-vpc"
  }
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-IGW"
  }
}

#--------subnets---------------
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets_cird)
  cidr_block = element(var.public_subnets_cird, count.index)
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-public-${count.index}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnets_cird)
  cidr_block = element(var.private_subnets_cird, count.index)
  vpc_id = aws_vpc.main.id
    tags = {
    Name = "${var.env}-private-${count.index}"
  }
}

#-------------nat gw---------
resource "aws_eip" "nat_ips" {
  count = length(aws_subnet.private_subnets[*].id)
  vpc = true
  tags = {
    Name = "${var.env}-nat-ips-${count.index}"
  }
}

resource "aws_nat_gateway" "nat_gws" {
  count = length(aws_subnet.private_subnets[*].id)
  allocation_id = aws_eip.nat_ips[count.index].id
  subnet_id = element(aws_subnet.public_subnets[*].id,count.index)
  tags = {
    Name = "${var.env}-nat-gw-${count.index}"
  }
}

#-------------routing tables-----------


resource "aws_route_table" "public_route" {
  route {
    cidr_block = local.default_cird
    gateway_id = aws_internet_gateway.main.id
  }
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "public_route" {
  count = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_route.id
  subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
}


resource "aws_route_table" "private_route" {
  count = length(aws_subnet.private_subnets[*].id)
  vpc_id = aws_vpc.main.id
    route {
    cidr_block = local.default_cird
    gateway_id = element(aws_nat_gateway.nat_gws[*].id, count.index)
  }
}

resource "aws_route_table_association" "private_route" {
  count = length(aws_subnet.private_subnets[*].id)
  route_table_id = element(aws_route_table.private_route[*].id, count.index)
  subnet_id = element(aws_subnet.private_subnets[*].id, count.index)
}

