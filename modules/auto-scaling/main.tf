resource "aws_launch_template" "ecs_launch_template" {
  name_prefix   = "ecs-launch-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = "ecs-key"
  iam_instance_profile {
        arn = var.iam_profile_arn
    }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_group_ids
  }
    user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
echo ECS_BACKEND_HOST=https://ecs.us-east-2.amazonaws.com >> /etc/ecs/ecs.config;
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ECS Instance"
    }
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "ecs-auto-scaling-group"
  vpc_zone_identifier       = var.subnet_ids
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }
  protect_from_scale_in = true
  tag {
    key                 = "Name"
    value               = "ECS Instance"
    propagate_at_launch = true
  }
}