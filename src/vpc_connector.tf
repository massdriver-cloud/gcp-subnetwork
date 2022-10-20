# vpc connectors
# needed for Cloud Run / Cloud Functions to access Redis, Postgres, etc.
# min $14 a month each

# one per subnet
# added to the subnet artifact to be shared with serverless apps in that region

# This breaks if someone makes two subnet packages in the same region, in the same VPC.
# That's pretty unlikely but this should be replaced with md-terraform-utils eventually.
locals {
  ranges = {
    asia-east1              = "10.253.0.0/28"
    asia-east2              = "10.253.0.16/28"
    asia-northeast1         = "10.253.0.32/28"
    asia-northeast2         = "10.253.0.48/28"
    asia-northeast3         = "10.253.0.64/28"
    asia-south1             = "10.253.0.80/28"
    asia-south2             = "10.253.0.96/28"
    asia-southeast1         = "10.253.0.112/28"
    asia-southeast2         = "10.253.0.128/28"
    australia-southeast1    = "10.253.0.144/28"
    australia-southeast2    = "10.253.0.160/28"
    europe-central2         = "10.253.0.176/28"
    europe-north1           = "10.253.0.192/28"
    europe-southwest1       = "10.253.0.208/28"
    europe-west1            = "10.253.0.224/28"
    europe-west2            = "10.253.0.240/28"
    europe-west3            = "10.254.0.0/28"
    europe-west4            = "10.254.0.16/28"
    europe-west6            = "10.254.0.32/28"
    europe-west8            = "10.254.0.48/28"
    europe-west9            = "10.254.0.64/28"
    me-west1                = "10.254.0.80/28"
    northamerica-northeast1 = "10.254.0.96/28"
    northamerica-northeast2 = "10.254.0.112/28"
    southamerica-east1      = "10.254.0.128/28"
    southamerica-west1      = "10.254.0.144/28"
    us-central1             = "10.254.0.160/28"
    us-east1                = "10.254.0.176/28"
    us-east4                = "10.254.0.192/28"
    us-east5                = "10.254.0.208/28"
    us-south1               = "10.254.0.224/28"
    us-west1                = "10.254.0.240/28"
    us-west2                = "10.252.0.0/28"
    us-west3                = "10.252.0.16/28"
    us-west4                = "10.252.0.32/28"
  }

  name_max_length = 25
  safe_name       = trimsuffix(substr(var.md_metadata.name_prefix, 0, local.name_max_length), "-")
}

# cost per month
#     f1-micro  | e2-micro
# min $13.29    | $14.69
resource "google_vpc_access_connector" "shared" {
  provider = google-beta
  # max 25 characters
  name          = local.safe_name
  region        = var.gcp_region
  ip_cidr_range = local.ranges[var.gcp_region]
  # in Mbps
  min_throughput = 200
  max_throughput = 500
  machine_type   = "f1-micro"
  network        = var.gcp_global_network.data.grn

  depends_on = [module.apis]
}
