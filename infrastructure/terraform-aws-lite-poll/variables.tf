variable "new_relic_config" {
  description = "new relic config information"
  type = object({
    api_key = string
    account_id = string
    license_key = string
  })
  sensitive = true
}

variable "aws_config" {
  description = "aws config used to provision infrastructure"
  type = object({
    region = string
    access_key = string
    secret_key = string
  })
  sensitive = true
}

variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}

