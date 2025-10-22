variable "asg_arn" {
  description = "ARn del auto scaling"
  type        = string
}
variable "ecs_cluster_name" {
  description = "Name of the ECS cluster this ASG should connect to"
  type        = string
}