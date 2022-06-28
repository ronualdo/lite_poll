variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}

variable "aws_profile" {
  description = "aws profile name to be used in the infrastructure creation"
  type = string
  sensitive = false
}
