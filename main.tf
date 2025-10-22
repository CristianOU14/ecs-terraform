module "vpc" {
  source = "./modules/vpc"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"
}

module "ami" {
  source = "./modules/ami"
}

module "iam" {
  source = "./modules/iam"
}

module "autoscaling" {
  source             = "./modules/auto-scaling"
  ami_id             = module.ami.ecs_ami_id
  instance_type      = "t3.micro"
  subnet_ids         = module.vpc.public_subnets
  security_group_ids = [module.security.ecs_sg_id]
  ecs_cluster_name   = module.ecs_cluster.cluster_name
  iam_profile_arn =module.iam.iam_profile_arn
}

module "ecs_cluster_capacity"{
  source             = "./modules/ecs-cluster-capacity"
  asg_arn            = module.autoscaling.asg_arn
  ecs_cluster_name   = module.ecs_cluster.cluster_name
}

/*
module "task_definition" {
  source = "./modules/task-definition"
}
*/
module "ecr" {
  source = "./modules/ecr"
}
/*
module "ecs_service" {
  source               = "./modules/ecs-service"
  cluster_id           = module.ecs_cluster.cluster_id
  task_definition_arn = module.task_definition.task_definition_arn
  ecs_instance = module.ecs_instance.ecs_instance
}
*/

