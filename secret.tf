resource "aws_key_pair" "terraformkey" {

key_name = var.key_name

public_key = file("~/.ssh/ec2_key.pub")

}

variable "db_instance_password" {
  type = string
  default = "memoo2024"
}

variable "mq_broker_password" {
  type = map(any)
  default = {
    username = "maher"
    password = "memoo20242024"
  }
}