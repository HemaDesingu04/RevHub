terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "revhub_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "revhub_igw" {
  vpc_id = aws_vpc.revhub_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnet
resource "aws_subnet" "revhub_public_subnet" {
  vpc_id                  = aws_vpc.revhub_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "revhub_public_rt" {
  vpc_id = aws_vpc.revhub_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.revhub_igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "revhub_public_rta" {
  subnet_id      = aws_subnet.revhub_public_subnet.id
  route_table_id = aws_route_table.revhub_public_rt.id
}

# Security Group
resource "aws_security_group" "revhub_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for RevHub application"
  vpc_id      = aws_vpc.revhub_vpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Frontend
  ingress {
    from_port   = 4200
    to_port     = 4205
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # API Gateway
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Microservices
  ingress {
    from_port   = 8081
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Consul
  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Database ports (for external access if needed)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# EC2 Instance
resource "aws_instance" "revhub_instance" {
  ami                    = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2023 for ap-south-1
  instance_type          = var.instance_type
  key_name              = var.key_name
  vpc_security_group_ids = [aws_security_group.revhub_sg.id]
  subnet_id             = aws_subnet.revhub_public_subnet.id

  root_block_device {
    volume_type = "gp3"
    volume_size = 30
    encrypted   = true
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {}))

  tags = {
    Name = "${var.project_name}-instance"
  }
}

# Elastic IP
resource "aws_eip" "revhub_eip" {
  instance = aws_instance.revhub_instance.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
}