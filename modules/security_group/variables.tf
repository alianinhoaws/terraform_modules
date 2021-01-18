variable "vpc_id" {
  default = ""
}

variable "ingress_ports" {
  default = []
}

variable "cidr_block_ingress" {
  default = []
}

variable "cidr_block_egress" {
  default = []
}

variable "region" {
  default = ""
}
