output "rds_replica_connection_parameters" {
  description = "RDS replica instance connection parameters"
  value = "-h ${module.terraform_aws_database.rds_hostname} -p ${module.terraform_aws_database.rds_port} -U ${module.terraform_aws_database.rds_username} postgres"
  sensitive = true
}

output "dns" {
  description = "dns"
  value = module.terraform_aws_loadbalancer.dns_name
}
