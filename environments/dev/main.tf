module "spoke_vpc" {
  source        = "../../modules/spoke_vpc"
  project_id    = var.project_id
  region        = var.region
  env           = var.env
  subnet_cidr   = "10.1.0.0/24"
  pods_cidr     = "10.1.128.0/17"
  services_cidr = "10.1.64.0/20"
}

module "vpc_peering" {
  source              = "../../modules/vpc_peering"
  project_id          = var.project_id
  hub_project_id      = "gcpai-iac-dev"
  env                 = var.env
  hub_vpc_self_link   = var.hub_vpc_self_link
  spoke_vpc_self_link = module.spoke_vpc.vpc_self_link

  depends_on = [module.spoke_vpc]
}