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

variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate projects with."
  type        = string
}

variable "group_org_admins" {
  description = "Google Group for GCP Organization Administrators"
  type        = string
}

variable "group_billing_admins" {
  description = "Google Group for GCP Billing Administrators"
  type        = string
}

variable "default_region" {
  description = "Default region to create resources where applicable."
  type        = string
  default     = "europe-west3"
}

variable "parent_folder" {
  description = "Optional - for an organization with existing projects or for development/validation. It will place all the example foundation resources under the provided folder instead of the root organization. The value is the numeric folder ID. The folder must already exist."
  type        = string
  default     = ""
}

variable "org_project_creators" {
  description = "Additional list of members to have project creator role across the organization. Prefix of group: user: or serviceAccount: is required."
  type        = list(string)
  default     = []
}

variable "org_policy_admin_role" {
  description = "Additional Org Policy Admin role for admin group. You can use this for testing purposes."
  type        = bool
  default     = false
}

variable "project_prefix" {
  description = "Name prefix to use for projects created. Should be the same in all steps. Max size is 3 characters."
  type        = string
  default     = "economedia"
}

variable "folder_prefix" {
  description = "Name prefix to use for folders created. Should be the same in all steps."
  type        = string
  default     = "fldr-economedia"
}

variable "bucket_prefix" {
  description = "Name prefix to use for state bucket created."
  type        = string
  default     = "bkt-economedia"
}

variable "bucket_force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects."
  type        = bool
  default     = false
}

/* ----------------------------------------
    Specific to Groups creation
   ---------------------------------------- */
variable "groups" {
  description = "Contain the details of the Groups to be created."
  type        = object({
    create_groups = bool
    groups        = object({
      gcp_network_admins   = string
      gcp_data_members = string
      gcp_analytics_members = string
    })
  })
  default = {
    create_groups = false
    groups        = {
      gcp_network_admins   = ""
      gcp_data_members = ""
      gcp_analytics_members = ""
    }
  }

  validation {
    condition     = var.groups.create_groups == true ? (var.groups.groups.gcp_data_members != "" ? true : false) : true
    error_message = "The group gcp_group_data_members is invalid, it must be a valid email."
  }

  validation {
    condition     = var.groups.create_groups == true ? (var.groups.groups.gcp_analytics_members != "" ? true : false) : true
    error_message = "The group gcp_group_analytics_members is invalid, it must be a valid email."
  }

  validation {
    condition     = var.groups.create_groups == true ? (var.groups.groups.gcp_network_admins != "" ? true : false) : true
    error_message = "The group gcp_group_network_admins is invalid, it must be a valid email."
  }
}


variable "owners" {
  type = list(string)
}

variable "managers" {
  type = list(string)
}

variable "members" {
  type = list(string)
}

variable "initial_group_config" {
  description = "Define the group configuration when it are initialized. Valid values are: WITH_INITIAL_OWNER, EMPTY and INITIAL_GROUP_CONFIG_UNSPECIFIED."
  type        = string
  default     = "WITH_INITIAL_OWNER"
}
