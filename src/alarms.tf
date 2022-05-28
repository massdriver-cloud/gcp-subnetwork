resource "google_monitoring_notification_channel" "massdriver_alarms" {
  display_name = "Massdriver Observability Webhook"
  type         = "webhook_tokenauth"
  labels = {
    url = var.md_metadata.observability.alarm_webhook_url
  }
  user_labels = {
    name_prefix = var.md_metadata.name_prefix
  }

  depends_on = [
    module.apis
  ]
}
