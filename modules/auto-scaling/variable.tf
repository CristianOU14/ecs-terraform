variable "ami_id" {
  description = "AMI ID for ECS instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling Group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for ECS instances"
  type        = list(string)
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster this ASG should connect to"
  type        = string
}

variable "iam_profile_arn" {}