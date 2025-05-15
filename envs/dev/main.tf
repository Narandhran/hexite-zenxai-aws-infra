#EC2 instance
module "ec2" {
  source        = "../../modules/ec2"
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t3.medium"
  key_name      = "zenxai-key-dev"
  env           = var.env
  aws_region    = var.aws_region
  project_id    = var.project_id
  alb_sg_id     = module.alb.alb_sg_id
}

#RDS
module "rds" {
  source              = "../../modules/rds"
  aws_region          = var.aws_region
  project_id          = var.project_id
  env                 = var.env
  ec2_sg_id           = module.ec2.sg_id
  db_name             = var.rds_name
  db_user             = var.rds_user
  db_password         = var.rds_password
  instance_class      = var.rds_instance_class
  publicly_accessible = true
  allowed_cidrs       = ["0.0.0.0/0"] # Replace with your public IP
}

#Redis cache
module "redis" {
  source     = "../../modules/redis"
  aws_region = var.aws_region
  project_id = var.project_id
  env        = var.env
  ec2_sg_id  = module.ec2.sg_id
  node_type  = "cache.t4g.small"
}

#Application load balancer
module "alb" {
  source          = "../../modules/alb"
  project_id      = var.project_id
  env             = var.env
  aws_region      = var.aws_region
  ec2_instance_id = module.ec2.instance_id
}
