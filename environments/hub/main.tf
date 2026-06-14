module "hub_vpc" {
  source      = "../../modules/hub_vpc"
  project_id  = var.project_id
  region      = var.region
  env         = var.env
  subnet_cidr = "10.0.0.0/24"
}

