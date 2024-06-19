# Create A VPC IPv4_Cidr_block
resource "aws_vpc" "cus_vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = var.tags
}

# Create Internet Gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.cus_vpc.id

  tags = var.tags
}

# attachment Internet Gateway 
resource "aws_internet_gateway_attachment" "example" {
  internet_gateway_id = aws_internet_gateway.gw.id
  vpc_id              = aws_vpc.cus_vpc.id
}

# assign cidr_blocks for subnets
locals {
  subnets = {
    "1a" = { "public_cidr": "${cidrsubnet(var.cidr_block, 8, 0)}", "private_cidr": "${cidrsubnet(var.cidr_block, 8, 1)}","eip":"", "nat":"" }
    "1b" = { "public_cidr": "${cidrsubnet(var.cidr_block, 8, 2)}", "private_cidr": "${cidrsubnet(var.cidr_block, 8, 3)}","eip":"", "nat":""}
  }
}

# Assign Public Subnet 
resource "aws_subnet" "public" {
  for_each = local.subnets
  vpc_id     = "${aws_vpc.cus_vpc.id}"
  cidr_block = each.value["public_cidr"]

  tags = {
    Name = "Public-${each.key}"
  }
}

# Assign Public Subnet
resource "aws_subnet" "private" {
  for_each = local.subnets
  vpc_id     = "${aws_vpc.cus_vpc.id}"
  cidr_block = each.value["private_cidr"]

  tags = {
    Name = "Private-${each.key}"
  }
}

# Create Elastic IP
resource "aws_eip" "nat_ip" {
  for_each = local.subnets
  domain   = "vpc"
  tags = {
    Name = "eip-${each.key}"
  }
}

# create NAT gateway in Public subnets 
resource "aws_nat_gateway" "nat_gw" {
  depends_on    = [aws_internet_gateway.gw]
  for_each      = local.subnets
  allocation_id = aws_eip.nat_ip[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags = {
    Name        = "nat-${each.key}"
  }
}

#**************************************#

# assosate route table
resource "aws_route_table" "public" {
  for_each      = local.subnets
  vpc_id = aws_vpc.cus_vpc.id

  route {
    cidr_block = var.allow_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = var.tags
}

resource "aws_route_table" "private" {
  for_each      = local.subnets
  vpc_id = aws_vpc.cus_vpc.id
  route {
    cidr_block = var.allow_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gw[each.key].id
  }
  tags = var.tags
}

#**************************************#

# association to public subnet
resource "aws_route_table_association" "public" {
  for_each       = local.subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

# association to private subnet
resource "aws_route_table_association" "private" {
  for_each       = local.subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}


#**************************************#

resource "aws_instance" "web" {
  for_each       = local.subnets
  subnet_id      = aws_subnet.private[each.key].id
  ami           = data.aws_ami.amazon.id
  instance_type = var.instance_type
  key_name               = var.key_name
  tags = {
    Name        = "web-${each.key}"
  }
}
#**************************************#
# create public instance 
resource "aws_instance" "public" {
  for_each       = local.subnets
  ami                  = data.aws_ami.amazon.id
  instance_type        = var.instance_type
  vpc_security_group_ids = [aws_security_group.terra-public-sg.id]
  subnet_id                   = aws_subnet.public["1a"].id
  associate_public_ip_address = var.associate_public_ip_address
  key_name               = var.key_name
 tags = {
    Name = "public-${each.key}"
  }

}

#**************************************#

# create public instance 
resource "aws_instance" "private" {
  for_each       = local.subnets
  ami                  = data.aws_ami.amazon.id
  instance_type        = var.instance_type
  vpc_security_group_ids = [aws_security_group.terra-private-sg.id]
  subnet_id                   = aws_subnet.public["1a"].id
  key_name               = var.key_name
 tags = {
    Name = "private-${each.key}"
  }

}