# Elastic IP
resource "aws_eip" "eip" {
  vpc              = true
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "NAT Gateway for Custom Kubernetes Cluster"
  }
}

# Add route to route table
resource "aws_route" "main" {
  route_table_id            = aws_vpc.kdr_vpc.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}