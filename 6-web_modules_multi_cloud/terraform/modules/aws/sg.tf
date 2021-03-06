resource "aws_security_group" "sg_instance" {
  count       = var.enabled ? 1 : 0
  name        = "${var.name}-sg-instance"
  description = "Allow SSH"
  vpc_id      = aws_vpc.vpc.0.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.sg_whitelist]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg-instance"
  }
}

resource "aws_security_group" "sg_bastion" {
  count       = var.enabled ? 1 : 0
  name        = "${var.name}-sg-bastion"
  description = "Allow SSH Bastion"
  vpc_id      = aws_vpc.vpc.0.id

  tags = {
    Name = "${var.name}-sg-bastion"
  }

  dynamic "ingress" {
    for_each = var.sg_whitelist_ssh
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_nat_instance" {
  count       = var.enabled ? 1 : 0
  name        = "${var.name}-sg-nat-instance"
  description = "NAT GW security Group"
  vpc_id      = aws_vpc.vpc.0.id

  tags = {
    Name = "${var.name}-sg-nat-instance"
  }

  dynamic "ingress" {
    for_each = var.sg_whitelist_ssh
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.subnet_priv.0.cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.subnet_priv.0.cidr]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
