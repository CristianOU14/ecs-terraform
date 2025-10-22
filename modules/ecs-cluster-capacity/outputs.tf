output "capacity_provider_name" {
  description = "Name of the ECS Capacity Provider"
  value       = aws_ecs_capacity_provider.capacity_provider.name
}