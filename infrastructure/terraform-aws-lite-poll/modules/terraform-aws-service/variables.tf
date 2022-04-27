variable "security_group_ids" {
  description = "Launch configuration security group"
  type = list(string)
  sensitive = false
}

variable "vpc_zone_identifiers" {
  description = "VPC zone identifiers used by autoscaling group"
  type = list(string)
  sensitive = false
}

variable "scaling_group_arns" {
  description = "scaling group arns"
  type = list(string)
  sensitive = false
}

variable "service_target_group_arn" {
  description = "scaling group arns"
  type = string
  sensitive = false
}
