# Security group for control plane
resource "aws_security_group" "control_plane_sg" {
  name   = "k8s-control-plane-sg"
  vpc_id = aws_vpc.kdr_vpc.id

  tags = {
    Name = "k8s-control-plane-sg"
  }
}

# Ingress rule
resource "aws_security_group_rule" "control_plane_ingress" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol          = "tcp"
  cidr_blocks = flatten([var.private_subnet_cidr_blocks, var.public_subnet_cidr_blocks])
}

# Egress rule
resource "aws_security_group_rule" "control_plane_egress" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}