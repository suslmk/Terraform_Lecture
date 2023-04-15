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