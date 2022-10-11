variable "new_relic_config" {
  description = "new relic config information"
  type = object({
    api_key = string
    account_id = string
    license_key = string
  })
  sensitive = true
}
