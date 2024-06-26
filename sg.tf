
# sg for load blancer
# resource "aws_security_group" "terra-bean-elb-sg" {

# name = "terra-bean-elb-sg"

# description = "Security group for bean-elb"

# vpc_id = module.vpc.vpc_id

# egress {

# from_port = 0

# protocol = "-1"

# to_port = 0

# cidr_blocks = ["0.0.0.0/0"]

# }

# ingress {

# from_port = 80

# protocol = "tcp"

# to_port = 80

# cidr_blocks = ["0.0.0.0/0"]

# }

# }

#sg for Public instance
resource "aws_security_group" "terra-public-sg" {

name = "public-sg"

description = "Security group for bastionisioner ec2 instance"

vpc_id = aws_vpc.cus_vpc.id

dynamic "egress" {
    for_each = var.public_external_port
    iterator = "port"
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

}

dynamic "ingress" {
    for_each = var.public_external_port
    iterator = "port"
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

}

#sg for Private instance
resource "aws_security_group" "terra-private-sg" {

name = "private-sg"

description = "Security group for private ec2 instance"

vpc_id = aws_vpc.cus_vpc.id

dynamic "egress" {
    for_each = var.private_external_port
    iterator = "port"
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

}

dynamic "ingress" {
    for_each = var.private_internal_port
    iterator = "port"
    content {
    
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

}



# resource "aws_security_group" "terra-prod-sg" {

# name = "terra-prod-sg"

# description = "Security group for beanstalk instances"

# vpc_id = module.vpc.vpc_id

# egress {

# from_port = 0

# to_port = 0

# protocol = "-1"

# cidr_blocks = ["0.0.0.0/0"]

# }

# ingress {

# from_port = 22

# protocol = "tcp"

# to_port = 22

# security_groups = [aws_security_group.terra-bastion-sg.id]

# }

# }

# resource "aws_security_group" "terra-backend-sg" {

# name = "terra-backend-sg"

# description = "Security group for RDS, active mq, elastic cache"

# vpc_id = aws_vpc.cus_vpc.id

# egress {

# from_port = 0

# protocol = "-1"

# to_port = 0

# cidr_blocks = ["0.0.0.0/0"]

# }

# ingress {

# from_port = 0

# protocol = "-1"

# to_port = 0

# security_groups = [aws_security_group.terra-bastion-sg.id]

# }

# ingress {

# from_port = 3306

# protocol = "tcp"

# to_port = 3306

# security_groups = [aws_security_group.terra-bastion-sg.id]

# }

# }

# resource "aws_security_group_rule" "sec_group_allow_itself" {

# from_port = 0

# protocol = "tcp"

# to_port = 65535

# type = "ingress"

# security_group_id = aws_security_group.terra-backend-sg.id

# source_security_group_id = aws_security_group.terra-backend-sg.id

# }