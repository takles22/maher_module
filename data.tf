# data for ami 
data "aws_ami" "amazon" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.202*"]
  }

  filter {
    name   = "virtualization-type" 
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}