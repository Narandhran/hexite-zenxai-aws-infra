variable "project_id" {}
variable "env" {}
variable "aws_region" {}
variable "ec2_sg_id" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
variable "instance_class" { default = "db.t3.micro" }
variable "publicly_accessible" { default = false }
variable "allowed_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks allowed to connect to RDS"
}
