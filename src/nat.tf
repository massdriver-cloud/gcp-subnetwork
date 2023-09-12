resource "google_compute_router_nat" "nat" {
  name   = "${var.md_metadata.name_prefix}-nat"
  router = google_compute_router.router.name
  region = google_compute_router.router.region

  // Eventually we should manually configure IPs, but if we do that we need
  // Auto SRE to monitor NAT usage and scale when appropriate
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
