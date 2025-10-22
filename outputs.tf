
output "vpc_id" {
  description = "ID de la VPC principal"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "IDs de las subnets públicas"
  value       = module.vpc.public_subnets
}

output "ecs_sg_id" {
  description = "Security group ID de las instancias ECS"
  value       = module.security.ecs_sg_id
}

output "repository_url" {
  description = "URL del repositorio ECR"
  value       = module.ecr.repository_url
}

output "cluster_id" {
  description = "ID del cluster ECS"
  value       = module.ecs_cluster.cluster_id
}

output "cluster_name" {
  description = "Nombre del cluster ECS"
  value       = module.ecs_cluster.cluster_name
}
/*
output "ecs_service_name" {
  description = "Nombre del servicio ECS creado"
  value       = module.ecs_service.service_name
}
*/
