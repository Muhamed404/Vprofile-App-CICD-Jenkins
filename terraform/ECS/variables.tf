variable "AWS_REGION" {
  default = "us-east-1"
}



variable "CLUSTER_NAME" {
  default = "vprofile-test-RUNID"
}

variable "TASK_ECECUTION_ROLE_ARN" {
    default = "arn:aws:iam::441160708640:role/ecsTaskExecutionRole"
  
}


variable "CONTAINER_NAME" {
    default = "vprofile-tomcat-RUNID"
  
}

variable "CONTAINER_IMAGE" {
    default = "441160708640.dkr.ecr.us-east-1.amazonaws.com/vprofile-app:latest"
  
}


variable "RDS_USERNAME" {
    default = "admin"
  
}

variable "RDS_PASSWORD" {
    default = "ZCy4mYHcEdZFiKd0rB0d"
  
}

variable "RABBITMQ_USERNAME" {
    default = "rabbit"
  
}

variable "RABBITMQ_PASSWORD" {
    default = "WeListen2025"
  
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