output "license_key_arn" {
  description = "license key ssm parameter arn"
  value = aws_ssm_parameter.nria_license_key.arn
  sensitive = false
}
