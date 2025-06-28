variable "name" {
  type        = string
  description = "Tier name (web, app, worker, etc.)"
}

variable "ami_id" {
  type        = string
  description = "AMI to use"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "subnet_ids" {
  type        = list(string)
  description = "One or more subnet IDs (AZs) to place instances"
}




variable "count_per_az" {
  type    = number
  default = 1
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "open_ports" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "List of ingress rules for the SG"
  default     = []
}



variable "desired_capacity" {
  type    = number
  default = 2
}


variable "min_capacity" {
  type    = number
  default = 2
}

variable "max_capacity" {
  type    = number
  default = 2
}


variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}


# modules/compute/variables.tf

variable "lb_type" {
  description = "Type de Load Balancer à instancier: none, application, network, gateway"
  type        = string
  default     = "none"
}
