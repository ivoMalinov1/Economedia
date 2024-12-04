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

output "base_shared_vpc_project_data" {
  description = "Project sample base project."
  value       = module.env_data_dev.base_shared_vpc_project
}

output "base_shared_vpc_project_sa_data" {
  description = "Project sample base project SA."
  value       = module.env_data_dev.base_shared_vpc_project_sa
}

output "base_subnets_self_links_data" {
  value       = module.env_data_dev.base_subnets_self_links
  description = "The self-links of subnets from base environment."
}

output "base_shared_vpc_project_analytics" {
  description = "Project sample base project."
  value       = module.env_analytics_dev.base_shared_vpc_project
}

output "base_shared_vpc_project_sa_analytics" {
  description = "Project sample base project SA."
  value       = module.env_analytics_dev.base_shared_vpc_project_sa
}

output "base_subnets_self_links_analitycs" {
  value       = module.env_analytics_dev.base_subnets_self_links
  description = "The self-links of subnets from base environment."
}