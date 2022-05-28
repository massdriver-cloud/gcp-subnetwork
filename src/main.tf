resource "google_compute_subnetwork" "main" {
  name                     = var.md_metadata.name_prefix
  ip_cidr_range            = var.cidr
  region                   = var.gcp_region
  network                  = var.gcp_global_network.data.grn
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  name    = "${var.md_metadata.name_prefix}-router"
  network = var.gcp_global_network.data.grn
  region  = var.gcp_region
}
