################
# PROVIDER
################

terraform {
    required_providers {
       aws = {
        source = "hashicorp/aws"
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