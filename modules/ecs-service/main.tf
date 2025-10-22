resource "aws_ecs_service" "ecs_service" {
  name            = "ecs-demo-service"
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = 1
  launch_type     = "EC2"
}
