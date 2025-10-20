variable "vpc_id" {}
variable "router_subnet_id" {}
variable "ssh_allowed_cidrs" {
  default = ["0.0.0.0/0"]
}
