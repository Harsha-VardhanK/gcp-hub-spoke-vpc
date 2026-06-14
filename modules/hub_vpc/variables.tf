variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-south1"
}

variable "env" {
  type    = string
  default = "hub"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}