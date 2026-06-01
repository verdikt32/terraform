resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "RDS-Subnet-Group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "task11-postgres"

  engine         = "postgres"
  engine_version = "17.6"

  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_user
  password = var.db_password

  port = 5432

  publicly_accessible = false

  vpc_security_group_ids = [var.sg_id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  skip_final_snapshot = true

  tags = {
    Name = "Postgres-RDS"
  }
}
