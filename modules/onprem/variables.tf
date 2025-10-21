variable "vpc_id" {}
variable "router_subnet_id" {}
variable "ssh_allowed_cidrs" {
  default = ["0.0.0.0/0"]
}

variable "ami_id_openswan" {
  type = string
}


variable "onprem_bgp_asn" {
  description = "ASN on-prem (si tu fais BGP plus tard). Statique => valeur arbitraire."
  type        = number
  default     = 65000
}


