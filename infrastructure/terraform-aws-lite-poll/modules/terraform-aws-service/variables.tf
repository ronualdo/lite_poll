# variable "security_group_ids" {
#   description = "Launch configuration security group"
#   type = list(string)
#   sensitive = false
# }
# 
# variable "vpc_zone_identifiers" {
#   description = "VPC zone identifiers used by autoscaling group"
#   type = list(string)
#   sensitive = false
# }
# 
# variable "scaling_group_arns" {
#   description = "scaling group arns"
#   type = list(string)
#   sensitive = false
# }
# 
# variable "service_target_group_arn" {
#   description = "scaling group arns"
#   type = string
#   sensitive = false
# }

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