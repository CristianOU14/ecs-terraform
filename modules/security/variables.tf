variable "vpc_id" {
  description = "ID de la VPC donde se crearán los grupos de seguridad"
  type        = string
}

variable "allow_ssh_from" {
  description = "Lista de rangos CIDR desde los que se permite acceso SSH"
  type        = list(string)
  default     = []
}
