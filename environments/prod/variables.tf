variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-south1"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "hub_vpc_self_link" {
  type        = string
  description = "Self link of the hub VPC for peering"
}