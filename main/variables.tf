variable "general_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}










