variable "identifier" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}


variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}


variable "family" {
  type = string
}



variable "vpc_backend_cidr" {
  type = list(string)
}


variable "vpc_db_id" {
  type = string
}