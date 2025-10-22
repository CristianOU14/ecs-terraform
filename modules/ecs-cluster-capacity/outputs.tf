output "capacity_provider_name" {
  description = "Name of the ECS Capacity Provider"
  value       = aws_ecs_capacity_provider.capacity_provider.name
}

output "cluster_capacity_provider_id" {
  description = "ID de la relación entre el cluster y el capacity provider"
  value       = aws_ecs_cluster_capacity_providers.cluster_capacity.id
}