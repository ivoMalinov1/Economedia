resource "google_bigquery_dataset" "newsletter_dashboard" {

  for_each = {
    data_prod = local.analytics-prod
  }

  project    = each.value
  dataset_id = "newsletter_dashboard_${replace(each.value, "-","_")}"
  location   = "europe-west3"
}
