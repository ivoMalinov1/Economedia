resource "google_service_account" "load_mailerlite_groups_sa" {
  account_id   = "${replace(var.function_name,"_","-")}-sa"
  display_name = "Load mailerlite groups Service Account"
  project      = local.data-prod
}

data "google_secret_manager_secret_version" "mailerlite_api_key" {
  project = local.data-prod
  secret  = "mailerlite-api-key-${local.data-prod}"
  version = "latest"
}

data "archive_file" "main" {
  type        = "zip"
  excludes    = [".mypy_cache"]
  source_dir  = "${path.root}/../src"
  output_path = "${path.root}/../build/${var.function_name}.zip"
}

resource "google_storage_bucket_object" "archive" {
  name   = filemd5("${path.root}/../build/${var.function_name}.zip")
  bucket = "cloud_functions_source_bucket_${local.data-prod}"
  source = "${path.root}/../build/${var.function_name}.zip"
}

resource "google_cloudfunctions_function" "load_groups" {
  name        = var.function_name
  project     = local.data-prod
  description = "Cloud function to migrate mailerlite groups to bigquery"
  region      = var.specific_region

  runtime               = "python311"
  available_memory_mb   = 512
  service_account_email = google_service_account.load_mailerlite_groups_sa.email
  max_instances         = 1
  source_archive_bucket = "cloud_functions_source_bucket_${local.data-prod}"
  source_archive_object = google_storage_bucket_object.archive.name

  trigger_http = true
  entry_point  = var.function_name

  environment_variables = {
    PROJECT_ID = local.data-prod
    API_KEY    = data.google_secret_manager_secret_version.mailerlite_api_key.secret_data
  }
}

resource "google_project_iam_member" "secret_manager_accessor" {
  project = local.data-prod
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.load_mailerlite_groups_sa.email}"
}

resource "google_bigquery_dataset_iam_member" "dataset_editor" {
  project    = local.data-prod
  dataset_id = "mailerlite_economedia_data_prod_laoy"
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.load_mailerlite_groups_sa.email}"
}

resource "google_project_iam_member" "bigquery_user" {
  project = local.data-prod
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${google_service_account.load_mailerlite_groups_sa.email}"
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.load_groups.project
  region         = google_cloudfunctions_function.load_groups.region
  cloud_function = google_cloudfunctions_function.load_groups.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.load_mailerlite_groups_sa.email}"
}

resource "google_cloud_scheduler_job" "job" {
  paused      = false
  name        = "${var.function_name}_scheduler"
  description = "Trigger the ${google_cloudfunctions_function.load_groups.name} Cloud Function at 00:01 on the first day on the month Europe/Sofia"

  project = local.data-prod
  region  = var.specific_region

  schedule         = "01 00 * * *"
  time_zone        = "Europe/Sofia"
  attempt_deadline = "320s"

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.load_groups.https_trigger_url

    oidc_token {
      service_account_email = google_service_account.load_mailerlite_groups_sa.email
    }
  }
}
