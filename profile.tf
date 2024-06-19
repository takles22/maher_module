provider "aws" {
  region  = var.region
  profile = var.profile
}

# terraform {
#   backend "s3" {
#     bucket = "terraform-state551"
#     key    = "terraform/state.tfstate"
#     encrypt = true
#     region = var.region
#     profile = var.profile
#   }
# }

# create S3 to store terrafom state file (terraform.tfstate)
# resource "aws_s3_bucket" "example" {
#   bucket = "terraform-state551"
#   tags = var.tags
# }
