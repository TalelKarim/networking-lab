variable "vpc_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "vpc_name" {
  type    = string
  default = "lab-vpc"
}

variable "is_public" {
  type        = bool
  default     = false
  description = "variable to define if there are public subnets"
}

variable "is_tgw" {
  type        = bool
  default     = false
  description = "variable to define if there is a transit gateway attachement to the vpc"
}

variable "is_private" {
  type        = bool
  default     = false
  description = "variable to define if there are private subnets"
}

variable "public_subnets_cidrs" {
  type    = list(string)
  default = []
}

variable "intra_subnets_cidrs" {
  type    = list(string)
  default = []
}

variable "private_subnets_cidrs" {
  type    = list(string)
  default = []
}

variable "availability_zones" {
  type    = list(string)
  default = []
}

variable "enable_vpn_gateway" {
  type    = bool
  default = false
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "role" {
  type    = string
  default = "vpc"
}



variable "transit_gateway_id" {
  type = string
}


variable "tgw_destination_cidr_block" {
  type = list(string)
}