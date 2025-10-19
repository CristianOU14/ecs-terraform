output "alb_sg_id" {
  description = "ID del security group del ALB"
  value       = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  description = "ID del security group de las instancias ECS"
  value       = aws_security_group.ecs_sg.id
}

output "ssh_sg_id" {
  description = "ID del security group para acceso SSH"
  value       = aws_security_group.ssh_sg.id
}
