output "task_definition_arn" {
  value = aws_ecs_task_definition.nginx_task.arn
}