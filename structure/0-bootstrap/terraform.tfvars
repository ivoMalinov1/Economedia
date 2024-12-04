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

org_id = "957267816772"

billing_account = "01970A-D23355-4A25EE"

group_org_admins = "gcp_group_admins@economedia.bg"

group_billing_admins = "gcp_billing_admins@economedia.bg"

default_region = "europe-west3"

parent_folder = "550503984307"

groups = {
  create_groups = true,
  groups        = {
    gcp_network_admins   = "gcp_network_admins@economedia.bg"
    gcp_data_members = "gcp_data_members@economedia.bg"
    gcp_analytics_members = "gcp_analytics_members@economedia.bg"
  }
}

members  = []
managers = []
owners   = ["todor.petkov@economedia.bg"]

