output "iam_profile_id" {
  description = "ID del pefil IAM para ECS Amazon Linux 2023"
  value = aws_iam_instance_profile.ecs_instance_profile.id
}
output "iam_profile_arn" {
  description = "ARN del perfil IAM para ECS Amazon Linux 2023"
  value       = aws_iam_instance_profile.ecs_instance_profile.arn
}