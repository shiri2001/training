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

variable "my_instance_type" {
  type        = string
  description = "The EC2 instance type"
  default     = "t2.micro"
}

variable "input_ip" {
  type = string
}

variable "add_disk" {
  type    = bool
  default = false
}
