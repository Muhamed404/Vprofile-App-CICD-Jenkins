variable "AWS_REGION" {
  default = "us-east-1"
}



variable "CLUSTER_NAME" {
  type = string
}

variable "CONTAINER_NAME" {
    type = string
  
}

variable "CONTAINER_IMAGE" {
    type = string
  
}


variable "TASK_ECECUTION_ROLE_ARN" {
    default = "arn:aws:iam::441160708640:role/ecsTaskExecutionRole"
  
}




variable "LOG_GROUP_NAME" {
    default = "/ecs/vprofile/"
  
}



variable "SUBNETS" {
  type = list(string)
  default = [
    "subnet-0e5724f01d6df1e16",
    "subnet-0b2b3b165236bed36",
    "subnet-011778bac9a2e2804",
    "subnet-0fcc4bd7f0b28e72f",
    "subnet-069679805d12dc8f5",
    "subnet-094963c9357c4f930"
  ]
}

variable "ECS_SG" {
  type = list(string)
  default = [
    "sg-03c305e3140b54424"  
  ]
}