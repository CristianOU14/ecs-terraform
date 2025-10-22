output "iam_profile_id" {
  description = "ID del pefil IAM para ECS Amazon Linux 2023"
  value = aws_iam_instance_profile.ecs_instance_profile.id
}
output "iam_profile_arn" {
  description = "ARN del perfil IAM para ECS Amazon Linux 2023"
  value       = aws_iam_instance_profile.ecs_instance_profile.arn
}

output "ecs_task_execution_role" {
  description = "ARN del rol de ejecución de tareas ECS"
  value       = aws_iam_role.ecs_task_execution_role.arn
}