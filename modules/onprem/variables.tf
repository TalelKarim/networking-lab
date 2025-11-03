variable "vpc_id" {}
variable "router_subnet_id" {}
variable "ssh_allowed_cidrs" {
  default = ["0.0.0.0/0"]
}

variable "ami_id_openswan" {
  type = string
}


variable "vpc_web_cidr" { type = string }    # ex: "10.0.1.0/24"
variable "vpc_app_cidr" { type = string }    # ex: "10.0.2.0/24"
variable "vpc_shared_cidr" { type = string } # ex: "10.0.3.0/24"
variable "onprem_private_subnet_id" {
  type = string
}


variable "vpc_onprem_cidr" {
  type = string
}

variable "onprem_bgp_asn" {
  description = "ASN on-prem (si tu fais BGP plus tard). Statique => valeur arbitraire."
  type        = number
  default     = 65000
}

variable "tunn_1_outside_ip" {
  type = string
}

variable "tunn_2_outside_ip" {
  type = string
}

variable "tunn_1_psk" {
  type = string
}

variable "tunn_2_psk" {

}

variable "cidrs_to_aws" {
  type = list(string)
}


variable "onprem_private_rt_id" {
  type = string
}

