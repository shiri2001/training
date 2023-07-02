terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "aws" {
  region = var.region
}

module "bastion" {
  source            = "..//modules/bastion-module"
  region            = var.region
  input_personal_ip = var.input_personal_ip
}

module "add_vm" {
  source                    = "..//modules/vm-module"
  region                    = var.region
  key_name                  = module.bastion.key_name
  private_security_group_id = module.bastion.private_security_group_id
  private_subnet_id         = module.bastion.private_subnet_id
}

module "add_vol" {
  source               = "..//modules/add-vol-to-vm-module"
  region               = var.region
  vm_availability_zone = module.add_vm.vm_availability_zone
  vm_id                = module.add_vm.vm_id
  add_disk             = true
}
