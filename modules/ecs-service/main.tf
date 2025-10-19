# --- AMI optimizada para ECS ---
data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-2023.0.20251015-kernel-6.1-x86_64"]
  }
}

# --- Rol IAM para permitir que las instancias se registren en ECS ---
resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach_ecr" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}


# --- Instancias EC2 para ECS ---
resource "aws_instance" "ecs_instance" {
  count                       = length(var.subnet_ids)
  ami                         = data.aws_ami.ecs.id
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_ids[count.index]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ecs_instance_profile.id
  key_name                    = "ecs-key"
  depends_on                  = [aws_iam_instance_profile.ecs_instance_profile]
  vpc_security_group_ids      = var.security_group_ids
  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_BACKEND_HOST=https://ecs.us-east-2.amazonaws.com >> /etc/ecs/ecs.config;
echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config;
echo "ECS_ENABLE_TASK_IAM_ROLE=true" >> /etc/ecs/ecs.config;
echo "ECS_ENABLE_CONTAINER_METADATA=true" >> /etc/ecs/ecs.config;
systemctl daemon-reload
systemctl enable ecs
systemctl restart ecs
EOF
  )

  tags = {
    Name = "ecs-demo-instance-${count.index}"
  }
}


# --- Task Definition ---
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
          hostPort      = 0,
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# --- Servicio ECS ---
resource "aws_ecs_service" "ecs_service" {
  name            = "ecs-demo-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.nginx_task.arn 
  desired_count   = 2
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "myapp-container"
    container_port   = 80
  }

  depends_on = [aws_instance.ecs_instance]
}
