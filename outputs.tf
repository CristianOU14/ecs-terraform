
output "vpc_id" {
  description = "ID de la VPC principal"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "IDs de las subnets públicas"
  value       = module.vpc.public_subnets
}

output "alb_sg_id" {
  description = "Security group ID del ALB"
  value       = module.security.alb_sg_id
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


output "load_balancer_dns" {
  description = "DNS público del Application Load Balancer"
  value       = module.alb.alb_dns
}

output "target_group_arn" {
  description = "ARN del Target Group usado por el ECS Service"
  value       = module.alb.target_group_arn
}

output "ecs_service_name" {
  description = "Nombre del servicio ECS creado"
  value       = module.ecs_service.service_name
}
