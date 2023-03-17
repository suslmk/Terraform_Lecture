################
# PROVIDER
################

provider "aws" {
  access_key = "xxx"
  secret_key = "xxx"
  region = "ap-northeast-2"
}

################
# DATA
################
data "aws_ssm_parameter" "ami" {
    name = "/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20230207"
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
    ami = nonsensitive(data.aws_ssm_parameter.ami.value)
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet-1.id
    vpc_security_group_ids = [aws_security_group.nginx-sg.id]
}