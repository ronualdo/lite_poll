output "database_subnets_ids" {
  description = "database subnets"
  value = [aws_subnet.priv_subnet_a.id, aws_subnet.priv_subnet_b.id]
}

output "database_security_group_ids" {
  description = "database security group ids"
  value = [aws_security_group.database.id]
}

output "service_security_group_ids" {
  description = "ecs security group id"
  value = [aws_security_group.ecs.id]
}

output "service_vpc_zone_identifiers" {
  description = "service _vpc_zone_identifiers"
  value = [aws_subnet.pub_subnet_a.id, aws_subnet.pub_subnet_b.id]
}

output "loadbalancer_vpc_id" {
  description = "loadbalancer vpc id"
  value = aws_vpc.vpc.id
}

output "loadbalancer_security_group_ids" {
  description = "loadbalancer security group ids"
  value = [aws_security_group.alb.id]
}

output "loadbalancer_subnet_ids" {
  description = "loadbalancer subnet ids"
  value = [aws_subnet.pub_subnet_a.id, aws_subnet.pub_subnet_b.id]
}
