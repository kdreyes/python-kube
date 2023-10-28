# VPC Network Setup
resource "aws_vpc" "kdr_vpc" {

  cidr_block       = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_tag_name}"
  }
}

# Private subnet
resource "aws_subnet" "private_subnet" {
  count = length(var.availability_zones)
  vpc_id            = aws_vpc.kdr_vpc.id
  cidr_block = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.private_subnet_tag_name}"
  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  count = length(var.availability_zones)
  vpc_id            = "${aws_vpc.kdr_vpc.id}"
  cidr_block = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.public_subnet_tag_name}"
  }

  map_public_ip_on_launch = true
}

# Internet gateway for the public subnets
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.kdr_vpc.id}"

  tags = {
    Name = "${var.vpc_tag_name}"
  }
}

# Route public subnet traffic through internet gateway
resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.kdr_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags = {
    Name = "${var.route_table_tag_name}"
  }
}

# Route table and subnet associations
resource "aws_route_table_association" "internet_access" {
  count = length(var.availability_zones)
  subnet_id      = "${aws_subnet.public_subnet[count.index].id}"
  route_table_id = "${aws_route_table.route_table.id}"
}