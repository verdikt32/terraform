output "bastion_public_ip" {
  value = aws_instance.bastion_host_instance.public_ip
}

output "private_instance_ip" {
  value = aws_instance.private_host_instance.private_ip
}
