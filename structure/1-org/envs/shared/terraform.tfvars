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

# Must include the domain of the organization you are deploying the foundation.
domains_to_allow = ["economedia.bg"]

essential_contacts_domains_to_allow = ["@economedia.bg"]

billing_data_users = "gcp_billing_admins@economedia.bg"

audit_data_users = "gcp_billing_admins@economedia.bg"

scc_notification_name = "scc-notify"

remote_state_bucket = "bkt-economedia-seed-tfstate-24e8"

create_unique_tag_key = true
