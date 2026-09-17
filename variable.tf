variable "region" {
  description = "Region of the AWS"
  type = string
  default = "ap-south-1"
}

variable "alb_name"{
  type = string
  default = "Main-Application-LB"
}

variable "vpc_cidr" {
  description = "Region of the AWS"
  type = string
  default = "10.0.0.0/16"
}

variable "root_sub1_cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "root_sub2_cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "server_1" {
  type = string
  default = "server-1"
}

variable "server_2" {
  type = string
   default = "server-2"
}

variable "root_sub1_az" {
  type = string
  default = "ap-south-1a"
}

variable "root_sub2_az"{
  type = string
  default = "ap-south-1b"
}

variable "key_access"{
  type = string
  default = "mypassword"
}

variable "type" {
  description = "Intstance Type"
  type = map(string)

  default = {
    "dev" = "t3.micro"
    "test" = "t3.small"
    "prod" = "t3.medium"
  }
}




