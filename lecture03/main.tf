################
# PROVIDER
################
provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "ap-northeast-2"
}

################
# DATA
################
data "aws_ssm_parameter" "ubuntu-focal" {
    name = "/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

################
# RESOURCE
################

# INSTANCE
resource "aws_instance" "nginx" {
  ami           = nonsensitive(data.aws_ssm_parameter.ubuntu-focal.value)
  instance_type = "t2.micro"
}