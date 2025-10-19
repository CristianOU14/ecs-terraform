resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Permite trafico HTTP hacia el ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP desde cualquier lugar"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-instance-security-group"
  description = "Permite trafico interno desde ALB hacia ECS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP desde el ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-instance-security-group"
  }
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh-access-security-group"
  description = "Permite acceso SSH a instancias ECS"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH desde rangos permitidos"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh_from
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-access-security-group"
  }
}
