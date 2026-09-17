variable "region" {
  description = "Region of the AWS"
  type = string
}

variable "alb_name"{
  type = string
  default = "Main-Application-LB"
}

variable "vpc_cidr" {
  description = "Region of the AWS"
  type = string
}

variable "root_sub1_cidr" {
  type = string
}

variable "root_sub2_cidr" {
  type = string
}

variable "server_1" {
  type = string
}

variable "server_2" {
  type = string
}

variable "root_sub1_az" {
  type = string
}

variable "root_sub2_az"{
  type = string
}

variable "key_access"{
  type = string
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




