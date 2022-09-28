variable "service_target_group_arn" {
  description = "scaling group arns"
  type = string
  sensitive = false
}

variable "vpc_id" {
  description = "service vpc id"
  type = string
  sensitive = false
}

variable "iam_instance_profile_name" {
  description = "ecs launch config iam instance profile name"
  type = string
  sensitive = false
}

variable "image_repo_url" {
  description = "image repository url that is used by the service"
  type = string
  sensitive = false
}

variable "subnets_ids" {
  description = "identifiers for the subnets to be used by the service"
  type = list(string)
  sensitive = false
}

variable "db_config" {
  description = "database config"
  type = object({
    user = string
    password = string
    host = string
    port = string
  })
  sensitive = true
}

variable "loadbalancer_security_group_id" {
  description = "loadbalancer security group id"
  type = string
  sensitive = false
}

variable "role_arn" {
  description = "role arn"
  type = string
  sensitive = true
}

variable "new_relic_config" {
  description = "new relic config information"
  type = object({
    api_key = string
    account_id = string
  })
  sensitive = true
}
