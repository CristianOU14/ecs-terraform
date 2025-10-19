variable "subnet_ids" {
  type = list(string)
}

variable "cluster_id" {}
variable "cluster_name" {}
variable "repository_url" {}
variable "alb_target_group_arn" {}
variable "security_group_ids" {
  description = "Lista de IDs de los Security Groups que se asociarán a las instancias ECS"
  type        = list(string)
}