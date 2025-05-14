data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  availability_zone = "${var.aws_region}a"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "app" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.key_name


  depends_on = [aws_security_group.app_sg]

  tags = {
    Name = "${var.project_id}-${var.env}-instance"
  }
}


resource "aws_security_group" "app_sg" {
  name   = "${var.project_id}-${var.env}-app-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
