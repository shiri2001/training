variable "region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}
variable "add_disk" {
  type    = bool
  default = false
}

variable "vm_availability_zone" {
  type        = string
  description = "The availability zone of the vm we are attaching the volume to"
}

variable "vm_id" {
  type        = string
  description = "The ID of the vm we are attaching the volume to"
}