terraform {
  backend "s3" {
    key    = "common/packer/terraform.tfstate"
    region = "eu-west-1"
  }
}

variable "region" {
  default = "eu-west-1" # Irish region best region!
}

provider "aws" {
  profile = "default"
  region  = "${var.region}"
}

variable "keypair" {}

data "aws_vpc" "selected" {
  tags = {
    Name = "account-vpc"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags = {
    Type = "private"
  }
}

data "aws_security_group" "ssh" {
  name = "ssh-from-bastion"
}
