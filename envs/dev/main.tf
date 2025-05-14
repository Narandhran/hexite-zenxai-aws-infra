module "ec2" {
  source        = "../../modules/ec2"
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t3.medium"
  key_name      = "zenxai-key-dev"
  env           = var.env
  aws_region    = var.aws_region
  project_id    = var.project_id
}
