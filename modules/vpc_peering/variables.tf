variable "project_id" {
  type        = string
  description = "Project where peering is created"
}

variable "hub_project_id" {
  type        = string
  description = "Project ID of the hub VPC"
}

variable "env" {
  type        = string
  description = "Environment name (dev or prod)"
}

variable "hub_vpc_self_link" {
  type        = string
  description = "Self link of the hub VPC"
}

variable "spoke_vpc_self_link" {
  type        = string
  description = "Self link of the spoke VPC"
}