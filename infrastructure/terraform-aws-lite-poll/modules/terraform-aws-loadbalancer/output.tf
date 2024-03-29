output "dns_name" {
  description = "loadbalancer dns name"
  value = aws_alb.default.dns_name
}

output "target_group_arn" {
  description = "loadbalancer target group arn"
  value = aws_alb_target_group.default.arn
}

output "loadbalancer_security_group_id" {
  description = "loadbalancer security group id"
  value = aws_security_group.loadbalancer.id
}
