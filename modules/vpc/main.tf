resource "aws_vpc" "vpc_bastion_private" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Vpc-Bastion-Private"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_bastion_private.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_bastion_private.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private-Subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc_bastion_private.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private-Subnet-2"
  }
}

resource "aws_internet_gateway" "igw_vpc_bastion_private" {
  vpc_id = aws_vpc.vpc_bastion_private.id

  tags = {
    Name = "Igw-Vpc-Bastion-Private"
  }
}

resource "aws_eip" "elastic_ip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw_vpc_bastion_private]

  tags = {
    Name = "Eip-Nat-Bastion-Private"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.igw_vpc_bastion_private]

  tags = {
    Name = "Nat-Gateway-Bastion-Private"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.vpc_bastion_private.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_vpc_bastion_private.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc_bastion_private.id

  tags = {
    Name = "Private-Route-Table"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_bastion_private.id

  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_vpc_bastion_private.id
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_vpc.vpc_bastion_private.main_route_table_id
}

