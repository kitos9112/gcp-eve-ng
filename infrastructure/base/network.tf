locals {
  subnet_01      = "${var.gcp_network_name}-subnet-01"
  subnet_01_cidr = "10.250.10.0/24"
  # subnet_02      = "${var.gcp_network_name}-subnet-02"
  # subnet_02_cidr = "10.250.20.0/24"
}

module "eve-ng-network" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.gcp_project_id
  network_name = var.gcp_network_name

  subnets = [
    {
      subnet_name   = local.subnet_01
      subnet_ip     = local.subnet_01_cidr
      subnet_region = var.gcp_region
    }
  ]

  routes = [
    {
      name              = "internet-egress"
      description       = "Route through IGW to access the Internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}
