resource "google_bigquery_dataset" "subscriptions_dashboard" {
  project    = local.analytics-prod
  dataset_id = "subscriptions_dashboard"
  location   = "europe-west3"
}
