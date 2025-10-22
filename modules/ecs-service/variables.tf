variable "cluster_id" {}
variable "task_definition_arn" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  description = "Lista de IDs de los Security Groups que se asociarán a las instancias ECS"
  type        = list(string)
}
variable "target_group_arn" {
  description = "ARN del target group del ALB"
  type        = string
}