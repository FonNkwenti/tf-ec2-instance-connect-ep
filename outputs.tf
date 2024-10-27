output "cmd" { 
    description = "The AWS cli command to connect to your EC2 instance through the connect point"
    value = "aws ec2-instance-connect ssh --instance-id ${aws_instance.private_instance.id} --os-user ec2-user --connection-type eice"
}

output "cli_cmd" { 
    description = "The AWS cli command to connect to your EC2 instance through the connect point"
    value = "aws ec2-instance-connect ssh --instance-id ${module.ec2_instance.id} --os-user ec2-user --connection-type eice"
}

output "instance-id" {
  value = module.ec2_instance.id
}