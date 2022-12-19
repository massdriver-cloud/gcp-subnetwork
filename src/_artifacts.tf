
resource "massdriver_artifact" "subnetwork" {
  field                = "subnetwork"
  provider_resource_id = google_compute_subnetwork.main.id
  name                 = "${google_compute_subnetwork.main.region} - ${var.md_metadata.name_prefix}"
  artifact = jsonencode(
    {
      data = {
        infrastructure = {
          grn                    = google_compute_subnetwork.main.id
          cidr                   = google_compute_subnetwork.main.ip_cidr_range
          gcp_global_network_grn = var.gcp_global_network.data.grn
          vpc_access_connector   = google_vpc_access_connector.shared.id
        }
      }
      specs = {
        gcp = {
          project  = google_compute_subnetwork.main.project
          region   = google_compute_subnetwork.main.region
          service  = "compute"
          resource = "subnetwork"
        }
      }
    }
  )
}
