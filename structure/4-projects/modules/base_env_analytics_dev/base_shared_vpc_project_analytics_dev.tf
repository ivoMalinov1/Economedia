/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "base_shared_vpc_project" {
  source = "../single_project"

  business_code              = var.business_code
  org_id                     = local.org_id
  billing_account            = local.billing_account
  folder_id                  = local.env_folder_name
  environment                = var.env
  vpc_type                   = "base"
  shared_vpc_host_project_id = local.base_host_project_id
  shared_vpc_subnets         = local.base_subnets_self_links
  project_budget             = var.project_budget
  project_prefix             = local.project_prefix

  // The roles defined in "sa_roles" will be used to grant the necessary permissions
  // to deploy the resources, a Compute Engine instance for each environment, defined
  // in 5-app-infra step (5-app-infra/modules/env_base/main.tf).
  // The roles are grouped by the repository name ("${var.business_code}-example-app") used to create the Cloud Build workspace
  // (https://github.com/terraform-google-modules/terraform-google-bootstrap/tree/master/modules/tf_cloudbuild_workspace)
  // in the 4-projects shared environment of each business unit.
  // the repository name is the same key used for the app_infra_pipeline_service_accounts map and the
  // roles will be granted to the service account with the same key.
  sa_roles = {
    "${var.business_code}-app" = [
      "roles/compute.instanceAdmin.v1",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountUser",
    ]
  }

  activate_apis = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "cloudscheduler.googleapis.com",
    "bigquery.googleapis.com",
  ]

  # Metadata
  project_suffix = "analytics"
  project_name   = "${var.env}-analytics"
}

module "gcs_buckets" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 3.0"

  project_id         = module.base_shared_vpc_project.project_id
  location           = var.location_gcs
  name               = "${var.bucket_prefix}-${lower(var.location_gcs)}-analytics-${var.env}-${random_string.bucket_name.result}"
  bucket_policy_only = true

  iam_members = [
    {
      role   = "roles/storage.objectAdmin"
      member = "allAuthenticatedUsers"
    }
  ]
  depends_on = [module.base_shared_vpc_project]
}