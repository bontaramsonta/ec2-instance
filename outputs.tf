output "ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "subnet_az" {
  value = aws_default_subnet.default.availability_zone
}

output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}
