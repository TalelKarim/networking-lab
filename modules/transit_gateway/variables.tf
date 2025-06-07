variable "name" {
  description = "A human‐readable name (tag) for the Transit Gateway"
  type        = string
}

variable "amazon_side_asn" {
  description = "The private Autonomous System Number (ASN) for the Amazon side of the TGW. Default: 64512"
  type        = number
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  type    = string
  default = "disable"
}

variable "default_route_table_association" {
  type    = string
  default = "enable"
}

variable "default_route_table_propagation" {
  type    = string
  default = "enable"
}

variable "tags" {
  description = "Additional tags (map) to apply to the Transit Gateway"
  type        = map(string)
  default     = {}
}
