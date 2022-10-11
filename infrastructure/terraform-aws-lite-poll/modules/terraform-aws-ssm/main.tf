resource "aws_ssm_parameter" "nria_license_key" {
  name = "NRIA_LICENSE_KEY"
  type = "String"
  value = var.new_relic_config.license_key
}
