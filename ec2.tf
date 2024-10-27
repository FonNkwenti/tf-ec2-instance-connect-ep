resource "aws_instance" "private_instance" {
  ami                    = local.ami
  instance_type          = "t2.micro"
  subnet_id              = element(module.service_provider_vpc.private_subnets, 0)
  associate_public_ip_address = false
  key_name = var.ssh_key_pair
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  tags = merge(local.common_tags, {
    Name = local.instance_name
  })
}

resource "aws_ec2_instance_connect_endpoint" "this" {
  subnet_id  = element(module.service_provider_vpc.private_subnets, 0)
  security_group_ids = [aws_security_group.instance_connect_ep_sg.id]
  
  depends_on = [aws_instance.private_instance]

  tags = local.common_tags
}

resource "aws_security_group" "instance_sg" {
  name        = "private_instance_sg"
  description = "Allow SSH from instance connect endpoint"
  vpc_id      = module.service_provider_vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.instance_connect_ep_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance_connect_ep_sg" {
  name        = "instance_connect_ep_sg"
  description = "allow traffic to endpoint from private subnet instances"
  vpc_id      = module.service_provider_vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = module.service_provider_vpc.private_subnets_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

