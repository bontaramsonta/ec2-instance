# Configure the AWS Provider
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      "managed_by" = "terraform"
      "region"     = var.region
      "project"    = "roadmap.sh-project-ec2-instance-connect"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20250305"]
  }
}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default" {
  availability_zone = "${var.region}a"
}

resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance-type
  subnet_id                   = aws_default_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  key_name                    = var.key_name != "" ? var.key_name : null
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/userdata.sh.tpl", {
    html_content = file("${path.module}/index.html")
  })
}
