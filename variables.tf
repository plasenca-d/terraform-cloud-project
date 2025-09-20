variable "virginia_cidr" {
  description = "CIDR Virginia"
  type        = string
  # sensitive   = true
}


# variable "public_subnet" {
#   description = "Public Subnet"
#   type        = string
# }

# variable "private_subnet" {
#   description = "Private Subnet"
#   type        = string
# }

variable "subnets" {
  description = "Subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}

variable "sg_ingress_cidr" {
  description = "CIDR block to allow SSH access"
  type        = string
}

variable "ec2_specs" {
  description = "EC2 specs"
  type        = map(string)
}

variable "enable_monitoring" {
  description = "Enable Monitoring"
  type        = bool
}

variable "ingress_ports_list" {
  description = "Lista de puertos de ingress"
  type        = list(number)
}
