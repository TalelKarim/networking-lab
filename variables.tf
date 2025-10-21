variable "aws_region" {
  description = "Région AWS pour ce déploiement"
  type        = string
  default     = "eu-west-1"
}

variable "common_tags" {
  description = "Tags communs à toutes les ressources (Environment, Project, Owner, etc.)"
  type        = map(string)
  default = {
    Environment = "lab"
    Project     = "aws-networking-lab"
  }
}

# variable "onprem_public_ip" {
#   description = "Adresse IP publique du openswan on-premise (pour le Customer Gateway)"
#   type        = string
# }

