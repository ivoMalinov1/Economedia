resource "google_bigquery_dataset" "content_dashboard" {
  project    = local.analytics-prod
  dataset_id = "content_dashboard_analytics"
  location   = "europe-west3"
}

resource "google_bigquery_dataset" "content_dashboard_dnevnik" {
  project    = local.analytics-prod
  dataset_id = "content_dashboard_dnevnik_analytics"
  location   = "europe-west3"
}


#resource "google_bigquery_dataset" "content_dashboard_test" {
#
#  for_each = {
#    analytic_prod = local.analytics-prod
#    data_dev = local.data-dev
#  }
#
#  project    = each.value
#  dataset_id = "content_dashboard_test_analytics"
#  location   = "europe-west3"
#}
