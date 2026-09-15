variable "vpc_id" {
  type = string
}

variable "ami_id" {
  description = "AMI ID OF UBUNTU"
  type = string
  default = "ami-01a00762f46d584a1"
}

variable "key_pair" {
  description = "Key Pair to SSH"
  type = string
  default = "mypassword"
}

variable "alb_name" {
  type = string
}

variable "subnet_id"{
  type = string
}

variable "ec2_type" {
  description = "Server-1 Instance Type"
  type = string
  default = "t3.micro"
}

variable "sg" {
  type = list(string)
}

variable "environment" {
  type        = string
  description = "The current deployment workspace/environment name"
}

variable "instance_name" {
  description = "Name of the Instance"
  type = string
  default = "My-Server"
}

variable "sub1_id" {
  description = "Instance for Subnet 1"
  type = string
  default = "10.0.1.0/24"
}

variable "sub2_id" {
  description = "Instance for Subnet 2"
  type = string
   default = "10.0.2.0/24"
}

variable "associate_public_ip"{
  description = "Public Association"
  type = string
}




