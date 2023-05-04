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

variable "az" {
  type        = string
  description = "the aws availability zone"
  default     = "us-east-1b"

}

variable "input_personal_ip" {
  type        = string
  description = "Please input your personal ip"
}