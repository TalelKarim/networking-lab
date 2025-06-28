variable "general_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}










