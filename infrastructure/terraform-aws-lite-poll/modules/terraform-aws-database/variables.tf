variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}

variable "public_subnets" {
  description = "subnet for the database"
  type = list(string)
  sensitive = false
}

variable "security_group_ids" {
  description = "rds security group ids"
  type = list(string)
  sensitive = false
}
