module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.46.0"

  name = "account-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  assign_generated_ipv6_cidr_block = true

  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnet_tags = {
    Type = "private"
  }

  public_subnet_tags = {
    Type = "public"
  }

  vpc_tags = {
    Name = "account-vpc"
  }
}
