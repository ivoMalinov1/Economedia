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

locals {
  env              = "test"
  environment_code = substr(local.env, 0, 1)
  default_region1  = "europe-west3"
  default_region2  = "europe-west2"
  /*
   * Base network ranges
   */
  base_private_service_cidr = "10.16.128.0/21"
  base_subnet_primary_ranges = {
    (local.default_region1) = "10.0.128.0/21"
    (local.default_region2) = "10.1.128.0/21"
  }
  base_subnet_secondary_ranges = {
  }
}

module "base_env" {
  source = "../../modules/base_env"

  env                                   = local.env
  default_region1                       = local.default_region1
  default_region2                       = local.default_region2
  ingress_policies                      = var.ingress_policies
  egress_policies                       = var.egress_policies
  enable_partner_interconnect           = false
  base_private_service_cidr             = local.base_private_service_cidr
  base_subnet_primary_ranges            = local.base_subnet_primary_ranges
  base_subnet_secondary_ranges          = local.base_subnet_secondary_ranges
  base_private_service_connect_ip       = "10.2.128.5"
  remote_state_bucket                   = var.remote_state_bucket
}
