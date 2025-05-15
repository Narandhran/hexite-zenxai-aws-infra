output "instance_id" {
  value = aws_instance.app.id
}

output "sg_id" {
  value = aws_security_group.app_sg.id
}
