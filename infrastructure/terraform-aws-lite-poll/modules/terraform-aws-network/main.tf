data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/20"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id 
}

resource "aws_subnet" "pub_subnet_a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/22"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "pub_subnet_b" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.4.0/22"
  availability_zone = "us-west-2b"
}

resource "aws_subnet" "priv_subnet_a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.8.0/22"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "priv_subnet_b" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.12.0/22"
  availability_zone = "us-west-2b"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table_association" "pub_subnet_a" {
  subnet_id = aws_subnet.pub_subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub_subnet_b" {
  subnet_id = aws_subnet.pub_subnet_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "priv_subnet_a" {
  subnet_id = aws_subnet.priv_subnet_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "priv_subnet_b" {
  subnet_id = aws_subnet.priv_subnet_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "ecs" {
  name = "lite_poll_ecs"
  vpc_id = aws_vpc.vpc.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port       = 0
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    to_port         = 65535
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "database" {
  name   = "lite_poll_rds"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lite_poll_rds"
  }
}

resource "aws_security_group" "alb" {
  description = "security_group_alb"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  name = "security_group_alb"

  tags = {
    Env  = "production"
    Name = "security-group--alb"
  }

  vpc_id = aws_vpc.vpc.id
}

