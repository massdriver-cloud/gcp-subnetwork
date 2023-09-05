locals {
  cidr = var.network.automatic ? utility_available_cidr.cidr.0.result : var.network.cidr
  # Need to compact here because the data lookup returns null subnets which are actually firewall rules
  existing_subnets = compact([for sn in data.google_compute_subnetwork.subnetworks : sn.ip_cidr_range])
}

data "google_compute_network" "global_network" {
  name = element(split("/", var.gcp_global_network.data.grn), 4)
}

data "google_compute_subnetwork" "subnetworks" {
  for_each  = toset(data.google_compute_network.global_network.subnetworks_self_links)
  self_link = each.value
}

resource "utility_available_cidr" "cidr" {
  count      = var.network.automatic ? 1 : 0
  from_cidrs = ["10.0.0.0/8", "172.16.0.0/20", "192.168.0.0/16"]
  used_cidrs = local.existing_subnets
  mask       = var.network.mask
}
