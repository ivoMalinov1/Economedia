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

output "seed_project_id" {
  description = "Project where service accounts and core APIs will be enabled."
  value       = module.seed_bootstrap.seed_project_id
}

output "bootstrap_step_terraform_service_account_email" {
  description = "Bootstrap Step Terraform Account"
  value       = google_service_account.terraform-env-sa["bootstrap"].email
}

output "projects_step_terraform_service_account_email" {
  description = "Projects Step Terraform Account"
  value       = google_service_account.terraform-env-sa["proj"].email
}

output "networks_step_terraform_service_account_email" {
  description = "Networks Step Terraform Account"
  value       = google_service_account.terraform-env-sa["net"].email
}

output "environment_step_terraform_service_account_email" {
  description = "Environment Step Terraform Account"
  value       = google_service_account.terraform-env-sa["env"].email
}

output "organization_step_terraform_service_account_email" {
  description = "Organization Step Terraform Account"
  value       = google_service_account.terraform-env-sa["org"].email
}

output "gcs_bucket_tfstate" {
  description = "Bucket used for storing terraform state for Foundations Pipelines in Seed Project."
  value       = module.seed_bootstrap.gcs_bucket_tfstate
}

output "common_config" {
  description = "Common configuration data to be used in other steps."
  value       = {
    org_id                = var.org_id,
    parent_folder         = var.parent_folder,
    billing_account       = var.billing_account,
    default_region        = var.default_region,
    project_prefix        = var.project_prefix,
    folder_prefix         = var.folder_prefix
    parent_id             = local.parent
    bucket_prefix         = var.bucket_prefix
    bootstrap_folder_name = google_folder.bootstrap.name
  }
}

output "required_groups" {
  description = "List of Google Groups created that are required by the Foundation steps."
  value       = var.groups.create_groups == true ? module.required_group : {}
}

output "network_admins_group" {
  value = module.required_group["gcp_network_admins"].id
}

output "gcp_data_members" {
  value = module.required_group["gcp_data_members"].id
}

output "gcp_analytics_members" {
  value = module.required_group["gcp_analytics_members"].id
}

output "group_org_admins" {
  value = var.group_org_admins
}

output "group_billing_admins" {
  value = var.group_billing_admins
}