output "role_name" {
  description = "agent role name"
  value = aws_iam_role.ecs_agent.name
  sensitive = false
}

output "role_arn" {
  description = "role anr"
  value = aws_iam_role.ecs_agent.arn
  sensitive = false
}
