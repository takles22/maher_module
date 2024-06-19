variable "region" {
  type = string
  default = "us-east-1"
}

variable "profile" {
  type = string
  default ="terraform-dev"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
  type = string
}

variable "tags" {
  default = {
    Name = "maher-west"
  }
}

variable "instance_type" {
  default = "t2.micro"
  type = string
}

variable "enable_dns_hostnames" {
  type = bool
  default = true
}

variable "associate_public_ip_address" {
  type = bool
  default = true
  
}

variable "key_name" {
  type = string
  default = "key_name"
}


variable "allow_cidr_block" {
  default = "10.0.0.0/16"
  type = string
}

variable "public_external_port" {
default = [0,22]
type = list(number)
}

variable "public_internal_port" {
default = [0,22]
type = list(number)
}

variable "private_external_port" {
default = [22]
type = list(number)
}

variable "private_internal_port" {
default = [22]
type = list(number)
}
