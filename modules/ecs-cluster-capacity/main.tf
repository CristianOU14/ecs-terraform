resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.asg_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity            = 100
      minimum_scaling_step_size  = 1
      maximum_scaling_step_size  = 10
      instance_warmup_period     = 300
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity" {
  cluster_name = var.ecs_cluster_name

  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
    weight            = 1
    base              = 1
  }

  depends_on = [aws_ecs_capacity_provider.capacity_provider]
}