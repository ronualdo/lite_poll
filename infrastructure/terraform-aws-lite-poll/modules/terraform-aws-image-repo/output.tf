output "url" {
  description = "project image repository url"
  value = aws_ecr_repository.lite_poll.repository_url
  sensitive = false
}
