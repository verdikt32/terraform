resource "aws_instance" "bastion_host_instance" {
  subnet_id                   = var.public_subnet_id
  ami                         = data.aws_ami.latest_ubuntu_24_LTS_arm64.id
  instance_type               = "t4g.nano"
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = var.key_name
  user_data                   = <<EOF
  #!/bin/bash
  sudo apt update
  sudo apt install postgresql-client -y
  EOF

  tags = {
    Name = "Bastion-Host-Instance"
  }
}

resource "aws_instance" "private_host_instance" {
  subnet_id              = var.private_subnet_id
  ami                    = data.aws_ami.latest_ubuntu_24_LTS_arm64.id
  instance_type          = "t4g.nano"
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name

  tags = {
    Name = "Private-Host-Instance"
  }
}
