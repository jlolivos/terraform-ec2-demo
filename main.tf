terraform {
        required_providers {
                aws = {
                        source ="hashicorp/aws"
                        version = "~>5.0"
                }
        }
}

provider "aws" {
        region = "us-east-1"
}

data "aws_security_group" "existing_sg" {
        id = "sg-0c51cf8e3efe6cd32"
}

resource "aws_instance" "demo" {
        ami = "ami-0c02fb55956c7d316"
        instance_type ="t3.micro"
        key_name = aws_key_pair.reused_key.key_name

        vpc_security_group_ids = [
                data.aws_security_group.existing_sg.id
        ]

        tags = {
                Name = "terraform-ec2-demo"
        }
}

resource "aws_key_pair" "reused_key" {
        key_name = "reused-key"
        public_key = file("~/.ssh/terraform-key.pub")
}
