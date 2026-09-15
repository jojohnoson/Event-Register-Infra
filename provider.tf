provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket         = var.s3_bucket_name           # From your S3 setup
    key            = "dev/terraform.tfstate"      # Path inside bucket
    region         = var.region
    encrypt        = true                         # Encrypt at rest
    use_lockfile   = true                         # For state locking
  }
}

