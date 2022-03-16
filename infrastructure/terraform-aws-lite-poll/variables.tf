variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}

variable "new_relic_config" {
  description = "new relic config information"
  type = object({
    api_key = string
    account_id = string
  })
  sensitive = true
}
