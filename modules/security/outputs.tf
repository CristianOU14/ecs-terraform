
output "ecs_sg_id" {
  description = "ID del security group de las instancias ECS"
  value       = aws_security_group.ecs_sg.id
}

