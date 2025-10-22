module "vpc" {
  source = "./modules/vpc"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
  allow_ssh_from = var.allow_ssh_from
}

module "alb" {
  source  = "./modules/alb"
  vpc_id  = module.vpc.vpc_id
  alb_sg_id = module.security.alb_sg_id
  subnets = module.vpc.public_subnets
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
  security_group_ids = [module.security.ecs_sg_id, module.security.ssh_sg_id]
  ecs_cluster_name   = module.ecs_cluster.cluster_name
  iam_profile_arn =module.iam.iam_profile_arn
  target_group_arn = module.alb.target_group_arn
}

module "ecs_cluster_capacity"{
  source             = "./modules/ecs-cluster-capacity"
  asg_arn            = module.autoscaling.asg_arn
  ecs_cluster_name   = module.ecs_cluster.cluster_name
}


module "task_definition" {
  source = "./modules/task-definition"
  ecs_task_execution_role = module.iam.ecs_task_execution_role
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs_service" {
  source               = "./modules/ecs-service"
  cluster_id           = module.ecs_cluster.cluster_id
  task_definition_arn = module.task_definition.task_definition_arn
  security_group_ids = [module.security.ecs_sg_id, module.security.ssh_sg_id]
  subnet_ids         = module.vpc.public_subnets
  target_group_arn = module.alb.target_group_arn
  depends_on = [module.autoscaling, module.alb  ]
}


