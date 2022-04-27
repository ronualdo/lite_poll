variable "vpc_id" {
  description = "loadbalance vpc id"
  type = string
  sensitive = false
}

variable "security_groups" {
  description = "loadbalance security groups"
  type = list(string)
  sensitive = false
}

variable "subnets" {
  description = "loadbalancer subnets"
  type = list(string)
  sensitive = false
}
