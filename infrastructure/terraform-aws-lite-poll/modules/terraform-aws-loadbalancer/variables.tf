variable "vpc_id" {
  description = "loadbalance vpc id"
  type = string
  sensitive = false
}

variable "subnets_ids" {
  description = "loadbalancer subnets"
  type = list(string)
  sensitive = false
}
