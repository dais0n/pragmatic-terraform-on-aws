provider "aws" {
  region = "ap-northeast-1"
}

variable "example_instance_type" {
  default = "t3.micro"
}

variable "env" {}

resource "aws_instance" "example" {
  ami = "ami-0f9ae750e8274075b"
  instance_type = var.env == "prod" ? "m5.large" : var.example_instance_type
  vpc_security_group_ids = [aws_security_group.example_ec2.id]

  user_data = data.template_file.httpd_user_data.rendered
}

resource "aws_security_group" "example_ec2" {
  name = "example-ec2"

  ingress {
    from_port   = 80
    to_port     = 80
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

output "example_instance_id" {
  value = aws_instance.example.id
}

data "template_file" "httpd_user_data" {
  template = file("./user_data.sh.tpl")

  vars = {
    package = "httpd"
  }
}