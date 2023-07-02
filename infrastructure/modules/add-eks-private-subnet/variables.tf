variable "region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "az" {
  type        = string
  description = "the aws availability zone"
  default     = "us-east-1b"

}

variable "private_subnet" {
  type    = "list"
  description = "a list of the cidr blocks used by the subnets"
  default = ["172.31.112.0","172.31.128.0"]
}

variable "eks_cluster_name" {
  type    = string
  description = "the name of the eks cluster"
  default = "demo"
}