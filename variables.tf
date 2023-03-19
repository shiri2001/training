variable "region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "my_instance_type" {
  type        = string
  description = "The EC2 instance type"
  default     = "t2.micro"
}

variable "input_ip" {
  type = string
}
