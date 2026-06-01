output "bastion_host_public_ip" {
  value = module.ec2.bastion_public_ip
}

output "private_host_ip" {
  value = module.ec2.private_instance_ip
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
