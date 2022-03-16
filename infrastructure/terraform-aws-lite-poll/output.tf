# output "rds_replica_connection_parameters" {
#   description = "RDS replica instance connection parameters"
#   value = "-h ${module.terraform_aws_database.rds_hostname} -p ${module.terraform_aws_database.rds_port} -U ${module.terraform_aws_database.rds_username} postgres"
#   sensitive = true
# }
# 
# output "dns" {
#   description = "dns"
#   value = module.terraform_aws_loadbalancer.dns_name
# }
output "image_repo_url" {
  description = "project image repository url"
  value = module.terraform_aws_image_repo.url
  sensitive = false
}

output "db_hostname" {
  description = "lite poll database hostname"
  value       = module.terraform_aws_database.hostname
  sensitive   = true
}

output "db_port" {
  description = "lite poll database port"
  value       = module.terraform_aws_database.port
  sensitive   = true
}

output "db_user" {
  description = "lite poll database user"
  value       = module.terraform_aws_database.username
  sensitive   = true
}

output "lite_poll_url" {
  description = "lite poll url"
  value = module.terraform_aws_loadbalancer.dns_name
  sensitive = false
}
