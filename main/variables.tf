variable "general_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}




variable "db_password" {
  type    = string
  default = "00000000"
}


variable "db_user" {
  type    = string
  default = "admin"
}

variable "db_name" {
  type    = string
  default = "demo"
}


variable "custom_zone_tkc_id" {
  type = string
}