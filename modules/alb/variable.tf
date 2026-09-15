variable "security_group"{
    description = "Security Group"
    type = list(string)
}

variable "environment" {
  type        = string
  description = "The current deployment workspace/environment name"
}

variable "subnets" {
  description = "List of Subnet IDs for ALB"
  type        = list(string)
}

variable "alb_name"{
    type = string
}

variable "vpc_id"{
    type = string
}

variable "instance_ids" {
  type        = map(string)
  description = "Map of instance identifiers to instance IDs"
}