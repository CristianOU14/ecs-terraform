resource "aws_ecs_service" "ecs_service" {
  name            = "ecs-demo-service"
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = 2
  launch_type     = "EC2"
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "myapp-container"
    container_port   = 80
  }
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
  }
  
}
