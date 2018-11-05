variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  default     = "0.0.0.0/0"
}

variable "vpc_name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  default = ""
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route tables"
}

variable "private_route_table_tags" {
  description = "Additional tags for the public route tables"
  default=""
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  default = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  default = []
}

variable "azs" {
  description = "A list of availability zones in the region"
  default = []
}


variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = false
}

variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips)"
  type        = "list"
  default     = []
}