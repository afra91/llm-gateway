module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name            = "llm-gateway-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.0.128/26"]
  private_subnets = ["10.0.0.0/26", "10.0.0.64/26"]

  enable_nat_gateway = true
  single_nat_gateway = true
}
