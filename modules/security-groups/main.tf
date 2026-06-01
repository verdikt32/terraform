# Security Group Bastion Host
resource "aws_security_group" "allow_ssh_on_bastion" {
  vpc_id      = var.vpc_id
  name        = "allow_ssh_on_bastion"
  description = "Allow SSH inbound traffic and all outbound traffic"

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_bastion" {
  security_group_id = aws_security_group.allow_ssh_on_bastion.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.ssh_allowed.ip

  tags = {
    Name = var.ssh_allowed.rule_name
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_bastion" {
  security_group_id = aws_security_group.allow_ssh_on_bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# Security Group Private Host
resource "aws_security_group" "allow_ssh_on_private" {
  vpc_id      = var.vpc_id
  name        = "allow_ssh_on_private"
  description = "Allow SSH inbound traffic and all outbound traffic"

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_private" {
  security_group_id            = aws_security_group.allow_ssh_on_private.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.allow_ssh_on_bastion.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_private" {
  security_group_id = aws_security_group.allow_ssh_on_private.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# Security Group RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id
  name   = "rds_postgres_sg"

  tags = {
    Name = "RDS-Postgres-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_private" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.allow_ssh_on_bastion.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}
