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

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "pub_subnet_a" {
  subnet_id = aws_subnet.pub_subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub_subnet_b" {
  subnet_id = aws_subnet.pub_subnet_b.id
  route_table_id = aws_route_table.public.id
}
