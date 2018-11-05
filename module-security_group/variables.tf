variable "tags" {
  default = {}
}

variable "security_group_name" {}

variable "security_group_description" {}

variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  default     = []
}

variable "ingress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR ranges to use on all ingress rules"
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  default     = []
}

variable "ingress_prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints) to use on all ingress rules"
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  default     = []
}

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  default     = []
}

variable "ingress_with_source_security_group_id_count" {
  description = "Number of ingress rules to create where 'source_security_group_id' is used"
  default     = 0
}




variable "egress_rules" {
  description = "List of egress rules to create by name"
  default     = []
}

variable "egress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR ranges to use on all egress rules"
  default     = []
}

variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  default     = []
}

variable "egress_prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints) to use on all egress rules"
  default     = []
}

variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  default     = []
}

variable "egress_with_source_security_group_id" {
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  default     = []
}

variable "egress_with_source_security_group_id_count" {
  description = "Number of egress rules to create where 'source_security_group_id' is used"
  default     = 0
}
variable "vpc_id" {}