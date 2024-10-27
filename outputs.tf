
output "cli_cmd" { 
    description = "The AWS cli command to connect to your EC2 instance through the connect point"
    value = "aws ec2-instance-connect ssh --instance-id ${module.ec2_instance.id} --os-user ec2-user --connection-type eice"
}

output "instance_id" {
  value = module.ec2_instance.id
}
output "instance_private_ip" {
  value = module.ec2_instance.private_ip
}