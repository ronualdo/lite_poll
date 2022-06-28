output "public_subnets_ids" {
  description = "public subnet identifiers"
  value = [aws_subnet.pub_subnet_a.id, aws_subnet.pub_subnet_b.id]
}

output "vpc_id" {
  description = "vpc identifier"
  value = aws_vpc.vpc.id
}
