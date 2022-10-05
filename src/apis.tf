module "apis" {
  source = "github.com/massdriver-cloud/terraform-modules//gcp-enable-apis?ref=c336d59"
  services = [
    # needed for MD alarms
    "monitoring.googleapis.com",
    "vpcaccess.googleapis.com"
  ]
}
