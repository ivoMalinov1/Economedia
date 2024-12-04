/**
 * Copyright 2022 Google LLC
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
 **/


locals {
  group_data_members = data.terraform_remote_state.bootstrap.outputs.gcp_data_members
  group_analytics_members = data.terraform_remote_state.bootstrap.outputs.gcp_analytics_members
}

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/bootstrap/state"
  }
}

module "env_data_dev" {
  source = "../../modules/base_env_data_dev"

  env                       = "development"
  business_code             = "dev"
  business_unit             = "platform"
  remote_state_bucket       = var.remote_state_bucket
  location_kms              = var.location_kms
  location_gcs              = var.location_gcs
  peering_module_depends_on = var.peering_module_depends_on
}

module "env_analytics_dev" {
  source = "../../modules/base_env_analytics_dev"

  env                       = "development"
  business_code             = "dev"
  business_unit             = "platform"
  remote_state_bucket       = var.remote_state_bucket
  location_kms              = var.location_kms
  location_gcs              = var.location_gcs
  peering_module_depends_on = var.peering_module_depends_on
}

module "project-analytics-iam-group-bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [module.env_analytics_dev.base_shared_vpc_project]

  bindings = {
    "roles/editor" = [
      "group:gcp_analytics_members@economedia.bg"
    ]
  }
}

module "project-data-iam-group-bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  projects = [module.env_data_dev.base_shared_vpc_project]

  bindings = {
    "roles/cloudfunctions.invoker" = [
      "group:gcp_data_members@economedia.bg"
    ],
    "roles/editor" = [
      "group:gcp_data_members@economedia.bg"
    ]
  }
}