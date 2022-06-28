output "hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.lite_poll.address
  sensitive   = true
}

output "port" {
  description = "RDS instance port"
  value       = aws_db_instance.lite_poll.port
  sensitive   = true
}

output "username" {
  description = "RDS instance root username"
  value       = aws_db_instance.lite_poll.username
  sensitive   = true
}
