resource "google_service_account" "load_company_info_sa" {
  account_id   = "load-company-info-sa"
  display_name = "Load Company Info Service Account"
  project      = local.data-prod
}

resource "google_project_iam_member" "secret_manager_accessor" {
  project = local.data-prod
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.load_company_info_sa.email}"
}

resource "google_bigquery_dataset_iam_member" "dataset_editor" {
  project    = local.data-prod
  dataset_id = "salesforce_economedia_data_prod_laoy"
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.load_company_info_sa.email}"
}

resource "google_project_iam_member" "bigquery_user" {
  project = local.data-prod
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${google_service_account.load_company_info_sa.email}"
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.load_company_info.project
  region         = google_cloudfunctions_function.load_company_info.region
  cloud_function = google_cloudfunctions_function.load_company_info.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.load_company_info_sa.email}"
}

data "archive_file" "main" {
  type        = "zip"
  excludes    = [".mypy_cache"]
  source_dir  = "${path.root}/../src"
  output_path = "${path.root}/../build/${var.function_name}.zip"
}

resource "google_storage_bucket" "bucket" {
  name     = "${var.function_name}-function-bucket"
  location = var.specific_region
  project  = local.data-prod
}

resource "google_storage_bucket_object" "archive" {
  name   = filemd5("${path.root}/../build/${var.function_name}.zip")
  bucket = google_storage_bucket.bucket.name
  source = "${path.root}/../build/${var.function_name}.zip"
}

resource "google_cloudfunctions_function" "load_company_info" {
  name        = var.function_name
  project     = local.data-prod
  description = "Cloud function to migrate data from SalesForce to Big Query"
  region      = var.specific_region

  runtime               = "python311"
  available_memory_mb   = 512
  service_account_email = google_service_account.load_company_info_sa.email
  max_instances         = 1
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name

  trigger_http = true
  entry_point  = "load_company_info"

  environment_variables = {
    PROJECT_ID = local.data-prod
  }

  secret_environment_variables {
    key     = "USER"
    secret  = "salesforce-user-${local.data-prod}"
    version = "latest"
  }
  secret_environment_variables {
    key     = "PASSWORD"
    secret  = "salesforce-password-${local.data-prod}"
    version = "latest"
  }
  secret_environment_variables {
    key     = "SECRET"
    secret  = "salesforce-secret-${local.data-prod}"
    version = "latest"
  }
}

resource "google_cloud_scheduler_job" "job" {
  paused      = false
  name        = "${var.function_name}_scheduler"
  description = "Trigger the ${google_cloudfunctions_function.load_company_info.name} Cloud Function at 00:01 every day at Europe/Sofia"

  project = local.data-prod
  region  = var.specific_region

  schedule         = "01 00 * * *"
  time_zone        = "Europe/Sofia"
  attempt_deadline = "320s"

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.load_company_info.https_trigger_url

    oidc_token {
      service_account_email = google_service_account.load_company_info_sa.email
    }
  }
}
