provider "aws" {
  region = var.region
}


# terraform {
#   backend "s3" {
#     bucket         = "joel-tfstate-s3-bucket"        # From your S3 setup
#     key            = "dev/terraform.tfstate"      # Path inside bucket
#     region         = "ap-south-1"
#     encrypt        = true                         # Encrypt at rest
#     use_lockfile   = true                         # For state locking
#   }
# }

