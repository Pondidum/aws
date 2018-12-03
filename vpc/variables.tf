terraform {
  backend "s3" {
    key    = "common/vpc/terraform.tfstate"
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
