

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "BEANSTACK_ENV_NAME" {
  type = string
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


