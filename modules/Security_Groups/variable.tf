variable "alb_name" {
  type = string
}

variable "vpc_id"{
    type = string
}

variable "environment" {
  type        = string
  description = "The current deployment workspace/environment name"
}
