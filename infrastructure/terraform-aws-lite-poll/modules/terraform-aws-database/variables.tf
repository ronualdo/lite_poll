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

variable "vpc_id" {
  description = "vpc id for security group"
  type = string
  sensitive = false
}
