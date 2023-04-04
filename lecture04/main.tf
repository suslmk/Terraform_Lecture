################
# PROVIDER
################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.1.0"
    }
  }

  required_version = "~> 1.3.9"
}

provider "aws" {
  access_key = ""
  secret_key = ""
  region = "ap-northeast-2"
}

################
# DATA
################
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

################
# RESOURCE
################

# NETWORK
resource "aws_vpc" "vpc" {
  cidr_block = "172.32.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet-1" {
    cidr_block = "172.32.0.0/24"
    vpc_id = aws_vpc.vpc.id
    availability_zone = "ap-northeast-2a"   # t2.micro 유형은 2a, 2c zone에서만 생성 가능하다.
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id =  aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rta-subnet-1" {
    subnet_id = aws_subnet.subnet-1.id
    route_table_id = aws_route_table.rt.id
}

# SECURITY GROUPS
resource "aws_security_group" "nginx-sg" {
    name = "nginx-sg"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

# INSTANCE
resource "aws_instance" "nginx-1" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet-1.id
    vpc_security_group_ids = [aws_security_group.nginx-sg.id]
}