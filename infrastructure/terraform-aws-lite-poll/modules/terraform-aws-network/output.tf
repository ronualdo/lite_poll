output "vpc_id" {
  description = "vpc id"
  value = aws_vpc.vpc.id
}

output "database_public_subnets" {
  description = "database public subnets"
  value = [aws_subnet.pub_subnet.id, aws_subnet.pub_subnet_2.id]
}

output "database_security_group_ids" {
  description = "database security group ids"
  value = [aws_security_group.database.id]
}

output "ecs_security_group_id" {
  description = "ecs security group id"
  value = aws_security_group.ecs.id
}

output "pub_subnet_id" {
  description = "pub subnet id"
  value = aws_subnet.pub_subnet.id
}
