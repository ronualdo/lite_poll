variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}

variable "database_subnets_ids" {
  description = "list of subnets ids"
  type = list(string)
  sensitive = false
}

variable "database_vpc_id" {
  description = "database vpc id"
  type = string
  sensitive = false
}
