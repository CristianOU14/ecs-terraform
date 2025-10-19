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
  subnets = module.vpc.public_subnets
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs_service" {
  source               = "./modules/ecs-service"
  cluster_id           = module.ecs_cluster.cluster_id
  cluster_name         = module.ecs_cluster.cluster_name
  repository_url       = module.ecr.repository_url
  alb_target_group_arn = module.alb.target_group_arn
  subnet_ids           = module.vpc.public_subnets
  security_group_ids = [
    module.security.ecs_sg_id,
    module.security.ssh_sg_id
  ]
}

