terraform {
  backend "s3" {
    key    = "common/bastion/terraform.tfstate"
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

variable "domain" {}

data "aws_vpc" "selected" {
  tags = {
    Name = "account-vpc"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags = {
    Type = "public"
  }
}

data "aws_route53_zone" "public" {
  name = "${var.domain}"

  tags = {
    Type = "public"
  }
}

variable "keypair" {
  default = "bastion"
}
