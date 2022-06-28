output "role_name" {
  description = "agent role name"
  value = aws_iam_role.ecs_agent.name
  sensitive = false
}
