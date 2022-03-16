resource "aws_ssm_parameter" "nria_license_key" {
  name = "NRIA_LICENSE_KEY"
  type = "String"
  value = "785fc053eb3d762da904ed092d0a1612da0bNRAL"
}
