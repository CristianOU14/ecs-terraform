resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "ecs-demo-app"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "128"

  container_definitions = jsonencode([
    {
      name      = "myapp-container",
      image     = "756811050716.dkr.ecr.us-east-2.amazonaws.com/iue-rep:latest",
      essential = true,
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
          protocol      = "tcp"
        }
      ]
    }
  ])
}