provider "aws" {
  region = "ap-south-1"
}

# VPC Resource
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Subnet Resource
resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-1"
  }
}

# Security Group Resource
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.main.id

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

# EC2 Instance Resource
resource "aws_instance" "app_server" {
  ami           = "ami-0447a12f28fddb066"  # Replace with the correct AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_1.id
  security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "App_Server"
  }
}
