module "apis" {
  source = "../../../provisioners/terraform/modules/gcp-apis"
  services = [
    # needed for MD alarms
    "monitoring.googleapis.com"
  ]
}
