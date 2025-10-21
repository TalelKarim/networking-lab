variable "onprem_bgp_asn" {
  description = "ASN on-prem (si tu fais BGP plus tard). Statique => valeur arbitraire."
  type        = number
  default     = 65000
}



variable "openswan_ip_address" {
  type = string
}


variable "transit_gateway_id" {
  type = string
}