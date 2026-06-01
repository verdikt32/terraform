output "bastion_sg_id" {
  value = aws_security_group.allow_ssh_on_bastion.id
}

output "private_sg_id" {
  value = aws_security_group.allow_ssh_on_private.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
