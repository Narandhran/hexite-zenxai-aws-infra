data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
  # availability_zone = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project_id}-${var.env}-rds-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "${var.project_id}-${var.env}-rds-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "${var.project_id}-${var.env}-rds-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description     = "Allow ECS app access"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ec2_sg_id] # allow access from ECS app
  }

  ingress {
    description = "Allow local machine access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs # e.g., ["YOUR_PUBLIC_IP/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_id}-${var.env}-rds-sg"
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "${var.project_id}-${var.env}-rds"
  engine                 = "postgres" # or "mysql"
  instance_class         = var.instance_class
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = var.publicly_accessible

  tags = {
    Name = "${var.project_id}-${var.env}-rds"
  }
}
