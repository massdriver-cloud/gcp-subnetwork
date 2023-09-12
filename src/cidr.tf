locals {
  cidr = var.network.automatic ? utility_available_cidr.cidr.0.result : var.network.cidr
  # Need to compact here because the data lookup returns null subnets which are actually firewall rules
  primary_cidrs   = compact([for ps in data.google_compute_subnetwork.subnetworks : ps.ip_cidr_range])
  secondary_cidrs = compact([for ss in data.google_compute_subnetwork.subnetworks : try(ss.secondary_ip_range.ip_cidr_range, null)])
}

data "google_compute_network" "global_network" {
  count = var.network.automatic ? 1 : 0
  name  = element(split("/", var.gcp_global_network.data.grn), 4)
}

data "google_compute_subnetwork" "subnetworks" {
  for_each  = var.network.automatic ? toset(data.google_compute_network.global_network[0].subnetworks_self_links) : toset([])
  self_link = each.value
}

resource "utility_available_cidr" "cidr" {
  count      = var.network.automatic ? 1 : 0
  from_cidrs = ["10.0.0.0/8", "172.16.0.0/20", "192.168.0.0/16"]
  used_cidrs = concat(local.primary_cidrs, local.secondary_cidrs)
  mask       = var.network.mask
}
