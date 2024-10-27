#######################################################
##  setup VPCs: service_provider_vpc in us-east-1 
#######################################################

module "service_provider_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = var.vpc_cidr

  azs             = local.azs
  # public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 10)]

  enable_nat_gateway = false
  single_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support =  true 

  manage_default_security_group = false
  manage_default_network_acl    = false

  tags = merge(local.common_tags, {
    Name = "${local.name}-vpc"
  })
}


resource "aws_ec2_instance_connect_endpoint" "this" {
  subnet_id  = element(module.service_provider_vpc.private_subnets, 0)
  security_group_ids = [aws_security_group.instance_connect_ep_sg.id]
  
  depends_on = [aws_instance.private_instance]

  tags = local.common_tags
}


