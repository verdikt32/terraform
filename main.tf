provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

module "security" {
  source = "./modules/security-groups"

  vpc_id      = module.vpc.vpc_id
  ssh_allowed = var.ssh_allowed
}

module "ec2" {
  source = "./modules/ec2"

  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  bastion_sg_id     = module.security.bastion_sg_id
  private_sg_id     = module.security.private_sg_id
  key_name          = "my-key"
}

module "rds" {
  source = "./modules/rds"

  subnet_ids  = [module.vpc.private_subnet_id, module.vpc.private_subnet_2_id]
  sg_id       = module.security.rds_sg_id
  db_name     = "postgres"
  db_user     = "postgres"
  db_password = "postgres"
}
