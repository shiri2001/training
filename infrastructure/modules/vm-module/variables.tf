variable "region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "app_instance_type" {
  type        = string
  description = "The EC2 instance type"
  default     = "t2.micro"
}
variable "key_name" {
  type        = string
  description = "The key pair name"
}
variable "private_security_group_id" {
  type        = list
  description = "The ID of the private security group the vm belongs to"
}

variable "private_subnet_id" {
  type        = string
  description = "The ID of the private subnet the vm belongs to"
}