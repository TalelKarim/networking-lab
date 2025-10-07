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
  default = "0000"
}


variable "db_user" {
  type = string
  default = ""
}

variable "db_name" {
  type = string
  default = ""
  
}