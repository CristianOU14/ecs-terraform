resource "aws_ecs_service" "ecs_service" {
  name            = "ecs-demo-service"
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = 1
  launch_type     = "EC2"
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  depends_on = [var.ecs_instance]
}
