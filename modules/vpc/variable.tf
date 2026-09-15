variable "vpc_cidr_block"{
    description = "VPC CIDR"
    type = string
    default = "10.0.0.0/16"
}

variable "environment" {
  type        = string
  description = "The current deployment workspace/environment name"
}


variable "rt-1_cidrblock"{
    description = "Route for IGW"
    type = string
    default = "0.0.0.0/0"
}

variable "sub1_az" {
   description = "Subnet 1 AZ"
    type = string
    default = "ap-south-1a"
}

variable "sub2_az"{
    description = "Subnet 2 AZ"
    type = string
    default = "ap-south-1b"
}

variable "sub1_cidr_block" {
  description = "Subnet 1 cidr block"
    type = string
    default = "10.0.1.0/24"
}

variable "sub2_cidr_block" {
  description = "Subnet 2 cidr block"
    type = string
    default = "10.0.2.0/24"
}

variable "rt-2_cidrblock"{
    description = "rt-2 Cidr_Block"
    type = string
    default = "0.0.0.0/0"
}




