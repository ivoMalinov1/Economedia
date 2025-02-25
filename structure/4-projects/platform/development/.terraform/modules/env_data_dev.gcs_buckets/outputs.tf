/**
 * Copyright 2018 Google LLC
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

output "bucket" {
  description = "Bucket resource (for single use)."
  value       = local.first_bucket
}

output "name" {
  description = "Bucket name (for single use)."
  value       = local.first_bucket.name
}

output "url" {
  description = "Bucket URL (for single use)."
  value       = local.first_bucket.url
}

output "buckets" {
  description = "Bucket resources as list."
  value       = local.buckets_list
}

output "buckets_map" {
  description = "Bucket resources by name."
  value       = google_storage_bucket.buckets
}

output "names" {
  description = "Bucket names."
  value = { for name, bucket in google_storage_bucket.buckets :
    name => bucket.name
  }
}

output "urls" {
  description = "Bucket URLs."
  value = { for name, bucket in google_storage_bucket.buckets :
    name => bucket.url
  }
}

output "names_list" {
  description = "List of bucket names."
  value       = local.buckets_list[*].name
}

output "urls_list" {
  description = "List of bucket URLs."
  value       = local.buckets_list[*].url
}
