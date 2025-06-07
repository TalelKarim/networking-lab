variable "subnet_ids" {
  type    = list(string)
  default = []
}


variable "transit_gateway_id" {
  type    = string
  default = ""
}


variable "vpc_id" {
  type    = string
  default = ""
}

variable "tgw_attachement_name" {
  type    = string
  default = ""
}