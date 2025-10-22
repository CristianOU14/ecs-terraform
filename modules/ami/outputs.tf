output "ecs_ami_id" {
  description = "ID de la AMI ECS Amazon Linux 2023"
  value = data.aws_ami.ecs.id
}